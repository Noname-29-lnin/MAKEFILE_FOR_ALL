#!/bin/zsh

# ===========================
# Usage:
#   source SourceMe.sh <project_name>
# ===========================

REPO_URL="https://github.com/Noname-29-lnin/Create_The_Env_Project.git"

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo "[ERROR] Please provide project name"
    echo "Usage: source SourceMe.sh <project_name>"
    return 1 2>/dev/null || exit 1
fi

# ===========================
# Clone repo
# ===========================
echo "[INFO] Cloning template repo..."

git clone "$REPO_URL" "$PROJECT_NAME"

if [ $? -ne 0 ]; then
    echo "[ERROR] Clone failed"
    return 1 2>/dev/null || exit 1
fi

cd "$PROJECT_NAME" || {
    echo "[ERROR] Cannot enter project directory"
    return 1 2>/dev/null || exit 1
}

# ===========================
# Remove git history (fresh project)
# ===========================
echo "[INFO] Removing .git history..."
rm -rf .git

# ===========================
# Export environment variable
# ===========================
export PROJECT_DIR="$(pwd)"

# Optional: add convenience vars
export PROJECT_HOME="$PROJECT_DIR"

# ===========================
# Info
# ===========================
echo "[OK] Project initialized successfully"
echo "[OK] PROJECT_DIR = $PROJECT_DIR"
echo "[OK] Ready to build system-level environment"