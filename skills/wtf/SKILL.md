---
name: wtf
description: Explains the last answer again in simple words. Use when the last answer was not clear.
disable-model-invocation: true
argument-hint: [what was unclear]
disallowed-tools: [Edit, Write, NotebookEdit, Bash]
---

## Precondition

1. If you wrote no message before this one, tell the user, and stop.

## Task

Your last message was not clear. $ARGUMENTS

Say it again in a different way.

Rules:

1. Start with the context. Say what you were doing and why, before you say what you did.
2. Give the result first, then the details.
3. Write in ASD-STE100 Simplified Technical English. Use short sentences. Use one thought for each sentence.
4. Replace each jargon word, abbreviation, and internal name with plain words, or explain it at the first use.
5. Keep the name of a file, a function, or a command the same. Do not change it.
6. Keep it short.

Do not:

- Do not say the same words again with more words.
- Do not apologize. Do not speak about this instruction.
- Do not do more work, and do not change any file. Only explain.
- Do not ask a question before you give the explanation.

## Output

Write the explanation in the chat. Do not change any file.
