---
description: Makes ~/.claude/skills hold an exact copy of this repo's skills, without touching any skill that did not come from this repo. Use when the user asks to update, sync, install, or publish skills.
disable-model-invocation: true
argument-hint: (none)
allowed-tools: Bash Glob
---

## Precondition

This command needs no input.

1. If $ARGUMENTS is not empty, stop immediately. Do not guess. Write only this message:

`Usage: /update-skills`

## Task

Make `~/.claude/skills` hold the same skills as this repo's `skills` folder. This repo is the source of truth for its own skills only. `~/.claude/skills` is a shared folder. It can hold skills from other sources too. Never change or delete a skill that did not come from this repo.

Source skills folder: `/Users/mkta-mac/MyFiles/Dev/ClaudeSkills/skills`
Destination skills folder: `~/.claude/skills`
Manifest file: `~/.claude/.myk-installed-skills`

The manifest file lists the skill names this repo installed the last time this command ran, one name per line. Use it to know which destination folders belong to this repo. A destination folder that is not in the manifest and not in the current source folder did not come from this repo. Leave it alone.

Rules:
1. If the source skills folder does not exist, stop. Report the error. Do not guess a different path.
2. Make the destination skills folder if it does not exist.
3. Read the manifest file if it exists. This is the list of skill names from the last run. Treat it as an empty list if the file does not exist.
4. Find each skill folder in the source skills folder.
5. For each skill folder, check if it exists in the destination folder now. This tells you if the skill is new or already installed.
6. Copy the skill folder with this command, and read the output to see which files changed:
   `rsync -ai --delete "<source>/<skill>/" "<destination>/<skill>/"`
7. If the command in step 6 prints no lines, the skill had no change.
8. Compare the manifest list (step 3) with the current source skill names (step 4). For each name that is in the manifest but not in the source folder now, delete `<destination>/<name>`. This is a skill that was in this repo before and is now removed from it.
9. Do not touch any other folder in the destination skills folder. Do not delete a folder only because it has no match in the source folder — check the manifest first (rule 8). A folder that is in neither the manifest nor the source folder did not come from this repo.
10. Write the current source skill names (step 4) to the manifest file, one name per line. Overwrite the old content.
11. Do not delete, rename, or change any file in the source repo.

## Output

Change files only in the destination skills folder and the manifest file.

## Report

After the work, give this data:
1. A list of the skills you added (new in the destination folder).
2. A list of the skills you updated (already in the destination folder, files changed).
3. A list of the skills with no change.
4. A list of the skills you removed (were in this repo before, now removed from it).
