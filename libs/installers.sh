#!/usr/bin/env zsh

# Functions to install software


function brew_install() {
    local package=$1
    shift
    local extra_args="$@"
    
    running "brew install $package $extra_args"
    if brew ls $package > /dev/null 2>&1; then
      print "\n\t$package already installed"
    else
      action "installing $package $extra_args"
      brew install $package $extra_args &>> ${log_dir}/${logfile}
      if [[ $? != 0 ]]; then
        error "failed to install $package! aborting..."
      fi
    fi
    ok
}

function cask_install() {
    local package=$1
    shift
    local extra_args="$@"
    
    running "brew install --cask $package $extra_args"
    if brew list --cask $package > /dev/null 2>&1; then
      print "\n\t$package already installed"
    else
      action "installing $package $extra_args"
      brew install --cask $package $extra_args &>> ${log_dir}/${logfile}
      if [[ $? != 0 ]]; then
        error "failed to install $package! aborting..."
      fi
    fi
    ok
}

function pip_install() {
    local package=$1
    shift
    local extra_args="$@"
    
    running "pip install $package $extra_args"
    if pip show $package > /dev/null 2>&1; then
      print "\n\t$package already installed"
    else
      action "installing $package $extra_args"
      pip install $package $extra_args &>> ${log_dir}/${logfile}
      if [[ $? != 0 ]]; then
        error "failed to install $package! aborting..."
      fi
    fi
    ok
}
