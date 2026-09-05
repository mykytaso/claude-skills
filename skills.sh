#!/usr/bin/env bash
# Copies this repo's skills into ~/.claude/skills.
# No flag:     installs and refreshes the skills. It deletes no folder.
# --update:    the same, and it also removes a skill that this repo deleted.
# --uninstall: removes the skills that this repo installed.
# Does not touch a skill that came from a different source.

set -u

destination_skills_folder="$HOME/.claude/skills"
manifest_file="$HOME/.claude/.myk-installed-skills"

# --- Helpers -----------------------------------------------------------------

# Fills manifest_skill_names with the names in the manifest.
# A line that starts with "#" is not a name.
manifest_skill_names=()
read_manifest_names() {
  manifest_skill_names=()
  [ -f "$manifest_file" ] || return 0
  while IFS= read -r manifest_line; do
    case "$manifest_line" in
      \#*|"") continue ;;
    esac
    manifest_skill_names+=("$manifest_line")
  done < "$manifest_file"
}

is_in_list() {
  search_value="$1"
  shift
  for list_item in "$@"; do
    [ "$list_item" = "$search_value" ] && return 0
  done
  return 1
}

print_report_list() {
  list_title="$1"
  shift
  if [ "$#" -eq 0 ]; then
    echo "$list_title: none"
  else
    echo "$list_title:"
    for report_item in "$@"; do
      echo "  $report_item"
    done
  fi
}

# --- Arguments ---------------------------------------------------------------

run_uninstall=0
# Only --update removes a skill that this repo deleted.
run_update=0
case "${1:-}" in
  "") ;;
  --update) run_update=1 ;;
  --uninstall) run_uninstall=1 ;;
  *)
    echo "Usage: skills.sh [--update | --uninstall]"
    exit 1
    ;;
esac

# --- Uninstall ---------------------------------------------------------------

if [ "$run_uninstall" -eq 1 ]; then
  echo "Destination: $destination_skills_folder"
  echo

  if [ ! -f "$manifest_file" ]; then
    echo "No manifest at $manifest_file. This repo installed no skill."
    exit 0
  fi

  manifest_source_line="$(grep -m1 '^# source:' "$manifest_file")"
  [ -n "$manifest_source_line" ] || manifest_source_line="# source: unknown"
  read_manifest_names

  removable_skills=()
  unsafe_skills=()
  # A folder that stays in place keeps its manifest line.
  kept_skill_names=()

  for manifest_skill_name in ${manifest_skill_names[@]+"${manifest_skill_names[@]}"}; do
    case "$manifest_skill_name" in
      */*|.|..|"")
        unsafe_skills+=("$manifest_skill_name (bad name)")
        kept_skill_names+=("$manifest_skill_name")
        continue
        ;;
    esac
    candidate_folder="$destination_skills_folder/$manifest_skill_name"
    if [ ! -d "$candidate_folder" ]; then
      unsafe_skills+=("$manifest_skill_name (no folder)")
      continue
    fi
    if [ ! -f "$candidate_folder/SKILL.md" ]; then
      unsafe_skills+=("$manifest_skill_name (no SKILL.md)")
      kept_skill_names+=("$manifest_skill_name")
      continue
    fi
    removable_skills+=("$manifest_skill_name")
  done

  removed_skills=()
  if [ ${#removable_skills[@]} -eq 0 ]; then
    echo "No skill folder to remove."
    echo
  else
    echo "These folders will be deleted:"
    for removable_skill_name in "${removable_skills[@]}"; do
      echo "  $destination_skills_folder/$removable_skill_name"
    done
    printf "Delete them? [y/N] "
    read -r delete_answer
    if [ "$delete_answer" != "y" ] && [ "$delete_answer" != "Y" ]; then
      echo "Cancelled. Nothing was deleted."
      exit 0
    fi
    for removable_skill_name in "${removable_skills[@]}"; do
      rm -rf "$destination_skills_folder/$removable_skill_name"
      removed_skills+=("$removable_skill_name")
    done
    echo
  fi

  if [ ${#kept_skill_names[@]} -eq 0 ]; then
    rm -f "$manifest_file"
    manifest_state="Manifest: deleted"
  else
    {
      echo "$manifest_source_line"
      for kept_skill_name in "${kept_skill_names[@]}"; do
        echo "$kept_skill_name"
      done
    } > "$manifest_file"
    manifest_state="Manifest: kept, for the folders that stay"
  fi

  print_report_list "Removed"     ${removed_skills[@]+"${removed_skills[@]}"}
  print_report_list "Not touched" ${unsafe_skills[@]+"${unsafe_skills[@]}"}
  echo "$manifest_state"
  echo
  echo "Run \`/reload-skills\`, or start a new session, to use the changes."
  exit 0
fi

# --- Step 1: find the source skills folder -----------------------------------

script_folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_skills_folder=""

if [ -d "$script_folder/skills" ]; then
  source_skills_folder="$script_folder/skills"
elif [ -f "$manifest_file" ]; then
  manifest_source_path="$(grep -m1 '^# source:' "$manifest_file" | sed 's/^# source:[[:space:]]*//')"
  if [ -n "$manifest_source_path" ] && [ -d "$manifest_source_path" ]; then
    source_skills_folder="$manifest_source_path"
  fi
fi

if [ -z "$source_skills_folder" ]; then
  echo "Error: source skills folder not found."
  echo "Run this script from the repo, or repair the '# source:' line in $manifest_file."
  exit 1
fi

echo "Source:      $source_skills_folder"
echo "Destination: $destination_skills_folder"
echo

mkdir -p "$destination_skills_folder"

# --- Step 2: read the manifest names -----------------------------------------

read_manifest_names

# --- Step 3: find the source skills ------------------------------------------

source_skill_names=()
for skill_folder in "$source_skills_folder"/*/; do
  skill_name="$(basename "$skill_folder")"
  case "$skill_name" in .*) continue ;; esac
  [ -f "$skill_folder/SKILL.md" ] || continue
  source_skill_names+=("$skill_name")
done

if [ ${#source_skill_names[@]} -eq 0 ]; then
  echo "Error: no folder with a SKILL.md file in $source_skills_folder."
  exit 1
fi

# --- Step 4: copy the skills -------------------------------------------------

added_skills=()
updated_skills=()
unchanged_skills=()
skipped_skills=()
deleted_files=()
# The names for the new manifest. A skipped folder never enters this list.
installed_skill_names=()

for skill_name in "${source_skill_names[@]}"; do
  destination_skill_folder="$destination_skills_folder/$skill_name"
  skill_is_new=0

  if [ ! -e "$destination_skill_folder" ]; then
    skill_is_new=1
  elif ! is_in_list "$skill_name" ${manifest_skill_names[@]+"${manifest_skill_names[@]}"}; then
    # The folder exists, but it is not in the manifest. It came from elsewhere.
    skipped_skills+=("$skill_name (exists, not from this repo)")
    continue
  fi

  rsync_output="$(rsync -ai --delete --exclude='.DS_Store' \
    "$source_skills_folder/$skill_name/" "$destination_skill_folder/")"

  while IFS= read -r rsync_line; do
    [ -z "$rsync_line" ] && continue
    case "$rsync_line" in
      "*deleting "*) deleted_files+=("$skill_name/${rsync_line#\*deleting }") ;;
    esac
  done <<< "$rsync_output"

  installed_skill_names+=("$skill_name")

  if [ "$skill_is_new" -eq 1 ]; then
    added_skills+=("$skill_name")
  elif [ -n "$rsync_output" ]; then
    updated_skills+=("$skill_name")
  else
    unchanged_skills+=("$skill_name")
  fi
done

# --- Step 5: remove the skills that this repo deleted (--update only) --------

removable_skills=()
unsafe_skills=()
# A folder that stays in place keeps its manifest line. Without the line,
# the next run reads it as a skill from a different source.
retained_skill_names=()

for manifest_skill_name in ${manifest_skill_names[@]+"${manifest_skill_names[@]}"}; do
  is_in_list "$manifest_skill_name" "${source_skill_names[@]}" && continue

  candidate_folder="$destination_skills_folder/$manifest_skill_name"
  if [ ! -d "$candidate_folder" ]; then
    continue
  fi
  if [ "$run_update" -eq 0 ]; then
    unsafe_skills+=("$manifest_skill_name (not in the repo; use --update to remove)")
    retained_skill_names+=("$manifest_skill_name")
    continue
  fi
  case "$manifest_skill_name" in
    */*|.|..|"")
      unsafe_skills+=("$manifest_skill_name (bad name)")
      retained_skill_names+=("$manifest_skill_name")
      continue
      ;;
  esac
  if [ ! -f "$candidate_folder/SKILL.md" ]; then
    unsafe_skills+=("$manifest_skill_name (no SKILL.md)")
    retained_skill_names+=("$manifest_skill_name")
    continue
  fi
  removable_skills+=("$manifest_skill_name")
done

removed_skills=()
if [ ${#removable_skills[@]} -gt 0 ]; then
  echo "These skills are no longer in the repo:"
  for removable_skill_name in "${removable_skills[@]}"; do
    echo "  $destination_skills_folder/$removable_skill_name"
  done
  printf "Delete them? [y/N] "
  read -r delete_answer
  if [ "$delete_answer" = "y" ] || [ "$delete_answer" = "Y" ]; then
    for removable_skill_name in "${removable_skills[@]}"; do
      rm -rf "$destination_skills_folder/$removable_skill_name"
      removed_skills+=("$removable_skill_name")
    done
  else
    for removable_skill_name in "${removable_skills[@]}"; do
      unsafe_skills+=("$removable_skill_name (kept, you said no)")
      retained_skill_names+=("$removable_skill_name")
    done
  fi
  echo
fi

# --- Step 6: write the manifest ----------------------------------------------

{
  echo "# source: $source_skills_folder"
  for skill_name in ${installed_skill_names[@]+"${installed_skill_names[@]}"} \
                    ${retained_skill_names[@]+"${retained_skill_names[@]}"}; do
    echo "$skill_name"
  done
} > "$manifest_file"

# --- Step 7: report ----------------------------------------------------------

print_report_list "Added"        ${added_skills[@]+"${added_skills[@]}"}
print_report_list "Updated"      ${updated_skills[@]+"${updated_skills[@]}"}
print_report_list "No change"    ${unchanged_skills[@]+"${unchanged_skills[@]}"}
print_report_list "Removed"      ${removed_skills[@]+"${removed_skills[@]}"}
print_report_list "Deleted files" ${deleted_files[@]+"${deleted_files[@]}"}
print_report_list "Not touched"  ${skipped_skills[@]+"${skipped_skills[@]}"} ${unsafe_skills[@]+"${unsafe_skills[@]}"}

echo
echo "Run \`/reload-skills\`, or start a new session, to use the changes."