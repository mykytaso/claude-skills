---
name: update-skills
description: Makes ~/.claude/skills hold an exact copy of this repo's skills, without touching any skill that did not come from this repo. Use when the user asks to update, sync, install, or publish skills.
disable-model-invocation: true
allowed-tools: [Read, Glob]
---

## Precondition

This command needs no input.

1. If $ARGUMENTS is not empty, stop immediately. Do not guess. Write only this message:

`Usage: /update-skills`

## Task

Make `~/.claude/skills` hold the same skills as this repo's `skills` folder. This repo is the source of truth for its own skills only. `~/.claude/skills` is a shared folder. It can hold skills from other sources too. Never change or delete a skill that did not come from this repo.

Destination skills folder: `~/.claude/skills`
Manifest file: `~/.claude/.myk-installed-skills`

The manifest has this format:
- The first line is `# source: <path to the repo skills folder>`.
- Each line after it is one skill name from the last run.
- Ignore a line that starts with `#` when you read the names.

### Step 1 — Find the source skills folder

Use the first result:

1. The current folder, or a parent folder, that holds `skills/update-skills/SKILL.md`. Use its `skills` folder.
2. The path on the `# source:` line of the manifest, if that path exists.
3. If you find no folder, stop. Ask the user for the path to the repo. Do not guess a path.

### Step 2 — Copy the skills

1. Make the destination skills folder if it does not exist.
2. Read the manifest if it exists. This is the list of skill names from the last run. Treat it as an empty list if the file does not exist.
3. Find each folder in the source skills folder that holds a `SKILL.md` file. These are the source skills. Do not use a folder that has no `SKILL.md`. Do not use a hidden folder.
4. For each source skill, look at `<destination>/<name>`:
   - If it does not exist, the skill is new.
   - If it exists, and the name is in the manifest, the skill came from this repo. Update it.
   - If it exists, and the name is not in the manifest, the skill came from a different source. Stop. Show the folder. Ask the user before you write. Do not overwrite the folder without an answer.
5. Copy each skill with this command, and read the output to see which files changed:
   `rsync -ai --delete --exclude='.DS_Store' "<source>/<skill>/" "<destination>/<skill>/"`
6. If the command in rule 5 prints no lines, the skill had no change.
7. `rsync --delete` also removes a file that a person added in the destination folder. Show each deleted file in the report.

### Step 3 — Remove the skills that this repo deleted

1. Compare the manifest names (step 2, rule 2) with the source skill names (step 2, rule 3).
2. A name that is in the manifest but not in the source folder is a skill that this repo deleted. Delete `<destination>/<name>`.
3. Before you delete a folder, do these checks:
   - The path starts with the destination skills folder.
   - The path has one folder name after the destination skills folder.
   - The folder holds a `SKILL.md` file.
   If a check fails, do not delete the folder. Put it in the report.
4. Show the list of the folders to delete. Ask the user before you delete them.
5. Use this command for each folder: `rm -rf "<destination>/<name>"`
6. Do not touch any other folder in the destination skills folder. A folder that is in neither the manifest nor the source folder did not come from this repo. Leave it alone.

### Step 4 — Write the manifest

1. Write the `# source:` line with the path from step 1.
2. Write the current source skill names, one name per line.
3. Overwrite the old content.
4. Do not delete, rename, or change any file in the source repo.

## Output

Change files only in the destination skills folder and the manifest file.

## Report

After the work, give this data:

1. A list of the skills you added (new in the destination folder).
2. A list of the skills you updated (already in the destination folder, files changed).
3. A list of the skills with no change.
4. A list of the skills you removed (were in this repo before, now removed from it).
5. A list of the folders that you did not touch, and the reason.
6. This message: "Run `/reload-skills`, or start a new session, to use the changes."
