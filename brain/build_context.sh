#!/bin/bash
PROJECT_NAME=${1:-"global"}
SEARCH_TERM="$2"

if [ -z "$SEARCH_TERM" ]; then
    echo "Error: Search term required."
    echo "Usage: $0 <project_name> <search_term>"
    exit 1
fi

CONTEXT_FILE="$HOME/.brain/active_context.md"
ARCHIVE_DIR="$HOME/.brain/archives/$PROJECT_NAME"

mkdir -p "$ARCHIVE_DIR"

# Prepend instructions for the AI model to read only.
cat <<INNER_EOF > "$CONTEXT_FILE"
Read this past conversation history to gain context for our current session. Do not reply yet, just acknowledge you have read the history.

=========================================
EXTRACTED CONTEXT FOR: "$SEARCH_TERM" (Project: $PROJECT_NAME)
=========================================

INNER_EOF

# Extract relevant matches from archives.
rg -H -C 1 -i "$SEARCH_TERM" "$ARCHIVE_DIR/" >> "$CONTEXT_FILE" || true
echo "Context for '$SEARCH_TERM' compiled at $CONTEXT_FILE"
