---
description: Adds explanatory comments to source files or to a block of code. Use when the user asks to comment, document, or annotate code.
disable-model-invocation: true
argument-hint: <file-or-directory | code block>
allowed-tools: Read Glob Grep
---

Input: $ARGUMENTS

## Precondition

Find the type of the input:
1. If the input is a path to a file or a directory that exists, use the file or the directory.
2. If the input is code, or the message has a code block, use that code.
3. If there is no input, and the message has no code block, stop immediately. Do not guess. Write only this message:

`Usage: /add-comments <file-or-directory | code block>`

## Task

Add clear, short, explanatory comments to the code.

Rules:
1. Write all comments in ASD-STE100 Simplified Technical English.
2. Use one-line comments. Use more lines only when this makes the text easier to read.
3. Do not divide one sentence into more than one line.
4. Give the reason for the code. Do not say again what the code shows.
5. Do not change, refactor, or reformat the executable code. Add only comments.
6. Do not add a comment to code that is already clear.
7. Keep the comments that are in the file.
8. For Swift language use `//` only.

## Output

For a file or a directory, change the files.
For a block of code, do not write a file. Show the full code with the comments in the chat.

## Report

After the work, give this data:
1. A list of the files or the sections that you documented.
2. A list of the logic that stays unclear.
3. A list of the code that can be unsafe, for example a forced unwrap, an unfinished error operation, or a race condition.
