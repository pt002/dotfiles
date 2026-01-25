#!/usr/bin/env zsh

# Functions to install software

# Install a Homebrew formula
# Usage: brew_install <formula_name> [--reinstall]
# Args:
#   $1 - Name of the Homebrew formula to install
#   $2 - Optional: "--reinstall" flag to reinstall if already installed
# Returns:
#   0 on success, 1 on failure
function brew_install() {
    local formula="${1}"
    local reinstall_flag=""
    
    if [[ -z "${formula}" ]]; then
        error "brew_install requires a formula name"
        return 1
    fi
    
    if [[ "${2}" == "--reinstall" ]]; then
        reinstall_flag="--reinstall"
    fi
    
    if [[ -n "${reinstall_flag}" ]]; then
        running "brew reinstall ${formula}"
        action "reinstalling ${formula}"
        if ! brew reinstall "${formula}" &>> "${log_dir}/${logfile}"; then
            error "failed to reinstall ${formula}! aborting..."
            return 1
        fi
    else
        running "brew install ${formula}"
        if brew list "${formula}" > /dev/null 2>&1; then
            print "\n\t${formula} already installed"
        else
            action "installing ${formula}"
            if ! brew install "${formula}" &>> "${log_dir}/${logfile}"; then
                error "failed to install ${formula}! aborting..."
                return 1
            fi
        fi
    fi
    ok
}

# Install a Homebrew cask application
# Usage: cask_install <app_name> [--reinstall]
# Args:
#   $1 - Name of the cask application to install
#   $2 - Optional: "--reinstall" flag to reinstall if already installed
# Returns:
#   0 on success, 1 on failure
function cask_install() {
    local app_name="${1}"
    local reinstall_flag=""
    
    if [[ -z "${app_name}" ]]; then
        error "cask_install requires an application name"
        return 1
    fi
    
    if [[ "${2}" == "--reinstall" ]]; then
        reinstall_flag="--reinstall"
    fi
    
    if [[ -n "${reinstall_flag}" ]]; then
        running "brew reinstall --cask ${app_name}"
        action "reinstalling ${app_name}"
        if ! brew reinstall --cask "${app_name}" &>> "${log_dir}/${logfile}"; then
            error "failed to reinstall ${app_name}! aborting..."
            return 1
        fi
    else
        running "brew install --cask ${app_name}"
        if brew list --cask "${app_name}" > /dev/null 2>&1; then
            print "\n\t${app_name} already installed"
        else
            action "installing ${app_name}"
            if ! brew install --cask "${app_name}" &>> "${log_dir}/${logfile}"; then
                error "failed to install ${app_name}! aborting..."
                return 1
            fi
        fi
    fi
    ok
}

# Install a Python package using pip
# Usage: pip_install <package_name>
# Args:
#   $1 - Name of the Python package to install
# Returns:
#   0 on success, 1 on failure
function pip_install() {
    local package="${1}"
    
    if [[ -z "${package}" ]]; then
        error "pip_install requires a package name"
        return 1
    fi
    
    running "pip install ${package}"
    if pip show "${package}" > /dev/null 2>&1; then
        print "\n\t${package} already installed"
    else
        action "installing ${package}"
        if ! pip install "${package}" &>> "${log_dir}/${logfile}"; then
            error "failed to install ${package}! aborting..."
            return 1
        fi
    fi
    ok
}
