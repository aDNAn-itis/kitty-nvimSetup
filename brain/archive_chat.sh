#!/bin/bash

# Ensure directories exist
mkdir -p ~/.brain/archives
mkdir -p ~/.brain/scripts

# Make script executable (if invoked via bash directly the first time)
chmod +x "$0" 2>/dev/null || true

# Define timestamp and file paths
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
FILENAME="$HOME/.brain/archives/chat_$TIMESTAMP.md"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Fetch text from right neighbor pane via Kitty socket
RAW_TEXT=$(kitty @ --to unix:/tmp/kitty_socket get-text --match neighbor:right)

# Strip ANSI color codes and formatting
CLEAN_TEXT=$(echo "$RAW_TEXT" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")

# Save to permanent database with YAML frontmatter
cat <<EOF > "$FILENAME"
---
date: "$DATE"
tags: []
---

$CLEAN_TEXT
EOF

echo "Archived chat to $FILENAME"
