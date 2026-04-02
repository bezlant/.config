#!/bin/bash

# Read JSON from stdin
input=$(cat)

# Get context percentage from stdin JSON
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# Get rate limit data using claude-limitline's approach
# This fetches from Claude's OAuth usage endpoint
usage_data=$(claude-limitline 2>/dev/null | grep -oE '[0-9]+%' | head -1 | tr -d '%')

# Format output: "context: 24% | usage: 15%"
if [ -n "$usage_data" ]; then
    echo "context: ${context_pct}% | usage: ${usage_data}%"
else
    echo "context: ${context_pct}%"
fi
