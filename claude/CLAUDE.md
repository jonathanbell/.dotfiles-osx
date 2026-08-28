# AI Coding Assistant Guidelines

This document contains guidelines for AI assistants. It is structured with generic best practices that apply to all projects and AI sessions created on this computer.

## General guidelines and language

When writing something intended for human consumption, (comment, commit message, reply to prompt) use as few words as possible. Pick every word meticulously to reduce the volume to a strict minimum. Be down to the point. Less is more. Keep conversation terse and to the point. There is no need to use niceties. On occasion, use Gen-Z or Gen-Alpha language with me, such as, "it's giving...".

Avoid superlatives and praise. Stop telling me I am absolutely right. Give me the cold hard truth.

Never, ever use emdash (especially when creating comments or output intended for
humans). Just never use emdash (—). Use a hyphen instead (-).

## Code writing, generation and formatting

- Avoid magic numbers and strings by extracting recurring or meaningful values into descriptive constants (const) or enums. Keep self-explanatory, one-off values inline to avoid clutter. If a value comes from a spec (e.g. HTTP 200 OK), use a constant regardless.

- Reduce code indentation. Avoid Arrow Anti-Pattern. Leverage early return and continue.

- Keep function names short. Less than 30 characters.

- Use enums instead of booleans for function parameters.

- Let the reader of the code breathe. Add empty lines between logical blocks of code.

- Add a small, to the point, comment to explain _what_ the block does and _why_. Use examples when possible. Propose ASCII drawings to explain complete systems.

- Treat member visibility changes as a breaking design shift. Keep all fields and functions private unless external access is strictly required by the design. Prompt the user for explicit approval before changing any access modifier from private to internal or public.

- Program to levels of abstraction. Lower-level mechanics (e.g., raw hardware I/O, sector parsing, direct socket streams) must be encapsulated in a dedicated driver/abstraction layer. Expose clean, high-level APIs to the rest of the application so calling code works with domain concepts, not raw implementation details.

- As much as possible try to minimize the number of changed lines when implementing a feature.

- Strictly adhere to the layered boundary hierarchy: each layer may only communicate with its immediate neighbor directly below it. Never "punch holes" through layers (e.g., controllers or UI components must never directly call database queries, raw hardware drivers, or low-level network clients; always route through the intermediate service/abstraction layer).

## Git and source control

### Writing commit messages

Always use the [conventional commit
standard](https://www.conventionalcommits.org/en/v1.0.0/#summary) when creating
Git commit messages. If you find a `commitlint.config.*` file in the root of the
repository you can use that for more context around how to write commit
messages. The title of commit messages should always be lowercase (no capital
letters). The body of the commit message should use proper punctuation and
capitalization. Wrap all code references in backticks (Markdown style).

The commit body line length should never exceed 80 characters. Format commit
messages to wrap at 80 characters.

### Creating pull requests

All pull requests should be opened in DRAFT mode only. Pull request titles
should be the same as the Conventional Commit commit titles. Do not use backticks in Pull Request titles. If there are multiple commits inside a single PR, use the first commit title as the PR title, (with backticks removed).

Do not use a Summary heading, write the description/summary right away, at the
top of the PR - no need for a heading.

Write the pull request description in a direct and terse way. Use bullet points
when needed. Then, if available, use the humanizer skill to further make the PR description more human-like.

Use the heading "Testing" vs "Test plan". If the PR appears to be a small change to you, do not write any testing instructions or test plan.

Do not mention that you added a Changesets file (if you did).

**Always** purpose a PR title and description presented in an easy to read way before actually creating the PR. Once approval is given, proceed to create the pull request.

### Commenting on pull requests

Always print the comment into the session in an easy to read way before calling the Github APIs to actually post the comment. Wait for approval before actually commenting on the pull request. Keep comments terse and low-key, relaxed and occasionally funny.

### Calling the Github API

You will likely have access to the Github MCP server and/or the `gh` CLI tool.
Always use THESE tools when you need to read or write to anything on Github. Do
not use the other tools for any Github related queries - such as any Jira tools or Jira MCP servers. `gh` and the Github MCP server are the best tools to use when interacting with Github.
