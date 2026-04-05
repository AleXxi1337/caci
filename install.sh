#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${CACI_REPO_URL:-https://github.com/AleXxi1337/caci.git}"
INSTALL_ROOT="${CACI_INSTALL_ROOT:-$HOME/.local/share/caci}"
REPO_DIR="${INSTALL_ROOT}/repo"
VENV_DIR="${INSTALL_ROOT}/.venv"
BIN_DIR="${HOME}/.local/bin"

need_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

install_system_packages() {
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm --needed git python python-pip
    else
        printf 'pacman not found; install git, python and python-pip manually.\n' >&2
        exit 1
    fi
}

printf 'Installing caci into %s\n' "$INSTALL_ROOT"

need_cmd curl
install_system_packages
need_cmd git
need_cmd python

mkdir -p "$INSTALL_ROOT" "$BIN_DIR"

if [ -d "$REPO_DIR/.git" ]; then
    git -C "$REPO_DIR" pull --ff-only
else
    rm -rf "$REPO_DIR"
    git clone "$REPO_URL" "$REPO_DIR"
fi

python -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --upgrade pip
"$VENV_DIR/bin/pip" install -e "$REPO_DIR"

ln -sf "$VENV_DIR/bin/caci" "$BIN_DIR/caci"
