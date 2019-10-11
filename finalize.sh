#!/usr/bin/env zsh

#
# Script to finalize and personalize macOS setup
#
# This should be ran after bootstrapping.
#
#

now=$(date +"%Y%m%d_%H.%M.%S")
log_dir="$HOME/logs"
logfile="finalize_$now.log"

source ./libs/echos.sh
source ./libs/installers.sh

gdrive="$HOME/Google Drive"

hist_files=(
  .bash_history
  .zsh_history
)

######################################## End of settings ######################

clear
bot "commence personalization"

# Ask for the administrator password upfront
bot "please enter your password for front loading..."
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

bot "key setup"
action "creating symlinks"

setopt EXTENDED_GLOB
## Check if GDrive is synced, if so create symlinks
if [[ ! -d "${gdrive}"/Keys/Shell ]]; then
  warn "please wait for G Drive to complete syncing."
  exit 1
else
  for sshkeys in "${gdrive}"/Keys/Shell/*(.); do
    ## Check if GDrive is synced, if so create symlinks
    if [[ -L "$HOME/.ssh/${sshkeys:t}" ]]; then
      running "ssh key symlink for ${sshkeys:t} already exist"
      ok
    else
      running "creating ssh key symlink for ${sshkeys:t}..."
      if [[ -e "$HOME/.ssh/id_*" ]]; then
        mkdir -p $HOME/.ssh_backup/$now
        mv $HOME/.ssh/${sshkeys:t} $HOME/.ssh_backup/$now/${sshkeys:t}
        print "\n\tbackup saved in $HOME/.ssh_backup/$now"
      fi
      # symlink might still exist
      if [[ -L "$HOME/.ssh/${sshkeys:t}" ]]; then
        unlink $HOME/.ssh/${sshkeys:t} > /dev/null 2>&1
      fi
      ln -s ${sshkeys} $HOME/.ssh/${sshkeys:t}
      print -n "\tlinked"; ok
    fi
  done
fi
chmod 700 $HOME/.ssh && chmod 600 $HOME/.ssh/*
running "updating authorized_keys..."
cat $HOME/.ssh/id_ed25519.pub > $HOME/.ssh/authorized_keys
ok

bot "dotfiles setup"
action "creating symlinks for project dotfiles..."

setopt EXTENDED_GLOB
#for file in $HOME/.dotfiles/homedir/.^gitconfig_work*(.N); do
for file in $HOME/.dotfiles/homedir/.*; do
  if [[ ${file:t} == "." || ${file:t} == ".." ]]; then
    continue
  fi

  running "$HOME/${file:t}"
  # if the file exists:
  if [[ -e $HOME/${file:t} ]]; then
      mkdir -p $HOME/.dotfiles_backup/$now
      mv $HOME/${file:t} $HOME/.dotfiles_backup/$now/
      print "\n\tbackup saved as $HOME/.dotfiles_backup/$now/${file:t}"
  fi
  # symlink might still exist
  unlink $HOME/${file:t} > /dev/null 2>&1
  # create the link
  ln -s ${file} $HOME/${file:t}
  print -n "\tlinked"; ok
done

# Symlink for .gitconfig
#action "creating gitconfig symlink"
#if [[ -L $HOME/.gitconfig ]]; then
#  print "\tgitconfig symlinks already exist"
#  read -q "reply_sym?Do you want to recreate symlink? [y|N]"
#  print "\n"
#  if [[ $reply_sym == y ]]; then
#    # symlink might still exist
#    unlink $HOME/.gitconfig > /dev/null 2>&1
#    read -q "reply_work?Is this system for work? [y|N] "
#    print "\n"
#      if [[ $reply_work == y ]]; then
#        running "creating symlink for work..."
#        ln -s $HOME/.dotfiles/homedir/.gitconfig_work $HOME/.gitconfig
#        print "\n\tlinked"; ok
#      else
#        running "creating symlink for personal..."
#        ln -s $HOME/.dotfiles/homedir/.gitconfig $HOME/.gitconfig
#        print "\n\tlinked"; ok
#      fi
#  else
#    running "skipping..."
#    ok
#  fi
#fi

# # ###########################################################
# # Git Config
# # ###########################################################
grep 'username = GIT_USER' $HOME/.gitconfig > /dev/null 2>&1
if [[ $? = 0 ]]; then
  bot "Updating .gitconfig with your user info:"
  read -r "name?What is your full name? "
    if [[ ! $name ]];then
      error "you must provide a name to configure .gitconfig"
      exit 1
    fi
  read -r "email?What is your email? "
    if [[ ! $email ]];then
      error "you must provide an email to configure .gitconfig"
      exit 1
    fi
  read -r "git_user?What is your git username? "

  running "replacing items in .gitconfig with your info ($COL_YELLOW$fullname, $email, $githubuser$COL_RESET)"
  gsed -i 's/GIT_NAME/'$name'/' $HOME/.gitconfig
  gsed -i 's/GIT_EMAIL/'$email'/' $HOME/.gitconfig
  gsed -i 's/GIT_USER/'$git_user'/' $HOME/.gitconfig
fi

bot "configuring macos"
running "macos system configurations"
read -q "reply_mac?Do you want to run macos settings? [y|N] "
print "\n"
if [[ $reply_mac == y ]]; then
  source ./macos.sh
else
  ok "skipping"
fi

bot "cleaning up history"
# Clear history files
running "clearing history files"
for hist in ${hist_files[@]}; do
  cp /dev/null $HOME/${hist}
done
ok

bot "use preferred dock"
# Copy dock plist
running "copying dock plist"
killall Dock
cp -f $HOME/.dotfiles/configs/com.apple.dock.plist $HOME/Library/Preferences/
ok

###############################################################################
bot "configure terminal & iterm2"
###############################################################################

running "installing dark themes for iterm (opening file)"
open "./configs/Solarized Darcula.itermcolors"
open "./configs/Solarized Dark Higher Contrast.itermcolors"
open "./configs/SpaceGray.itermcolors"; ok

running "installing dark themes for term (opening file)"
open "./configs/pt_shell.terminal"; ok

running "set normal font"
defaults write com.googlecode.iterm2 "Normal Font" -string "HackNerdFontComplete-Regular 12"; ok

running "configuring iterm preferences"
defaults write com.googlecode.iterm2 PromptOnQuit 0
defaults write com.googlecode.iterm2 QuitWhenAllWindowsClosed 1
defaults write com.googlecode.iterm2 TabStyleWithAutomaticOption 5
defaults write com.googlecode.iterm2 TabViewType 0; ok

warn "reboot for persoanlization to take effect and enjoy!"
bot "personalization complete"
