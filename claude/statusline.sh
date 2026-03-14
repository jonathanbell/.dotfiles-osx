#!/bin/bash
# Read JSON input from stdin
input=$(cat)

CURRENT_DIR=$(echo "$input" | jq -r '.workspace.current_dir')
USAGE=$(echo "$input" | jq '.context_window.current_usage')

# Show git branch if in a git repo
GIT_BRANCH=""
if git rev-parse --git-dir >/dev/null 2>&1; then
	BRANCH=$(git branch --show-current 2>/dev/null)
	if [ -n "$BRANCH" ]; then
		GIT_BRANCH=" [$BRANCH] |"
	fi
fi

if [ "$USAGE" != "null" ]; then
	# Calculate current context from current_usage fields
	CURRENT_TOKENS=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
	PERCENT_USED=$((CURRENT_TOKENS * 100 / CONTEXT_SIZE))

	MODEL_DISPLAY="$(echo "$input" | jq -r '.model.display_name') Usage: ${PERCENT_USED}%"
else
	MODEL_DISPLAY="$(echo "$input" | jq -r '.model.display_name') Usage: 0%"
fi

echo "→ $GIT_BRANCH 📁 ${CURRENT_DIR##*/} | $MODEL_DISPLAY"
