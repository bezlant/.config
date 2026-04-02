#!/bin/bash

# Read JSON from stdin
input=$(cat)

# Get model name
model=$(echo "$input" | jq -r '.model.display_name // "Sonnet"')

# Get context percentage
context=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Get rate limit usage from claude-limitline
usage=$(echo "$input" | claude-limitline 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g' | grep -oE '[0-9]+%' | head -1 | tr -d '%')

# Output plain text
if [ -n "$usage" ]; then
    echo "${model} | usage: ${usage}% | context: ${context}%"
else
    echo "${model} | context: ${context}%"
fi
