# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repository holds custom Claude Code skills (slash commands). It is not an application — there is no source code, build step, lint step, or test suite. Every file that matters is a `SKILL.md`.

## Structure

Each skill lives at `skills/<skill-name>/SKILL.md`. `update-skills` copies each skill folder straight into `~/.claude/skills/<skill-name>/`, so once installed each skill is invoked by its own name, for example `/wtf`. `~/.claude/skills` is a shared folder — it can hold skills from other sources too. `update-skills` tracks which skill names belong to this repo in a manifest file at `~/.claude/.myk-installed-skills`, so it can remove a skill that was deleted from this repo without ever touching a skill that came from somewhere else. Current skills:

- `comments` — adds, removes, or rewrites comments in code. One skill, three modes: `/comments add|remove|rewrite <target>`.
- `uninstall-skills` — removes this repo's skills from `~/.claude/skills` and deletes the manifest.
- `update-skills` — makes `~/.claude/skills` mirror this repo's `skills` folder, without touching skills from elsewhere.
- `validate-skills` — checks every `SKILL.md` in this repo against the conventions below.
- `wtf` — re-explains the assistant's own last message when it was not clear.

Manifest format (`~/.claude/.myk-installed-skills`):

```
# source: /path/to/ClaudeSkills/skills
comments
update-skills
...
```

The first line records where the repo was when the skills were last installed, so `/update-skills` works from any project folder. Lines starting with `#` are not skill names.

Note: there is no `/myk:` namespace prefix. Personal skills dropped straight into `~/.claude/skills/<name>/` (no plugin manifest) are invoked by folder name only. A namespace prefix like `/myk:wtf` only exists for skills packaged as an actual Claude Code plugin, which this repo intentionally does not do.

## First-time setup on a new machine

`/update-skills` only works after it is already copied into `~/.claude/skills`. On a fresh clone, it is not there yet.

To bootstrap: open Claude Code in this repo folder. Say "install skills". This means: read `skills/update-skills/SKILL.md` and follow it, even though the skill is not installed yet. After this first run, `/update-skills` works as a normal slash command, from any project.

After any install or update, run `/reload-skills` or start a new session.

## SKILL.md conventions

Every skill file follows the same shape — match it when adding a new skill. `/validate-skills` checks these rules.

Frontmatter:

- `name` — required by the skill spec. It must equal the folder name, in kebab-case.
- `description` — what the skill does, and when to use it.
- `argument-hint` — only when the skill takes an argument. Omit it for a skill that takes none.
- `disable-model-invocation: true` — all skills here set this. They run only on an explicit `/name` invocation, never auto-triggered.
- `allowed-tools` — a YAML list, for example `[Read, Glob, Grep]`. Comma-separated text also works; a plain string with spaces (`Read Glob Grep`) does not — it matches no tool name.
- `disallowed-tools` — the same list form. Use it to take tools away.

What those two fields actually do: `allowed-tools` **pre-approves** tools, so they do not raise a permission prompt. It does **not** restrict the model to that list. To stop a skill from touching files, list the write tools in `disallowed-tools` (this is what `wtf` does).

**Rule for this repo: pre-approve read-only tools only.** `Edit`, `Write`, and `Bash` never go in `allowed-tools`, even when the skill needs them — `comments` edits files, `update-skills` runs `rsync --delete`, `uninstall-skills` runs `rm -rf`, and none of them pre-approve it. Every change then stops and asks, so in manual mode you see the diff or the command and allow it by hand. A skill still gets the tool; it only loses the silent approval.

Body sections, in this order, as they apply:

- `Precondition` — validate the input. Give an exact `Usage: ...` message and stop when the input is missing or wrong. Never guess. A path that does not exist is an error, not a search term.
- `Task` — numbered rules. Use `Step A/B/C` subsections when a mode selects which steps run.
- `Limits` — what the skill must never change.
- `Output` — which files the skill may write.
- `Report` — what to tell the user afterwards.

Other rules:

- All instructional text is written in ASD-STE100 Simplified Technical English: short sentences, one thought per sentence, plain words.
- A skill that walks a directory must skip hidden, build, dependency, and generated files, and must ask before changing more than 10 files.
- A skill that deletes anything must check the path, show the list, and ask first.
- Keep a rule in one file. Do not copy the same rule into two skills — that is why the three comment skills became one `comments` skill with modes.
- End every file with a newline.
