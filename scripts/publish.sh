#!/bin/bash

# Publish script for netlify-plugin-expo-qr
# This script helps with the npm publishing workflow

set -e

echo "🚀 Preparing to publish netlify-plugin-expo-qr..."

# Check if we're on main/master branch
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != "master" ]]; then
    echo "❌ Error: Must be on main or master branch to publish"
    echo "Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Check if working directory is clean
if [[ -n $(git status --porcelain) ]]; then
    echo "❌ Error: Working directory is not clean"
    echo "Please commit or stash all changes before publishing"
    git status --short
    exit 1
fi

# Check if logged in to npm
if ! npm whoami > /dev/null 2>&1; then
    echo "❌ Error: Not logged in to npm"
    echo "Please run: npm login"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(node -p "require('./package.json').version")
echo "📦 Current version: $CURRENT_VERSION"

# Ask for new version
echo ""
echo "What type of release is this?"
echo "1) patch (bug fixes, 1.0.0 -> 1.0.1)"
echo "2) minor (new features, 1.0.0 -> 1.1.0)"
echo "3) major (breaking changes, 1.0.0 -> 2.0.0)"
echo "4) custom version"
echo ""
read -p "Enter choice (1-4): " choice

case $choice in
    1)
        NEW_VERSION=$(npm version patch --no-git-tag-version)
        ;;
    2)
        NEW_VERSION=$(npm version minor --no-git-tag-version)
        ;;
    3)
        NEW_VERSION=$(npm version major --no-git-tag-version)
        ;;
    4)
        read -p "Enter custom version (e.g., 1.2.3): " custom_version
        NEW_VERSION=$(npm version $custom_version --no-git-tag-version)
        ;;
    *)
        echo "❌ Invalid choice"
        exit 1
        ;;
esac

echo "📦 New version: $NEW_VERSION"

# Build and test
echo ""
echo "🧪 Running tests..."
node test.js

# Clean up test output
rm -rf test-output

echo ""
echo "✅ Tests passed!"

# Confirm before publishing
echo ""
echo "About to publish netlify-plugin-expo-qr@$NEW_VERSION to npm"
read -p "Continue? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "❌ Publishing cancelled"
    exit 1
fi

# Publish to npm
echo ""
echo "📤 Publishing to npm..."
npm publish

# Create git tag
echo ""
echo "🏷️  Creating git tag..."
git add package.json
git commit -m "chore: bump version to $NEW_VERSION"
git tag "v$NEW_VERSION"
git push origin main
git push origin "v$NEW_VERSION"

echo ""
echo "🎉 Successfully published netlify-plugin-expo-qr@$NEW_VERSION!"
echo ""
echo "Next steps:"
echo "1. Create a GitHub release for v$NEW_VERSION"
echo "2. Update documentation if needed"
echo "3. Share the news with the community!"
