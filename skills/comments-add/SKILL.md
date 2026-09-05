---
name: comments-add
description: Adds explanatory comments to source files or to a block of code. Use when the user asks to comment, document, or annotate code.
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

`Usage: /comments-add <file-or-directory | code block>`

### Find the files

Do this step only for a directory target.

1. Make the list of the source files in the directory.
2. Do not use a hidden file or a hidden folder.
3. Do not use a build folder or a dependency folder, for example `build`, `dist`, `.build`, `DerivedData`, `node_modules`, `Pods`, `vendor`, `.venv`.
4. Do not use a file that a tool made. A generated file usually has a header, for example "Do not edit".
5. Do not use a file that is not source code, for example an image or a data file.
6. If the list has more than 10 files, show the list, and ask before you make a change.

## Task

Add clear, short, explanatory comments to the code.

### Read the code that you cannot see

If the code uses an element from a different file, and you cannot understand the code without it, find that element first.

1. Make a list of the types, the functions, the properties, and the constants that the code uses but does not define.
2. Use Grep and Glob to find where each one is defined. Read that file.
3. Read the definition only. Do not change the other file.
4. If you cannot find the definition, do not guess what it does. Write a comment about the code that you can see, and put the element in the report.

### Write the comments

1. Write all comments in ASD-STE100 Simplified Technical English.
2. Give the reason for the code. Do not say again what the code shows.
3. Do not add a comment to code that is already clear.
4. Put the comment on the line above the code. Do not put a comment at the end of a line of code.
5. Use one-line comments. Use more lines only when this makes the text easier to read.
6. Do not divide one sentence into more than one line.
7. For the Swift language, use `//`. Do not use `/* */`.
8. For a different language, use the comment style that the file uses already.
9. Keep the comments that are in the file. If a comment does not agree with the code, do not change it. Put it in the report.

## Limits

1. Do not change, refactor, or reformat the executable code. Add only comments.
2. Do not delete a comment. To delete a comment, use `/comments-remove`. To write a comment again, use `/comments-rewrite`.
3. Do not change a file that is not in the target.

## Output

For a file or a directory, add the comments in the files.
For a block of code that you found in the project, add the comments in that file. Change only the lines of that block.

## Report

After the work, give this data:

1. A list of the files or the sections that you documented, with the number of the new comments.
2. A list of the comments that do not agree with the code.
3. A list of the logic that stays unclear.
4. A short list of the code that can be unsafe, for example a forced unwrap, an unfinished error operation, or a race condition. Tell the user that `/security-review` does a full examination.
5. A list of the external elements that you read, with their files, and a list of the elements that you did not find.
