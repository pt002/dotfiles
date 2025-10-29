#!/usr/bin/env zsh

###
# some colorized echo helpers
# 
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function ok() {
    print "${COL_GREEN}[ok]${COL_RESET} "$1
}

function bot() {
    print "\n${COL_GREEN}d[-_-]b c(_)${COL_RESET} - "$1
}

function running() {
    print -n "${COL_YELLOW} ⇒ ${COL_RESET}"$1": "
}

function action() {
    print "\n${COL_YELLOW}[action]:${COL_RESET}\n ⇒ $1..."
}

function warn() {
    print "${COL_YELLOW}[warning]${COL_RESET} "$1
}

function error() {
    print "${COL_RED}[error]${COL_RESET} "$1
}

function print_result() {
    if [[ $1 -eq 0 ]]; then
        ok "$2"
    else
        error "$2"
    fi
}

function check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        error "This script is designed for macOS only."
        exit 1
    fi
}

function check_directory() {
    if [[ ! -f "./libs/echos.sh" ]]; then
        error "Please run this script from the dotfiles directory."
        exit 1
    fi
}
