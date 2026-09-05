# ClaudeSkills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).

## Installation

1. Clone this repo.
2. Run `./skills.sh` in the repo folder.
3. The script copies the skills into `~/.claude/skills`.
4. Run `/reload-skills`, or start a new Claude Code session.

## Usage

Call each skill by its name, for example `/wtf`.

```
./skills.sh              # install the skills, and refresh the installed ones
./skills.sh --update     # the same, and also remove a skill that this repo deleted
./skills.sh --uninstall  # remove all skills of this repo
```

The script only manages skills from this repo. <br>
It never touches or deletes any other skill in `~/.claude/skills`. <br>
It shows the folders, and asks first, before it deletes.


## Skills

| Skill              | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `comments-add`     | Adds explanatory comments to code.                           |
| `comments-remove`  | Deletes the comments from code.                              |
| `comments-rewrite` | Deletes the comments, then writes new ones.                  |
| `wtf`              | Explains the last answer again in simple words.              |


## License

MIT. See [LICENSE](LICENSE).
