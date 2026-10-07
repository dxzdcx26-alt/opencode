#!/usr/bin/env bash
# =============================================================================
# Rebrand script: opencode → dxzcode
# =============================================================================
# Usage (from repo root):
#   bash rebrand-to-dxzcode.sh
#
# What it does:
#   - @opencode-ai/*  →  @dxzcode/*
#   - opencode        →  dxzcode  (CLI / product name)
#   - .opencode       →  .dxzcode (config dir)
#   - OpenCode        →  DxzCode
#   - Renames packages/opencode and .opencode directories if present
#
# Review git diff before committing.
# =============================================================================

set -euo pipefail

OLD_NAME="opencode"
NEW_NAME="dxzcode"
OLD_SCOPE="@opencode-ai"
NEW_SCOPE="@dxzcode"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${CYAN}→${NC} $*"; }
ok()    { echo -e "${GREEN}✓${NC} $*"; }
warn()  { echo -e "${YELLOW}!${NC} $*"; }
err()   { echo -e "${RED}✗${NC} $*"; exit 1; }

if [[ ! -f "package.json" ]]; then
  err "Run this script from the repository root (package.json not found)."
fi

if [[ -n "$(git status --porcelain 2>/dev/null)" ]]; then
  warn "Working tree is not clean. Commit or stash first is recommended."
  read -r -p "Continue anyway? [y/N] " ans
  [[ "${ans:-}" =~ ^[Yy]$ ]] || exit 0
fi

echo ""
echo "=============================================="
echo "  Rebrand: ${OLD_NAME} → ${NEW_NAME}"
echo "  Scope:   ${OLD_SCOPE} → ${NEW_SCOPE}"
echo "=============================================="
echo ""
read -r -p "Proceed? [y/N] " confirm
[[ "${confirm:-}" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

sed_inplace() {
  local expr="$1"
  local file="$2"
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' -e "$expr" "$file"
  else
    sed -i -e "$expr" "$file"
  fi
}

info "Scanning and replacing text..."

mapfile -t FILES < <(
  find . \
    \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .turbo -o -name coverage \) -prune -o \
    -type f \( \
      -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o \
      -name "*.mjs" -o -name "*.cjs" -o -name "*.json" -o -name "*.jsonc" -o \
      -name "*.toml" -o -name "*.yml" -o -name "*.yaml" -o -name "*.md" -o \
      -name "*.mdx" -o -name "*.txt" -o -name "*.sh" -o -name "*.bash" -o \
      -name "*.nix" -o -name "*.css" -o -name "*.html" -o -name "Dockerfile*" \
    \) -print 2>/dev/null | sort
)

CHANGED=0
for file in "${FILES[@]}"; do
  case "$file" in
    *bun.lock*|*package-lock.json*|*yarn.lock*|*pnpm-lock.yaml*) continue ;;
  esac
  if ! grep -qE "opencode|@opencode-ai|\\.opencode|OpenCode" "$file" 2>/dev/null; then
    continue
  fi
  tmp="$(mktemp)"
  cp "$file" "$tmp"
  sed_inplace "s|@opencode-ai/|@dxzcode/|g" "$file"
  sed_inplace "s|\\.opencode|.dxzcode|g" "$file"
  sed_inplace "s|OpenCode|DxzCode|g" "$file"
  sed_inplace "s|opencode|dxzcode|g" "$file"
  if ! cmp -s "$tmp" "$file"; then
    CHANGED=$((CHANGED + 1))
    echo "  updated: $file"
  fi
  rm -f "$tmp"
done
ok "Updated ${CHANGED} files."

info "Renaming directories..."
for dir in "packages/opencode" ".opencode"; do
  if [[ -d "$dir" ]]; then
    newdir="${dir//opencode/dxzcode}"
    newdir="${newdir//.opencode/.dxzcode}"
    if [[ "$dir" != "$newdir" ]]; then
      mkdir -p "$(dirname "$newdir")"
      mv "$dir" "$newdir"
      ok "renamed: $dir → $newdir"
    fi
  fi
done

if [[ -f "package.json" ]] && command -v jq &>/dev/null; then
  info "Updating root package.json via jq..."
  tmp="$(mktemp)"
  jq --arg name "$NEW_NAME" \
     --arg repo "https://github.com/dxzdcx26-alt/${NEW_NAME}" \
     '.name = $name | .repository.url = $repo | .description = "DxzCode – personal AI coding agent (fork of OpenCode)"' \
     package.json > "$tmp" && mv "$tmp" package.json
  ok "package.json updated."
fi

echo ""
ok "Rebrand pass finished."
echo ""
echo "Next steps:"
echo "  1. git status && git diff | head -n 200"
echo "  2. bun install"
echo "  3. bun run typecheck"
echo "  4. rg -i 'opencode|@opencode-ai' --glob '!bun.lock' --glob '!node_modules'"
echo "  5. git add -A && git commit -m 'chore: rebrand opencode → dxzcode'"
echo "  6. gh repo rename dxzcode   # optional"
echo ""
warn "Always review the diff before committing."
