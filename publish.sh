#!/usr/bin/env bash
# Usage: ./publish.sh <github-user> [repo-name] [--private]
set -euo pipefail

GH_USER="${1:?Usage: ./publish.sh <github-user> [repo-name] [--private]}"
REPO="${2:-colab-lfs-demo}"
VISIBILITY="--public"
[[ "${3:-}" == "--private" ]] && VISIBILITY="--private"

command -v git-lfs >/dev/null || { echo "git-lfs not found. Install it: brew install git-lfs (macOS) / apt install git-lfs"; exit 1; }
command -v gh >/dev/null      || { echo "GitHub CLI not found. Install it (https://cli.github.com) or follow the manual steps in README.md"; exit 1; }

# Fill in the placeholders in the README and the notebook
for f in README.md notebooks/lfs_demo.ipynb; do
  sed -i.bak -e "s/YOUR_GITHUB_USER/${GH_USER}/g" -e "s/colab-lfs-demo/${REPO}/g" "$f"
  rm -f "$f.bak"
done

git init -b main
git lfs install --local
git add .gitattributes        # tracking rules first, so the data goes into LFS
git add .
git commit -m "Colab + Git LFS demo"

echo "Files stored in LFS:"
git lfs ls-files --size

gh repo create "$REPO" "$VISIBILITY" --source . --remote origin --push

echo
echo "Done. Open the README on GitHub and click 'Open in Colab':"
echo "  https://github.com/${GH_USER}/${REPO}"
