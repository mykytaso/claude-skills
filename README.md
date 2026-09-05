# ClaudeSkills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).

## Installation

1. Clone this repo.
2. Run `./skills.sh` in the repo folder.
3. The script copies the skills into `~/.claude/skills`.
4. Run `/reload-skills`, or start a new Claude Code session.

## Usage

Call each skill by its name, for example `/wtf`.




## Skills

| Skill              | Input                         | Description                                     |
|--------------------|-------------------------------|-------------------------------------------------|
| `comments-add`     | File - Directory - Code Block | Adds explanatory comments to code.              |
| `comments-remove`  | File - Directory - Code Block | Deletes the comments from code.                 |
| `comments-rewrite` | File - Directory - Code Block | Deletes the comments, then writes new ones.     |
| `wtf`              | None                          | Explains the last answer again in simple words. |

**Examples:**
```
/comments-add Sources/Model.swift     # one file
/comments-add Sources/Views           # each source file in the directory
/comments-add <paste the code>        # a block of code
/wtf                                  # None
```



## skills.sh

> The `skills.sh` only manages skills from this repo. <br>
> It never touches or deletes any other skill in `~/.claude/skills`. <br>
> It shows the folders, and asks first, before it deletes.

```
./skills.sh              # install the skills
./skills.sh --update     # mirror the skills from this repo to `~/.claude/skills`
./skills.sh --uninstall  # remove all skills of this repo
```


## License

MIT. See [LICENSE](LICENSE).
