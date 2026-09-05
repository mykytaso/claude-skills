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
2. If the input is code, or the message has a code block, find that code in the project:
   - Use Grep with a line from the code that is unusual, for example a name or a string literal.
   - If you find one location, use that file.
   - If you find more than one location, show the list of the files with the line numbers, and ask which one to use. Do not make a change.
   - If you find no location, tell the user, and show the code with the new comments in the chat. Do not write a file.
3. If there is no input, and the message has no code block, stop immediately. Do not guess. Write only this message:

`Usage: /add-comments <file-or-directory | code block>`

## Before you write

If the code uses an element from a different file, and you cannot understand the code without it, find that element first.

1. Make a list of the types, the functions, the properties, and the constants that the code uses but does not define.
2. Use Grep and Glob to find where each one is defined. Read that file.
3. Read the definition only. Do not change the other file.
4. If you cannot find the definition, do not guess what it does. Write a comment about the code that you can see, and put the element in the report.

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

For a file or a directory, add the comments in the files.
For a block of code that you found in the project, add the comments in that file. Change only the lines of that block.

## Report

After the work, give this data:
1. A list of the files or the sections that you documented.
2. A list of the logic that stays unclear.
3. A list of the code that can be unsafe, for example a forced unwrap, an unfinished error operation, or a race condition.
4. A list of the external elements that you read, with their files, and a list of the elements that you did not find.
