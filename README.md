# ClaudeSkills

Custom Claude Code skills made by [Mykyta Soloviov](https://github.com/mykytaso).

## Installation

1. Clone this repo.
2. Open Claude Code in this repo folder.
3. Ask Claude to `install skills`.
4. Claude copies the skills into `~/.claude/skills`.
5. Run `/reload-skills`, or start a new Claude Code session.

## Usage

- Call each skill by its name, for example `/wtf`.
- Run `/update-skills` any time to update the skills.
  It only manages skills from this repo. It never touches or deletes any other skill in `~/.claude/skills`.
- Run `/uninstall-skills` to remove them again.

## Skills

| Skill              | Description                                                  |
|--------------------|--------------------------------------------------------------|
| `comments-add`     | Adds explanatory comments to code.                           |
| `comments-remove`  | Deletes the comments from code.                              |
| `comments-rewrite` | Deletes the comments, then writes new ones.                  |
| `uninstall-skills` | Removes the skills of this repo from `~/.claude/skills`.     |
| `update-skills`    | Applies updates to the skills from this repo.                |
| `validate-skills`  | Checks each `SKILL.md` in this repo against the conventions. |
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
