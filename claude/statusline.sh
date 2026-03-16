#!/bin/bash
# Read JSON input from stdin
input=$(cat)

CURRENT_MODEL=$(echo "$input" | jq -r '.model.display_name')
PERCENT_USED=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
CURRENT_DIR=$(basename "$CURRENT_DIR")

GIT_BRANCH="|"
if git rev-parse --git-dir >/dev/null 2>&1; then
	BRANCH=$(git branch --show-current 2>/dev/null)
	if [ -n "$BRANCH" ]; then
		GIT_BRANCH="🌿 $BRANCH"
	fi
fi

echo "📁 $CURRENT_DIR $GIT_BRANCH 🤖($PERCENT_USED%) ${CURRENT_MODEL##*/}"
