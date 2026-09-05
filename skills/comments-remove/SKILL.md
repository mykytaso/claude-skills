---
name: comments-remove
description: Removes comments from source files or from a block of code. Use when the user asks to delete, strip, or clean comments in code.
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
   - If you find no location, tell the user, and show the code with the comments removed in the chat. Do not write a file.
4. If there is no input, and the message has no code block, stop immediately. Do not guess. Write only this message:

`Usage: /comments-remove <file-or-directory | code block>`

### Find the files

Do this step only for a directory target.

1. Make the list of the source files in the directory.
2. Do not use a hidden file or a hidden folder.
3. Do not use a build folder or a dependency folder, for example `build`, `dist`, `.build`, `DerivedData`, `node_modules`, `Pods`, `vendor`, `.venv`.
4. Do not use a file that a tool made. A generated file usually has a header, for example "Do not edit".
5. Do not use a file that is not source code, for example an image or a data file.
6. If the list has more than 10 files, show the list, and ask before you make a change.

## Task

Delete the comments from the target.

Rules:

1. Delete line comments and block comments.
2. Keep every comment that the compiler, a tool, or the operating system reads. Delete only a comment that is for a person. Keep these comments:
   - The first line of the file, if it starts with `#!`.
   - License headers and copyright headers.
   - A comment that gives a version or a build rule, for example `// swift-tools-version:6.0`, `//go:build linux`, `# -*- coding: utf-8 -*-`, `# frozen_string_literal: true`.
   - A directive for a tool or the compiler, for example `// swiftlint:disable`, `// swiftformat:disable`, `# type: ignore`, `# noqa`, `// @ts-ignore`, `// eslint-disable`, `// prettier-ignore`, `#pragma`.
   - `TODO`, `MARK`, and `FIXME` comments.
   - A comment that gives data that the code does not show, for example a reason, a defect number, a link, or a description of a workaround.
3. If you are not sure that a comment is only for a person, keep it. Put it in the report.
4. Keep a documentation comment that a tool reads, for example a Swift `///` comment or a Python docstring. A docstring is a string, not a comment. Do not delete it.
5. Do not change comment text that is in a string literal or a regular expression.
6. If the comment was alone on its line, delete the full line. Do not leave an empty line in its place.

## Limits

1. Do not change, refactor, or reformat the executable code.
2. Change only the comments, and the lines that stay empty because you deleted a comment.
3. Do not write a new comment. To write new comments, use `/comments-add` or `/comments-rewrite`.
4. Do not change a file that is not in the target.

## Output

For a file or a directory, delete the comments in the files.
For a block of code that you found in the project, delete the comments in that file. Change only the lines of that block.

## Report

After the work, give this data:

1. A list of the files or the sections, with the number of the deleted comments.
2. A list of the comments that you kept, with the reason.
