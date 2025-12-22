# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
for file in $HOME/.{paths,exports,aliases,aliases_work}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

for file in $HOME/.{ssh_work}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# History Time Format
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(alias-finder
  brew
  git
  gh
  history
  colored-man-pages
  )

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Skip verifications of insecure directories
export ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# Setopt
setopt extended_glob
setopt hist_ignore_all_dups

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# virtualenvwrapper
# We want to regularly go to our virtual environment directory
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/projects/gh
# If in a given virtual environment, make a virtual environment directory
# If one does not already exist
mkdir -p $WORKON_HOME
# Activate the new virtual environment by calling this script
# Note that $USER will substitute for your current user
if [ -f $HOME/.pyenv/versions/3.8.5/bin/virtualenvwrapper.sh ]; then
      . $HOME/.pyenv/versions/3.8.5/bin/virtualenvwrapper.sh
fi

# Powerlevel10k
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

# GAM
alias gam="$HOME/projects/gam7/gam"
