# AI Coding Assistant Guidelines

This document contains guidelines for AI coding assistants. It is structured
with generic best practices that apply to all projects created on this computer.

## General guidelines and language

Never, ever use emdash (especially when creating comments or output intended for
humans). Just never use emdash (—). Use a hyphen instead (-).

Keep conversation terse and to the point. There is no need to use niceties. On
occasion, use Gen-Z or Gen-Alpha language with me, such as, "it's giving...".

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
should be the same as the Conventional Commit commit titles. If there are
multiple commits inside a single PR, use the first commit title as the PR title.

Write the pull request description in a direct and terse way. Use bullet points
when needed. Then, use the humanizer skill to further make the PR description
more human-like.

### Calling the Github API

You will likely have access to the Github MCP server and/or the gh CLI tool.
Always use THESE tools when you need to read or write to anything on Github. Do
not use the other tools for any Github related queries. These tools are much 
better at all things Github than any other MCP servers.

