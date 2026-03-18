#!/usr/bin/env bash
set -euo pipefail

# Function to show usage
usage() {
  echo "Usage: $0 <node_version>"
  echo "Example: $0 18"
  echo
  echo "If no version is passed, the script will look for a .nvmrc file in the current directory."
  exit 1
}

# Determine requested version
if [ $# -eq 1 ]; then
  VERSION="$1"
elif [ -f ".nvmrc" ]; then
  VERSION=$(cat .nvmrc | tr -d 'v' | tr -d '[:space:]')
  if [ -z "$VERSION" ]; then
    echo "⚠️  .nvmrc file is empty."
    usage
  fi
  echo "📂 Using version from .nvmrc: $VERSION"
else
  usage
fi

FORMULA="node@$VERSION"

# Check if that version is installed
if ! brew list --versions "$FORMULA" >/dev/null 2>&1; then
  echo "⚠️  $FORMULA is not installed."
  echo "➡️  Installing $FORMULA via Homebrew..."
  brew install "$FORMULA"
fi

# Unlink any currently linked node
if brew list --versions node >/dev/null 2>&1; then
  echo "🔗 Unlinking currently active node..."
  brew unlink node || true
fi

# Unlink all other installed node@X versions
for v in $(brew search /^node@/ | grep -E '^node@[0-9]+$'); do
  if brew list --versions "$v" >/dev/null 2>&1; then
    brew unlink "$v" >/dev/null 2>&1 || true
  fi
done

# Link the requested version
echo "🔗 Linking $FORMULA..."
brew link --force --overwrite "$FORMULA"

# Show active version
echo "✅ Now using: $(node -v)"
