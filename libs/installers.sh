#!/usr/bin/env zsh

# Functions to install software


function brew_install() {
    running "brew install $1"
    if brew list "$1" > /dev/null 2>&1; then
      print "\n\t$1 already installed"
    else
      action "installing $1"
      brew install "$1" &>> "${log_dir}/${logfile}"
      if [[ $? != 0 ]]; then
        error "failed to install $1! aborting..."
        # exit -1
      fi
    fi
    ok
}

function cask_install() {
    running "brew install $1"
    if brew list --cask "$1" > /dev/null 2>&1; then
      print "\n\t$1 already installed"
    else
      action "installing $1"
      brew install --cask "$1" &>> "${log_dir}/${logfile}"
      if [[ $? != 0 ]]; then
        error "failed to install $1! aborting..."
        # exit -1
      fi
    fi
    ok
}

function pip_install() {
    running "pip install $1"
    if pip show "$1" > /dev/null 2>&1; then
      print "\n\t$1 already installed"
    else
      action "installing $1"
      pip install "$1" &>> "${log_dir}/${logfile}"
      if [[ $? != 0 ]]; then
          error "failed to install $1! aborting..."
          # exit -1
      fi
    fi
    ok
}
