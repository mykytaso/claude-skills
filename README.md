# ClaudeSkills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).

## Installation

1. Clone this repo.
2. Open Claude Code in this repo folder.
3. Ask Claude to `install skills`.
4. Claude copies the skills into `~/.claude/skills`.


## Usage

- Restart Claude Code after installing skills. 
- Now your can call each skill by its name (for example `/wtf`). 
- Run `/update-skills` any time to update the skills. <br> It only manages skills from this repo and never touches or deletes any other skill in `~/.claude/skills`.

## Skills

- `add-comments` – adds explanatory comments to code.
- `remove-comments` – strips comments from code, preserving license headers, tool directives, and TODO/MARK/FIXME.
- `wtf` – re-explains the assistant's own last message when it didn't land.
- `update-skills` – makes `~/.claude/skills` mirror this repo's `skills` folder, without touching skills from elsewhere.