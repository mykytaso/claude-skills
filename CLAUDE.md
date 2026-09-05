# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repository holds custom Claude Code skills (slash commands). It is not an application — there is no source code, build step, lint step, or test suite. The `pyproject.toml` (Python 3.14, no dependencies, managed via `uv`) is scaffolding only; no Python code exists yet.

## Structure

Each skill lives at `skills/<skill-name>/SKILL.md`. `update-skills` copies each skill folder straight into `~/.claude/skills/<skill-name>/`, so once installed each skill is invoked by its own name, for example `/wtf`. `~/.claude/skills` is a shared folder — it can hold skills from other sources too. `update-skills` tracks which skill names belong to this repo in a manifest file at `~/.claude/.myk-installed-skills`, so it can remove a skill that was deleted from this repo without ever touching a skill that came from somewhere else. Current skills:

- `add-comments` — adds explanatory comments to code.
- `remove-comments` — strips comments from code, preserving license headers, tool directives, and TODO/MARK/FIXME.
- `wtf` — re-explains the assistant's own last message when it didn't land.
- `update-skills` — makes `~/.claude/skills` mirror this repo's `skills` folder, without touching skills from elsewhere.

Note: there is no `/myk:` namespace prefix. Personal skills dropped straight into `~/.claude/skills/<name>/` (no plugin manifest) are invoked by folder name only. A namespace prefix like `/myk:wtf` only exists for skills packaged as an actual Claude Code plugin, which this repo intentionally does not do.

## First-time setup on a new machine

`/update-skills` only works after it is already copied into `~/.claude/skills`. On a fresh clone, it is not there yet.

To bootstrap: open Claude Code in this repo folder. Say "install skills". This means: read `skills/update-skills/SKILL.md` and follow it, even though the skill is not installed yet. After this first run, `/update-skills` works as a normal slash command, from any project.

## SKILL.md conventions

Every skill file follows the same shape — match it when adding a new skill:

- YAML frontmatter with `description`, `argument-hint`, and `allowed-tools`. All existing skills set `disable-model-invocation: true`, meaning they only run on explicit `/name` invocation, never auto-triggered.
- `allowed-tools` is scoped tight (e.g. `Read Glob Grep` for the comment skills) — these skills read/report but do not need write access themselves; the file-editing happens through the normal Claude Code edit tools once the skill's instructions are loaded.
- Body sections: `Precondition` (validate `$ARGUMENTS`, and give an exact `Usage: ...` message and stop if invalid — no guessing), `Task` with numbered `Rules`, `Output`, and `Report`.
- All instructional text is written in ASD-STE100 Simplified Technical English: short sentences, one thought per sentence, plain words.