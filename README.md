# ClaudeSkills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).

## Installation

1. Clone this repo.
2. Open Claude Code in this repo folder.
3. Ask Claude to `install skills`.
4. Claude copies the skills into `~/.claude/skills`.
5. Restart Claude Code session.

## Usage

- Now your can call each skill by its name (for example `/wtf`). 
- Run `/update-skills` any time to update the skills. <br> It only manages skills from this repo and never touches or deletes any other skill in `~/.claude/skills`.

## Skills

| Skill             | Description                                   |
|-------------------|-----------------------------------------------|
| `wtf`             | Re-explains the last message in a simple way. |
| `add-comments`    | Adds explanatory comments to code.            |
| `remove-comments` | Deletes comments from code.                   |
| `update-skills`   | Apply updates to the skills from this repo.   |
