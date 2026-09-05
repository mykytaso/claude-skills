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

The script only manages skills from this repo. It never touches or deletes any other skill in
`~/.claude/skills`. It shows the folders, and asks first, before it deletes.

To call the script from any folder, add an alias to `~/.zshrc`:

```
alias skills='/path/to/ClaudeSkills/skills.sh'
```

## Skills

| Skill              | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `comments-add`     | Adds explanatory comments to code.                           |
| `comments-remove`  | Deletes the comments from code.                              |
| `comments-rewrite` | Deletes the comments, then writes new ones.                  |
| `wtf`              | Explains the last answer again in simple words.              |

### The comment skills

```
/comments-add <file-or-directory | code block>       # write new comments
/comments-remove <file-or-directory | code block>    # delete the comments
/comments-rewrite <file-or-directory | code block>   # delete, then write new ones
```

`comments-remove` and `comments-rewrite` keep every comment that a tool or the compiler reads:
a `#!` first line, license headers, `// swift-tools-version`, build tags, lint directives,
and `TODO`, `MARK`, and `FIXME`.

## License

MIT. See [LICENSE](LICENSE).
