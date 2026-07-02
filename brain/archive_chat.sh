#!/bin/bash
PROJECT_NAME=${1:-"global"}
mkdir -p "$HOME/.brain/archives/$PROJECT_NAME"
TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
FILENAME="$HOME/.brain/archives/$PROJECT_NAME/chat_$TIMESTAMP.md"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Extract text from the right AI pane.
RAW_TEXT=$(kitty @ --to unix:/tmp/kitty_socket get-text --match neighbor:right)
# Remove terminal ANSI color codes for readability.
CLEAN_TEXT=$(echo "$RAW_TEXT" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")

# Save extracted text with YAML frontmatter.
cat <<INNER_EOF > "$FILENAME"
---
date: "$DATE"
project: "$PROJECT_NAME"
tags: []
---

$CLEAN_TEXT
INNER_EOF

echo "Archived chat to $FILENAME"
