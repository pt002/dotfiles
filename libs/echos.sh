#!/usr/bin/env zsh

###
# Colorized echo helpers for terminal output
###

# ANSI color codes
ESC_SEQ="\x1b["
COL_RESET="${ESC_SEQ}39;49;00m"
COL_RED="${ESC_SEQ}31;01m"
COL_GREEN="${ESC_SEQ}32;01m"
COL_YELLOW="${ESC_SEQ}33;01m"
COL_BLUE="${ESC_SEQ}34;01m"
COL_MAGENTA="${ESC_SEQ}35;01m"
COL_CYAN="${ESC_SEQ}36;01m"

# Print a success message in green
# Usage: ok [message]
function ok() {
    print "${COL_GREEN}[ok]${COL_RESET} ${1}"
}

# Print a bot message with ASCII art
# Usage: bot <message>
function bot() {
    print "\n${COL_GREEN}d[-_-]b c(_)${COL_RESET} - ${1}"
}

# Print a running status message in yellow
# Usage: running <message>
function running() {
    print -n "${COL_YELLOW} ⇒ ${COL_RESET}${1}: "
}

# Print an action message in yellow
# Usage: action <message>
function action() {
    print "\n${COL_YELLOW}[action]:${COL_RESET}\n ⇒ ${1}..."
}

# Print a warning message in yellow
# Usage: warn <message>
function warn() {
    print "${COL_YELLOW}[warning]${COL_RESET} ${1}"
}

# Print an error message in red
# Usage: error <message>
function error() {
    print "${COL_RED}[error]${COL_RESET} ${1}"
}

# Print success or error based on exit code
# Usage: print_result <exit_code> <message>
# Args:
#   $1 - Exit code (0 for success, non-zero for error)
#   $2 - Message to display
function print_result() {
    if [[ ${1} -eq 0 ]]; then
        ok "${2}"
    else
        error "${2}"
    fi
}

# Check if running on macOS
# Exits with error if not on macOS
function check_os() {
    if [[ "${OSTYPE}" != "darwin"* ]]; then
        error "This script is designed for macOS only."
        exit 1
    fi
}

# Check if script is run from the dotfiles directory
# Exits with error if not in the correct directory
function check_directory() {
    if [[ ! -f "./libs/echos.sh" ]]; then
        error "Please run this script from the dotfiles directory."
        exit 1
    fi
}
