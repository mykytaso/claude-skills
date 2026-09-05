---
name: comments-rewrite
description: Deletes the comments from code and writes new ones. Use when the user asks to rewrite, replace, refresh, or clean up and re-document comments.
disable-model-invocation: true
argument-hint: <file-or-directory | code block>
allowed-tools: [Read, Glob, Grep]
---

Input: $ARGUMENTS

## Precondition

### Find the target

Find the type of the input:

1. If the input is a path to a file or a directory that exists, use the file or the directory.
2. If the input looks like a path, and the path does not exist, stop. Show the path. Do not guess. Do not search for the path text.
3. If the input is code, or the message has a code block, find that code in the project:
   - Use Grep with a line from the code that is unusual, for example a name or a string literal.
   - If you find one location, use that file.
   - If you find more than one location, show the list of the files with the line numbers, and ask which one to use. Do not make a change.
   - If you find no location, tell the user, and show the code with the new comments in the chat. Do not write a file.
4. If there is no input, and the message has no code block, stop immediately. Do not guess. Write only this message:

`Usage: /comments-rewrite <file-or-directory | code block>`

### Find the files

Do this step only for a directory target.

1. Make the list of the source files in the directory.
2. Do not use a hidden file or a hidden folder.
3. Do not use a build folder or a dependency folder, for example `build`, `dist`, `.build`, `DerivedData`, `node_modules`, `Pods`, `vendor`, `.venv`.
4. Do not use a file that a tool made. A generated file usually has a header, for example "Do not edit".
5. Do not use a file that is not source code, for example an image or a data file.
6. If the list has more than 10 files, show the list, and ask before you make a change.

## Task

Delete the comments, then write new comments. Do the three steps in this order.

### Step 1 — Delete the comments

1. Delete line comments and block comments.
2. Keep every comment that the compiler, a tool, or the operating system reads. Delete only a comment that is for a person. Keep these comments:
   - The first line of the file, if it starts with `#!`.
   - License headers and copyright headers.
   - A comment that gives a version or a build rule, for example `// swift-tools-version:6.0`, `//go:build linux`, `# -*- coding: utf-8 -*-`, `# frozen_string_literal: true`.
   - A directive for a tool or the compiler, for example `// swiftlint:disable`, `// swiftformat:disable`, `# type: ignore`, `# noqa`, `// @ts-ignore`, `// eslint-disable`, `// prettier-ignore`, `#pragma`.
   - `TODO`, `MARK`, and `FIXME` comments.
   - A comment that gives data that the code does not show, for example a reason, a defect number, a link, or a description of a workaround. You cannot write this comment again from the code.
3. If you are not sure that a comment is only for a person, keep it. Put it in the report.
4. Keep a documentation comment that a tool reads, for example a Swift `///` comment or a Python docstring. A docstring is a string, not a comment. Do not delete it.
5. Do not change comment text that is in a string literal or a regular expression.
6. If the comment was alone on its line, delete the full line. Do not leave an empty line in its place.
7. Do not write a comment that you kept a second time.

### Step 2 — Read the code that you cannot see

If the code uses an element from a different file, and you cannot understand the code without it, find that element first.

1. Make a list of the types, the functions, the properties, and the constants that the code uses but does not define.
2. Use Grep and Glob to find where each one is defined. Read that file.
3. Read the definition only. Do not change the other file.
4. If you cannot find the definition, do not guess what it does. Write a comment about the code that you can see, and put the element in the report.

### Step 3 — Write the comments

1. Write all comments in ASD-STE100 Simplified Technical English.
2. Give the reason for the code. Do not say again what the code shows.
3. Do not add a comment to code that is already clear.
4. Put the comment on the line above the code. Do not put a comment at the end of a line of code.
5. Use one-line comments. Use more lines only when this makes the text easier to read.
6. Do not divide one sentence into more than one line.
7. For the Swift language, use `//`. Do not use `/* */`.
8. For a different language, use the comment style that the file uses already.

## Limits

1. Do not change, refactor, or reformat the executable code.
2. Change only the comments, and the lines that stay empty because you deleted a comment.
3. Do not change a file that is not in the target.

## Output

For a file or a directory, change the comments in the files.
For a block of code that you found in the project, change the comments in that file. Change only the lines of that block.

## Report

After the work, give this data:

1. A list of the files or the sections, with the number of the deleted comments and the number of the new comments.
2. A list of the comments that you deleted and did not write again.
3. A list of the comments that you kept, with the reason.
4. A list of the logic that stays unclear.
5. A short list of the code that can be unsafe, for example a forced unwrap, an unfinished error operation, or a race condition. Tell the user that `/security-review` does a full examination.
6. A list of the external elements that you read, with their files, and a list of the elements that you did not find.
