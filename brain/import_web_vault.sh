#!/bin/bash

# ==============================================================================
# GEMINI WEB VAULT IMPORT SCRIPT (Umbrella Wrapper Mode)
# ==============================================================================
# ARCHITECTURE OVERVIEW & RATIONALE:
# This script implements the "Umbrella Wrapper" architecture for AI context.
# Instead of storing research as a dozen separate files that the AI has to slowly 
# search for, OR merging them into one messy blob that is hard for the user to edit,
# this script combines the best of both worlds.
# 
# It uses `project.md` as a single wrapper file (which tricks the AI into instantly 
# loading all context on startup), but strictly isolates each piece of research 
# inside <sub-file> XML tags. This keeps the data cleanly separated so the user 
# can easily read, edit, or delete specific research sessions.
# ==============================================================================

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Searching for downloaded Gemini Web Archives..."

# Find the most recently downloaded gemini archive
LATEST_FILE=$(ls -t ~/Downloads/gemini_vault_archive_*.md 2>/dev/null | head -n 1)

if [ -z "$LATEST_FILE" ]; then
    echo -e "${YELLOW}[WARNING]${NC} No gemini_vault_archive_*.md files found in ~/Downloads."
    exit 1
fi

echo -e "${GREEN}[FOUND]${NC} $LATEST_FILE"
echo ""
echo "How would you like to import this research?"
echo "  [U]pdate: Append as a <sub-file> block into the current directory's project.md"
echo "  [N]ew:    Create a new project workspace and initialize project.md with this file"
read -p "Select an option [U/N]: " choice

TIMESTAMP=$(date +"%Y-%m-%d_%H%M%S")
SUB_FILE_NAME="web_archive_$TIMESTAMP.md"

if [[ "$choice" == "U" || "$choice" == "u" ]]; then
    # Umbrella Update Mode
    
    # Initialize the project.md if it doesn't exist
    if [ ! -f "./project.md" ]; then
        echo "# KITTYBRAIN PROJECT VAULT" > ./project.md
        echo "This is the umbrella wrapper containing isolated research sub-files." >> ./project.md
    fi
    
    # Append the new research wrapped in isolated <sub-file> tags
    echo "" >> ./project.md
    echo "<sub-file name=\"$SUB_FILE_NAME\">" >> ./project.md
    cat "$LATEST_FILE" >> ./project.md
    echo "" >> ./project.md
    echo "</sub-file>" >> ./project.md
    
    echo -e "${GREEN}[SUCCESS]${NC} Research successfully wrapped and appended to ./project.md"
    echo "Your AI assistant will now instantly read this isolated context!"

elif [[ "$choice" == "N" || "$choice" == "n" ]]; then
    # Umbrella New Project Mode
    echo ""
    read -p "Enter the new Project Name: " PROJECT_NAME
    
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${YELLOW}[ERROR]${NC} Project name cannot be empty."
        exit 1
    fi
    
    PROJECT_DIR="$HOME/Projects/$PROJECT_NAME"
    mkdir -p "$PROJECT_DIR"
    
    PROJECT_MD="$PROJECT_DIR/project.md"
    
    # Create the umbrella wrapper and insert the first sub-file
    echo "# KITTYBRAIN PROJECT VAULT" > "$PROJECT_MD"
    echo "This is the umbrella wrapper containing isolated research sub-files." >> "$PROJECT_MD"
    echo "" >> "$PROJECT_MD"
    echo "<sub-file name=\"$SUB_FILE_NAME\">" >> "$PROJECT_MD"
    cat "$LATEST_FILE" >> "$PROJECT_MD"
    echo "" >> "$PROJECT_MD"
    echo "</sub-file>" >> "$PROJECT_MD"
    
    echo -e "${GREEN}[SUCCESS]${NC} New project initialized at $PROJECT_DIR"
    echo -e "${GREEN}[SUCCESS]${NC} Web research formatted into a new project.md wrapper!"
    echo "Navigate there with: cd $PROJECT_DIR"

else
    echo -e "${YELLOW}[ABORTED]${NC} Invalid option selected."
    exit 1
fi
