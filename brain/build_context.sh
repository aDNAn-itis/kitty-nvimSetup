#!/bin/bash

# Ensure directories exist
mkdir -p ~/.brain/archives
mkdir -p ~/.brain/scripts

# Make script executable
chmod +x "$0" 2>/dev/null || true

if [ -z "$1" ]; then
    echo "Error: Search term required."
    echo "Usage: $0 \"<search_term>\""
    exit 1
fi

SEARCH_TERM="$1"
CONTEXT_FILE="$HOME/.brain/active_context.md"

# Build the context payload
cat <<EOF > "$CONTEXT_FILE"
Read this past conversation history to gain context for our current session. Do not reply yet, just acknowledge you have read the history.

=========================================
EXTRACTED CONTEXT FOR: "$SEARCH_TERM"
=========================================

EOF

# Extract matching lines and their filenames (-H), include 1 line of context around matches (-C 1)
rg -H -C 1 -i "$SEARCH_TERM" "$HOME/.brain/archives/" >> "$CONTEXT_FILE"

echo "Context for '$SEARCH_TERM' compiled at $CONTEXT_FILE"
