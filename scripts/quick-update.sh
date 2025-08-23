#!/bin/bash

# Quick update script that automatically pushes to GitHub
# Usage: ./quick-update.sh "commit message" "plugin version"

set -e  # Exit on any error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if required parameters are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 \"commit message\" \"plugin version\""
    echo ""
    echo "This script will update both projects and push to GitHub automatically."
    echo ""
    echo "Example:"
    echo "  $0 \"Add new feature\" \"1.0.12\""
    exit 1
fi

COMMIT_MESSAGE="$1"
PLUGIN_VERSION="$2"

print_status "Quick update with automatic push to GitHub..."
echo ""

# Call the main script with --push flag
./scripts/update-both-projects.sh "$COMMIT_MESSAGE" "$PLUGIN_VERSION" --push

print_success "Quick update completed! Both projects updated and pushed to GitHub."
print_status "Netlify should automatically detect the changes and start building."
