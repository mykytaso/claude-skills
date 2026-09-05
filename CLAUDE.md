# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repository holds custom Claude Code skills (slash commands). It is not an application — there is no build step, lint step, or test suite. The files that matter are the `SKILL.md` files and `skills.sh`, the installer script in the repo root.

## Structure

Each skill lives at `skills/<skill-name>/SKILL.md`. `skills.sh` copies each skill folder straight into `~/.claude/skills/<skill-name>/`, so once installed each skill is invoked by its own name, for example `/wtf`. `~/.claude/skills` is a shared folder — it can hold skills from other sources too. The script tracks which skill names belong to this repo in a manifest file at `~/.claude/.myk-installed-skills`, so it can remove a skill that was deleted from this repo without ever touching a skill that came from somewhere else. Current skills:

- `comments-add` — adds explanatory comments to code.
- `comments-remove` — deletes the comments, and keeps every comment that a tool or the compiler reads.
- `comments-rewrite` — deletes the comments, then writes new ones.
- `wtf` — re-explains the assistant's own last message when it was not clear.

Manifest format (`~/.claude/.myk-installed-skills`):

```
# source: /path/to/ClaudeSkills/skills
comments-add
comments-remove
...
```

The first line records where the repo was when the skills were last installed. The script uses it only as a fallback, if it cannot find a `skills` folder next to itself. Lines starting with `#` are not skill names.

Note: there is no `/myk:` namespace prefix. Personal skills dropped straight into `~/.claude/skills/<name>/` (no plugin manifest) are invoked by folder name only. A namespace prefix like `/myk:wtf` only exists for skills packaged as an actual Claude Code plugin, which this repo intentionally does not do.

## The installer script

`skills.sh` in the repo root installs, updates, and removes the skills. It replaces the old `/update-skills` and `/uninstall-skills` skills, because a script does the same work with no tokens. It has three modes.

`./skills.sh` — install. It does this:

1. Finds the source: the `skills` folder next to the script, or the `# source:` path in the manifest.
2. Copies each source folder that holds a `SKILL.md` with `rsync -ai --delete --exclude='.DS_Store'`.
3. Skips a destination folder that exists but is not in the manifest. That folder came from a different source.
4. Deletes no folder. A skill that this repo removed stays in place, and in the manifest. The report shows it.
5. Rewrites the manifest.
6. Prints the report: added, updated, no change, removed, deleted files, not touched.

`./skills.sh --update` — the same, but rule 4 changes: it asks, then deletes a skill that this repo removed. It deletes only a folder one level under `~/.claude/skills` that holds a `SKILL.md`.

`./skills.sh --uninstall` — remove. It does this:

1. Stops if the manifest does not exist. This repo then installed no skill.
2. Makes the list of folders from the manifest names. It uses the same safety checks as `--update`.
3. Shows the list, and asks before it deletes.
4. Deletes the manifest. If a folder stays, the manifest keeps that name.
5. Prints the report: removed, not touched, manifest state.

Any other argument prints `Usage: skills.sh [--update | --uninstall]`, and stops.

Do not add a skill that repeats this work.

## First-time setup on a new machine

Clone the repo. Run `./skills.sh` from the repo folder. The script needs no installed skill.

After any install or update, run `/reload-skills` or start a new session.

## SKILL.md conventions

Every skill file follows the same shape — match it when adding a new skill. Check these rules by hand.

Frontmatter:

- `name` — required by the skill spec. It must equal the folder name, in kebab-case.
- `description` — what the skill does, and when to use it.
- `argument-hint` — only when the skill takes an argument. Omit it for a skill that takes none.
- `disable-model-invocation: true` — all skills here set this. They run only on an explicit `/name` invocation, never auto-triggered.
- `allowed-tools` — a YAML list, for example `[Read, Glob, Grep]`. Comma-separated text also works; a plain string with spaces (`Read Glob Grep`) does not — it matches no tool name.
- `disallowed-tools` — the same list form. Use it to take tools away.

What those two fields actually do: `allowed-tools` **pre-approves** tools, so they do not raise a permission prompt. It does **not** restrict the model to that list. To stop a skill from touching files, list the write tools in `disallowed-tools` (this is what `wtf` does).

**Rule for this repo: pre-approve read-only tools only.** `Edit`, `Write`, and `Bash` never go in `allowed-tools`, even when the skill needs them — the comment skills edit files, and they do not pre-approve it. Every change then stops and asks, so in manual mode you see the diff or the command and allow it by hand. A skill still gets the tool; it only loses the silent approval.

Body sections, in this order, as they apply:

- `Precondition` — validate the input. Give an exact `Usage: ...` message and stop when the input is missing or wrong. Never guess. A path that does not exist is an error, not a search term.
- `Task` — numbered rules. Use named subsections (`Find the target`, `Write the comments`) or `Step 1/2/3` when the order matters.
- `Limits` — what the skill must never change.
- `Output` — which files the skill may write.
- `Report` — what to tell the user afterwards.

Other rules:

- All instructional text is written in ASD-STE100 Simplified Technical English: short sentences, one thought per sentence, plain words.
- A skill that walks a directory must skip hidden, build, dependency, and generated files, and must ask before changing more than 10 files.
- A skill that deletes anything must check the path, show the list, and ask first.
- The three comment skills repeat their shared rules on purpose: three plain commands beat one command with a mode flag. The cost is drift. Change a shared rule in all three files, in the same words.
- End every file with a newline.
