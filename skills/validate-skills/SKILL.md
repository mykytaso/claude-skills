---
name: validate-skills
description: Checks each SKILL.md in this repo against the repo conventions. Use when the user asks to validate, check, or lint the skills.
disable-model-invocation: true
argument-hint: [skill-name]
allowed-tools: [Read, Glob, Grep]
---

Input: $ARGUMENTS

## Precondition

1. Find the source skills folder. Use the first result:
   - The current folder, or a parent folder, that holds `skills/update-skills/SKILL.md`. Use its `skills` folder.
   - If you find no folder, stop. Ask the user for the path to the repo. Do not guess a path.
2. If the input is empty, check every skill.
3. If the input is a skill name, check that skill only. If the name has no folder, stop, and show the names that exist.

## Task

Read each `SKILL.md`. Report each rule that fails. Do not correct a file.

Rules for the frontmatter:

1. The frontmatter is between two `---` lines, at the top of the file.
2. `name` is there. It is the same as the folder name. It has lowercase letters, digits, and hyphens only.
3. `description` is there. It says what the skill does, and when to use it. It is one paragraph.
4. `allowed-tools` is a list, for example `[Read, Glob, Grep]`. It is not one text with spaces between the names. A text with spaces matches no tool, and the pre-approval does nothing.
5. `allowed-tools` holds read-only tools only, for example `Read`, `Glob`, and `Grep`. `Edit`, `Write`, and `Bash` are not there, also when the skill uses them. A tool that changes something must ask the user first. The user must see the change before it occurs.
6. A skill that must not change a file has `disallowed-tools`, with `Edit`, `Write`, and `NotebookEdit`.
7. `disable-model-invocation: true` is there, if only the user starts the skill.
8. `argument-hint` is there, if the skill takes an input. It is not there, if the skill takes no input. A skill that takes no input can still read `$ARGUMENTS` in its `Precondition`, to find that the user gave an input by mistake. This is correct.

Rules for the body:

9. The body has a `Precondition` section. The section says what to do with a bad input and with no input.
10. A `Usage:` message is there, and it has the correct skill name.
11. The body has a `Task` section with numbered rules.
12. The body has an `Output` section, if the skill changes a file.
13. The body has a `Report` section, if the skill must give the result.
14. The text is ASD-STE100 Simplified Technical English. The sentences are short. Each sentence has one thought.
15. The file ends with a newline.

Rules for the repository:

16. Each skill folder in the `skills` folder is in `README.md` and in `CLAUDE.md`.
17. `README.md` and `CLAUDE.md` do not name a skill or a file that does not exist.

## Output

Do not change a file. This skill only gives a report.

## Report

1. A table with one line for each skill: the name, and `pass` or the number of the problems.
2. For each problem: the file, the line number, the rule number, and the correction.
3. A list of the skills with no problem.
