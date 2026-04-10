#!/usr/bin/env bash
set -euo pipefail

REPO_URL="${CACI_REPO_URL:-https://github.com/AleXxi1337/caci.git}"
INSTALL_ROOT="${CACI_INSTALL_ROOT:-$HOME/.local/share/caci}"
REPO_DIR="${INSTALL_ROOT}/repo"
VENV_DIR="${INSTALL_ROOT}/.venv"
BIN_DIR="${CACI_BIN_DIR:-/usr/local/bin}"

need_cmd() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'Missing required command: %s\n' "$1" >&2
        exit 1
    fi
}

install_system_packages() {
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm --needed git python python-pip >/dev/null 2>&1
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

mkdir -p "$INSTALL_ROOT"

if [ -d "$REPO_DIR/.git" ]; then
    git -C "$REPO_DIR" pull --ff-only --quiet >/dev/null 2>&1
else
    rm -rf "$REPO_DIR"
    git clone --quiet "$REPO_URL" "$REPO_DIR" >/dev/null 2>&1
fi

python -m venv "$VENV_DIR"
"$VENV_DIR/bin/pip" install --quiet --upgrade pip >/dev/null 2>&1
"$VENV_DIR/bin/pip" install --quiet -e "$REPO_DIR" >/dev/null 2>&1

sudo mkdir -p "$BIN_DIR"
sudo ln -sf "$VENV_DIR/bin/caci" "$BIN_DIR/caci"

printf 'caci installed to %s/caci\n' "$BIN_DIR"
