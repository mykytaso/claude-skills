---
description: Removes comments from source files or from a block of code. Use when the user asks to delete, strip, or clean comments in code.
disable-model-invocation: true
argument-hint: <file-or-directory | code block>
allowed-tools: Read Glob Grep
---

Input: $ARGUMENTS

## Precondition

Find the type of the input:
1. If the input is a path to a file or a directory that exists, use the file or the directory.
2. If the input is code, or the message has a code block, find that code in the project:
   - Use Grep with a line from the code that is unusual, for example a name or a string literal.
   - If you find one location, use that file.
   - If you find more than one location, show the list of the files with the line numbers, and ask which one to use. Do not make a change.
   - If you find no location, tell the user, and show the code with the comments removed in the chat. Do not write a file.
3. If there is no input, and the message has no code block, stop immediately. Do not guess. Write only this message:

`Usage: /remove-comments <file-or-directory | code block>`

## Task

Remove the comments from the input.

Rules:
1. Delete line comments and block comments.
2. Keep these comments:
   - License headers and copyright headers.
   - Directives that the compiler or the tools read, for example `// swiftlint:disable`, `# type: ignore`, `// @ts-ignore`, `#pragma`.
   - `TODO`, `MARK`, and `FIXME` comments.
3. Do not change comment text that is inside a string literal or a regular expression.
4. Do not change the code. Change only the comments and the blank lines that stay empty.

## Output

For a file or a directory, remove the comments in the files.
For a block of code that you found in the project, remove the comments in that file. Change only the lines of that block.

## Report

After the work, show a list of the files or the sections, with the number of the removed comments.