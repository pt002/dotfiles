#!/usr/bin/env zsh

#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#

now=$(date +"%Y%m%d_%H.%M.%S")
log_dir="$HOME/logs"
logfile="bootstrap_$now.log"

source ./libs/echos.sh
source ./libs/installers.sh
source ./configs/apps.cfg # list of apps to install

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

# Accept XCode license
bot "xcode settings"
if [[ ! -e /Applications/Xcode.app ]]; then
  error "please install xcode..."
  # exit 1
else
  running "accepting xcode license..."
  sudo xcodebuild -license accept &>> ${log_dir}/${logfile}
  ok
fi

# Install XCode Command Line Tools
if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    print_result $? ' XCode Command Line Tools Installed'
fi

# Check for Homebrew, install if we don't have it
bot "install homebrew"
brew_check=$(which brew) 2>&1 > /dev/null
if [[ $? != 0 ]]; then
  action "installing homebrew. press return to continue."
  if [ "$(uname -p)" = "arm" ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &>> ${log_dir}/${logfile}
    BREW_PREFIX=$(brew --prefix)
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)" &>> ${log_dir}/${logfile}
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &>> ${log_dir}/${logfile}
    BREW_PREFIX=$(brew --prefix)
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" &>> ${log_dir}/${logfile}
    BREW_PREFIX=$(brew --prefix)
  fi
else
  print "homebrew already installed..."
  BREW_PREFIX=$(brew --prefix)
fi
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

# Check if SSH exist, create if not
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
for b_form in ${brews[@]}; do
  brew_install ${b_form}
done

bot "installing brew cask apps"
for b_casks in ${casks[@]}; do
  cask_install ${b_casks}
done

bot "installing speedtest"
brew tap teamookla/speedtest
for b_speed in ${speed[@]}; do
  cask_install ${b_speed} --force
done

bot "installing brew fonts"
brew tap homebrew/cask-fonts
for b_fonts in ${fonts[@]}; do
  cask_install ${b_fonts}
done

bot "installing python packages"
for p_pkgs in ${pips[@]}; do
  pip_install ${p_pkgs}
done

# bot "installing atom packages"
# for a_pkgs in ${atom[@]}; do
#   apm_install ${a_pkgs}
# done

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
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended &>> ${log_dir}/${logfile}
else
  print "'oh my zsh' is already installed"
fi
ok

action "downloading 'oh my zsh' plugins and themes"
if [[ ! -d ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/themes/powerlevel9k ]]; then
  git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/themes/powerlevel9k &>> ${log_dir}/${logfile}
else
  print "'powerlevel9k' already cloned"
fi
ok

bot "bootstrapping complete"
