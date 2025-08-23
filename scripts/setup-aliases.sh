#!/bin/bash

# Script to set up convenient aliases for the automation scripts
# Run this script once to add aliases to your shell profile

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETLIFY_PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

print_status "Setting up aliases for automation scripts..."
print_status "Script directory: $SCRIPT_DIR"
print_status "NetlifyPlugin directory: $NETLIFY_PLUGIN_DIR"

# Detect shell profile
SHELL_PROFILE=""
if [[ "$SHELL" == *"zsh"* ]]; then
    SHELL_PROFILE="$HOME/.zshrc"
elif [[ "$SHELL" == *"bash"* ]]; then
    SHELL_PROFILE="$HOME/.bashrc"
    if [ ! -f "$SHELL_PROFILE" ]; then
        SHELL_PROFILE="$HOME/.bash_profile"
    fi
else
    print_warning "Unknown shell: $SHELL"
    print_warning "Please manually add aliases to your shell profile"
    exit 1
fi

print_status "Detected shell profile: $SHELL_PROFILE"

# Check if aliases already exist
if grep -q "alias update-projects" "$SHELL_PROFILE"; then
    print_warning "Aliases already exist in $SHELL_PROFILE"
    print_status "Current aliases:"
    grep "alias update-projects\|alias quick-update" "$SHELL_PROFILE" || true
    echo ""
    print_status "To update aliases, remove the old ones and run this script again"
    exit 0
fi

# Create aliases
ALIASES=(
    "# NetlifyPlugin Automation Aliases"
    "alias update-projects='cd $NETLIFY_PLUGIN_DIR && ./scripts/update-both-projects.sh'"
    "alias quick-update='cd $NETLIFY_PLUGIN_DIR && ./scripts/quick-update.sh'"
    "alias update-scripts='cd $NETLIFY_PLUGIN_DIR && ./scripts/update-both-projects.sh \"עדכון סקריפטים\" \"1.0.11\"'"
    ""
)

print_status "Adding aliases to $SHELL_PROFILE..."

# Add aliases to shell profile
for alias in "${ALIASES[@]}"; do
    echo "$alias" >> "$SHELL_PROFILE"
done

print_success "Aliases added successfully!"
echo ""

print_status "New aliases available:"
print_status "  update-projects \"commit message\" \"plugin version\" [--push]"
print_status "  quick-update \"commit message\" \"plugin version\""
print_status "  update-scripts  # Quick update for scripts only"
echo ""

print_status "To use the aliases:"
print_status "  1. Restart your terminal or run: source $SHELL_PROFILE"
print_status "  2. Use the aliases from anywhere:"
print_status "     quick-update \"הוספת תכונה חדשה\" \"1.0.12\""
echo ""

print_warning "Note: Aliases will only work after restarting your terminal or sourcing the profile"
print_status "Run: source $SHELL_PROFILE"
