#!/usr/bin/env zsh

#
# Bootstrap script for setting up a new macOS machine
#
# This should be idempotent so it can be run multiple times.
#
# Notes:
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#

# Exit on any error
set -e

now=$(date +"%Y%m%d_%H.%M.%S")
log_dir="$HOME/logs"
logfile="bootstrap_$now.log"

source ./libs/echos.sh
source ./libs/installers.sh
source ./configs/apps.cfg # list of apps to install

# Check if running on macOS and in correct directory
check_os
check_directory

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

######################################## End of app list  #####################

clear
bot "commence bootstrapping"

# Create log dir
if [[ ! -d $log_dir ]]; then
  mkdir -p $log_dir
fi

# Ask for the administrator password upfront
bot "please enter your password for front loading..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew, install if we don't have it
bot "install homebrew"
if ! command -v brew &> /dev/null; then
  action "installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &>> ${log_dir}/${logfile}
  
  # Setup Homebrew PATH for Apple Silicon Macs
  if [[ "$(uname -m)" == "arm64" ]]; then
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
else
  print "homebrew already installed..."
fi

BREW_PREFIX=$(brew --prefix)
ok

# Check if SSH exist, create if not
bot "ssh directory check"
if [[ ! -d $HOME/.ssh ]]; then
  action "creating ssh dir..."
  mkdir $HOME/.ssh &>> ${log_dir}/${logfile}
else
  print "ssh dir already exist..."
fi
ok

# Check if projects directory exists, create if not
bot "project directory check"
if [[ ! -d $HOME/projects ]]; then
  action "creating projects dir..."
  mkdir $HOME/projects &>> ${log_dir}/${logfile}
else
  print "projects dir already exist..."
fi
ok

# Update homebrew recipes
bot "homebrew"
action "auditing homebrew"
brew doctor &>> ${log_dir}/${logfile}
ok
action "updating homebrew..."
brew update &>> ${log_dir}/${logfile}
ok "homebrew updated"
action "upgrading brew packages..."
brew upgrade &>> ${log_dir}/${logfile}
ok "brews upgraded"

bot "installing brew formulae"
# Check if any formula is already installed to determine if this is a subsequent run
reinstall_formulas=false
for b_form in ${brews[@]}; do
  if brew list "${b_form}" > /dev/null 2>&1; then
    # At least one formula is installed - this is a subsequent run
    read -q "reply_reinstall_formulas?One or more formulae are already installed. Reinstall all formulae? [y|N] "
    print "\n"
    if [[ $reply_reinstall_formulas == y ]]; then
      reinstall_formulas=true
    fi
    break
  fi
done

for b_form in ${brews[@]}; do
  if [[ $reinstall_formulas == true ]]; then
    brew_install ${b_form} --reinstall
  else
    brew_install ${b_form}
  fi
done

bot "installing brew cask apps"
# Check if any cask is already installed to determine if this is a subsequent run
reinstall_casks=false
for b_cask in ${casks[@]}; do
  if brew list --cask "${b_cask}" > /dev/null 2>&1; then
    # At least one cask is installed - this is a subsequent run
    read -q "reply_reinstall_casks?One or more cask apps are already installed. Reinstall all cask apps? [y|N] "
    print "\n"
    if [[ $reply_reinstall_casks == y ]]; then
      reinstall_casks=true
    fi
    break
  fi
done

for b_casks in ${casks[@]}; do
  if [[ $reinstall_casks == true ]]; then
    cask_install ${b_casks} --reinstall
  else
    cask_install ${b_casks}
  fi
done

bot "installing speedtest"
brew tap teamookla/speedtest
# Check if speedtest is already installed
reinstall_speedtest=false
for b_speed in ${speed[@]}; do
  if brew list --cask "${b_speed}" > /dev/null 2>&1; then
    read -q "reply_reinstall_speed?Speedtest is already installed. Reinstall? [y|N] "
    print "\n"
    if [[ $reply_reinstall_speed == y ]]; then
      reinstall_speedtest=true
    fi
    break
  fi
done

for b_speed in ${speed[@]}; do
  if [[ $reinstall_speedtest == true ]]; then
    cask_install ${b_speed} --reinstall
  else
    cask_install ${b_speed}
  fi
done

bot "installing python packages"
for p_pkgs in ${pips[@]}; do
  pip_install ${p_pkgs}
done

action "brew cleaning up..."
brew cleanup &>> ${log_dir}/${logfile}
ok "brew cleaned up"

bot "setting up zsh"
action "switching to homebrew's zsh..."
if ! fgrep -q "${BREW_PREFIX}/bin/zsh" /etc/shells; then
  echo "${BREW_PREFIX}/bin/zsh" | sudo tee -a /etc/shells  &>> ${log_dir}/${logfile}
  chsh -s ${BREW_PREFIX}/bin/zsh &>> ${log_dir}/${logfile}
else
  if [[ $SHELL == ${BREW_PREFIX}/bin/zsh ]]; then
    print "already using homebrew's zsh"
  fi
fi
ok

action "downloading 'oh my zsh'"
if [[ ! -d $HOME/.oh-my-zsh ]]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended &>> ${log_dir}/${logfile}
else
  print "'oh my zsh' is already installed"
fi
ok

action "downloading 'oh my zsh' plugins and themes"
if [[ ! -d ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/themes/powerlevel10k ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k &>> ${log_dir}/${logfile}
else
  print "'powerlevel10k' already cloned"
fi
ok

bot "bootstrapping complete"
