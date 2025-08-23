#!/bin/bash

# Script to automatically update both NetlifyPlugin and pluginTest projects
# Usage: ./update-both-projects.sh "commit message" "plugin version" [--push]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required parameters are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 \"commit message\" \"plugin version\" [--push]"
    echo ""
    echo "Parameters:"
    echo "  commit message  - Git commit message for both projects"
    echo "  plugin version  - Version to install in pluginTest (e.g., 1.0.11)"
    echo "  --push         - Optional: push to GitHub after commit"
    echo ""
    echo "Example:"
    echo "  $0 \"Add new feature\" \"1.0.12\" --push"
    echo "  $0 \"Fix bug\" \"1.0.11\""
    exit 1
fi

COMMIT_MESSAGE="$1"
PLUGIN_VERSION="$2"
PUSH_TO_GITHUB=false

# Check if --push flag is provided
if [ "$3" = "--push" ]; then
    PUSH_TO_GITHUB=true
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NETLIFY_PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGIN_TEST_DIR="$(dirname "$NETLIFY_PLUGIN_DIR")/pluginTest"

print_status "Starting automatic update of both projects..."
print_status "Commit message: $COMMIT_MESSAGE"
print_status "Plugin version: $PLUGIN_VERSION"
print_status "Push to GitHub: $PUSH_TO_GITHUB"
echo ""

# Check if directories exist
if [ ! -d "$NETLIFY_PLUGIN_DIR" ]; then
    print_error "NetlifyPlugin directory not found: $NETLIFY_PLUGIN_DIR"
    exit 1
fi

if [ ! -d "$PLUGIN_TEST_DIR" ]; then
    print_error "pluginTest directory not found: $PLUGIN_TEST_DIR"
    exit 1
fi

# Function to update NetlifyPlugin project
update_netlify_plugin() {
    print_status "Updating NetlifyPlugin project..."
    cd "$NETLIFY_PLUGIN_DIR"
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ] || [ ! -f "index.js" ]; then
        print_error "Not in NetlifyPlugin directory or missing required files"
        exit 1
    fi
    
    # Check git status
    if [ -n "$(git status --porcelain)" ]; then
        print_status "Adding all changes to git..."
        git add .
        
        print_status "Committing changes..."
        git commit -m "$COMMIT_MESSAGE"
        
        if [ "$PUSH_TO_GITHUB" = true ]; then
            print_status "Pushing to GitHub..."
            git push origin main
            print_success "NetlifyPlugin updated and pushed to GitHub"
        else
            print_success "NetlifyPlugin updated (not pushed)"
        fi
    else
        print_warning "No changes to commit in NetlifyPlugin"
    fi
    
    echo ""
}

# Function to update pluginTest project
update_plugin_test() {
    print_status "Updating pluginTest project..."
    cd "$PLUGIN_TEST_DIR"
    
    # Check if we're in the right directory
    if [ ! -f "package.json" ] || [ ! -f "netlify.toml" ]; then
        print_error "Not in pluginTest directory or missing required files"
        exit 1
    fi
    
    # Update the plugin to the specified version
    print_status "Installing plugin version $PLUGIN_VERSION..."
    npm install "netlify-plugin-expo-qr@$PLUGIN_VERSION"
    
    # Check git status
    if [ -n "$(git status --porcelain)" ]; then
        print_status "Adding all changes to git..."
        git add .
        
        print_status "Committing changes..."
        git commit -m "$COMMIT_MESSAGE"
        
        if [ "$PUSH_TO_GITHUB" = true ]; then
            print_status "Pushing to GitHub..."
            git push origin main
            print_success "pluginTest updated and pushed to GitHub"
        else
            print_success "pluginTest updated (not pushed)"
        fi
    else
        print_warning "No changes to commit in pluginTest"
    fi
    
    echo ""
}

# Main execution
print_status "Current working directory: $(pwd)"
print_status "NetlifyPlugin directory: $NETLIFY_PLUGIN_DIR"
print_status "pluginTest directory: $PLUGIN_TEST_DIR"
echo ""

# Update NetlifyPlugin first
update_netlify_plugin

# Update pluginTest second
update_plugin_test

print_success "Both projects updated successfully!"
print_status "Summary:"
print_status "  ✅ NetlifyPlugin: Updated with commit '$COMMIT_MESSAGE'"
print_status "  ✅ pluginTest: Updated plugin to version $PLUGIN_VERSION with commit '$COMMIT_MESSAGE'"

if [ "$PUSH_TO_GITHUB" = true ]; then
    print_status "  ✅ Both projects pushed to GitHub"
else
    print_status "  ℹ️  Changes committed locally (use --push to push to GitHub)"
fi

echo ""
print_status "Next steps:"
print_status "  1. Check Netlify dashboard for automatic deployment"
print_status "  2. Verify the plugin is working correctly"
print_status "  3. Test the QR code generation"
