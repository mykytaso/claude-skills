# ClaudeSkills

Custom Claude Code skills (slash commands).

## Installation

1. Clone this repo.
2. Open Claude Code in this repo folder.
3. Ask Claude to `install skills`.
4. Claude copies the skills into `~/.claude/skills`.

After step 4, each skill is invoked by its name (for example `/wtf`), from any project. Run `/update-skills` any time to update the skills. It only manages skills from this repo — it never touches or deletes any other skill in `~/.claude/skills`.

## Skills

- `add-comments` — adds explanatory comments to code.
- `remove-comments` — strips comments from code, preserving license headers, tool directives, and TODO/MARK/FIXME.
- `wtf` — re-explains the assistant's own last message when it didn't land.
- `update-skills` — makes `~/.claude/skills` mirror this repo's `skills` folder, without touching skills from elsewhere.