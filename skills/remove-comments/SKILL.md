---
description: Removes comments from source files. Use when the user asks to delete, strip, or clean comments in code.
disable-model-invocation: true
argument-hint: <file-or-directory>
allowed-tools: Read Glob Grep
---

Target: $ARGUMENTS

## Precondition

If the target above is empty, or it is not a file or a directory that exists, stop immediately.
Do not read files. Do not make changes. Do not guess a target.
Write only this message:

`Usage: /remove-comments <file-or-directory>`

## Task

Remove the comments from the target.

Rules:
1. Delete line comments and block comments.
2. Keep these comments:
   - License headers and copyright headers.
   - Directives that the compiler or the tools read, for example `// swiftlint:disable`, `# type: ignore`, `// @ts-ignore`, `#pragma`.
   - `TODO`, `MARK`, and `FIXME` comments.
3. Do not change comment text that is inside a string literal or a regular expression.
4. Do not change the code. Change only the comments and the blank lines that stay empty.
5. After the work, show a list of the files and the number of the removed comments.
