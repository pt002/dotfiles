#!/usr/bin/env zsh

# Functions to install software


function brew_install() {
    running "brew install $1"
    if brew list $1 > /dev/null 2>&1; then
      print "\n\t$1 already installed"
    else
      action "installing $1"
      if ! brew install $1 &>> ${log_dir}/${logfile}; then
        error "failed to install $1! aborting..."
        return 1
      fi
    fi
    ok
}

function cask_install() {
    local app_name=$1
    local force_flag=""
    if [[ "$2" == "--force" ]]; then
        force_flag="--force"
    fi
    
    running "brew install --cask $app_name"
    if brew list --cask $app_name > /dev/null 2>&1 && [[ -z "$force_flag" ]]; then
      print "\n\t$app_name already installed"
    else
      action "installing $app_name"
      if ! brew install --cask $app_name $force_flag &>> ${log_dir}/${logfile}; then
        error "failed to install $app_name! aborting..."
        return 1
      fi
    fi
    ok
}

function pip_install() {
    running "pip install $1"
    if pip show $1 > /dev/null 2>&1; then
      print "\n\t$1 already installed"
    else
      action "installing $1"
      if ! pip install $1 &>> ${log_dir}/${logfile}; then
          error "failed to install $1! aborting..."
          return 1
      fi
    fi
    ok
}
