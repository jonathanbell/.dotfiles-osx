# AI Coding Assistant Guidelines

This document contains guidelines for AI coding assistants. It is structured with generic best practices that apply to all projects created on this computer.

## General guidlines

Never, ever use emdash (especially when creating comments or output intended for humans). Just never use emdash (—). Use a hyphen instead (-).

## Git and source control

### Writing commit messages

Always use the conventional commit standard when creating Git commit messages. If you find a `commitlint.config.*` file in the root of the repository you can use that for more context around how to write commit messages. The title of commit messages should always be lowercase (no capital letters).

When creating commit messages never mention any AI tools, Claude, or Claude Code. Do not add "Co-authored by: Claude"

The commit body line length should never exceed 80 characters. Format commit messages to wrap at 80 characters.

### Creating pull requests

All pull requests should be opened in DRAFT mode only. Pull request titles should be the same as the Conventional Commit commit titles. If there are multiple commits inside a single PR, use the first commit title as the PR title.

## GitHub Enterprise server

All of the code written on this machine will be committed to my company's GitHub Enterprise server: `ghe.megaleo.com`

Note that you will likely have a GitHub MCP server available to use. Here are some example calls that you can make to our GitHub Enterprise server:

```curl
curl --request GET \
  --url 'https://ghe.megaleo.com/api/v3/repos/ui-server/ui-server/git/trees/ee24c4fc166eb91faa85be422952f6dabf8b0c31?recursive=true' \
  --header 'accept: application/vnd.github+json' \
  --header 'authorization: Bearer ghp_9pL...bQZ' \
  --header 'content-type: application/json' \
  --header 'x-github-api-version: 2022-11-28'
```

```curl
curl --request POST \
  --url https://ghe.megaleo.com/repos/quantum/docs-workday-build/check-runs \
  --header 'accept: application/vnd.github+json' \
  --header 'authorization: Bearer ghp_9pL...1CgbQZ' \
  --header 'content-type: application/json' \
  --header 'x-github-api-version: 2022-11-28' \
  --data '{
  "name": "jonathans_test",
  "head_sha": "66b108436ecaeb8ff0fdf798e1a54a04b53dda9a",
  "status": "completed",
  "output": {
    "title": "this is a test title",
    "summary": "this is a test summary",
    "text": "<https://cats.com>"
  }
}'
```

Note the way the URL is formatted. While `https://ghe.megaleo.com/api/v3/repos/workday/docs-workday-build/pulls/584` is NOT correct, `https://ghe.megaleo.com/api/v3/repos/quantum/docs-workday-build/pulls/584` IS correct.
