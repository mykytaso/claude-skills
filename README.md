# Claude Skills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).


## Skills

| Skill               | Input                         | Description                                                         |
|---------------------|-------------------------------|---------------------------------------------------------------------|
| `/wtf`              | None                          | Rephrases the previous answer in simpler, clearer language.         |
| `/comments-add`     | File - Directory - Code Block | Adds short, clear comments explaining the code’s purpose and logic. |
| `/comments-remove`  | File - Directory - Code Block | Removes all comments from the code.                                 |
| `/comments-rewrite` | File - Directory - Code Block | Replaces existing comments with short, clear explanations.          |      |


## Installation

1. Clone this repo.
2. Run `./skills.sh` in the repo folder.
3. The script copies the skills into `~/.claude/skills`.
4. Run `/reload-skills`, or start a new Claude Code session.


## Usage

1. Start a new Claude Code session.
2. Call each skill by its name.

Example:
```
/comments-add Sources/Model.swift     # one file
/comments-add Sources/Views           # each source file in the directory
/comments-add <paste the code>        # a block of code
/wtf                                  # None
```


## About `skills.sh`

- The `skills.sh` only manages skills from this repo.
- It never touches or deletes any other skill in `~/.claude/skills`.
- It shows the folders, and asks first, before it deletes.

```
./skills.sh              # install the skills
./skills.sh --update     # mirror the skills from this repo to `~/.claude/skills`
./skills.sh --uninstall  # remove all skills of this repo
```


## License

MIT. See [LICENSE](LICENSE).
