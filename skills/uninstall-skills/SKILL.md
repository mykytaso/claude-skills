---
name: uninstall-skills
description: Removes this repo's skills from ~/.claude/skills, and deletes the manifest. Use when the user asks to uninstall or remove the skills of this repo.
disable-model-invocation: true
allowed-tools: [Read, Glob]
---

## Precondition

This command needs no input.

1. If $ARGUMENTS is not empty, stop immediately. Do not guess. Write only this message:

`Usage: /uninstall-skills`

## Task

Remove only the skills that this repo installed. Never change or delete a skill from a different source.

Destination skills folder: `~/.claude/skills`
Manifest file: `~/.claude/.myk-installed-skills`

Rules:

1. Read the manifest. Ignore a line that starts with `#`. The other lines are the skill names that this repo installed.
2. If the manifest does not exist, stop. Tell the user that this repo installed no skill. Do not delete a folder.
3. Make the list of the folders to delete: `<destination>/<name>` for each name in the manifest.
4. Before you delete a folder, do these checks:
   - The path starts with the destination skills folder.
   - The path has one folder name after the destination skills folder.
   - The folder holds a `SKILL.md` file.
   If a check fails, do not delete the folder. Put it in the report.
5. Show the list of the folders to delete. Ask the user before you delete them.
6. Use this command for each folder: `rm -rf "<destination>/<name>"`
7. Delete the manifest file after you delete the folders.
8. Do not touch any other folder in the destination skills folder.
9. Do not delete, rename, or change any file in the source repo.

## Output

Change files only in the destination skills folder and the manifest file.

## Report

1. A list of the skills you removed.
2. A list of the folders that you did not touch, and the reason.
3. This message: "Run `/reload-skills`, or start a new session, to use the changes."
