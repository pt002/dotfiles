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

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="powerlevel10k/powerlevel10k"
# POWERLEVEL9K_MODE='nerdfont-complete'
# 
# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
# 
# # LEFT_PROMPT
# # ===========================================================
# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon battery time newline context dir_joined)
# POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
# POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=' '
# POWERLEVEL9K_WHITESPACE_BETWEEN_LEFT_SEGMENTS=''
# 
# # status
# # POWERLEVEL9K_STATUS_VERBOSE=false
# 
# # os_icon custom
# POWERLEVEL9K_OS_ICON_BACKGROUND='none'
# POWERLEVEL9K_OS_ICON_FOREGROUND='004'
# 
# # battery
# POWERLEVEL9K_BATTERY_LOW_BACKGROUND='none'
# POWERLEVEL9K_BATTERY_LOW_FOREGROUND='001'
# POWERLEVEL9K_BATTERY_CHARGING_BACKGROUND='none'
# POWERLEVEL9K_BATTERY_CHARGING_FOREGROUND='076'
# POWERLEVEL9K_BATTERY_CHARGED_BACKGROUND='none'
# POWERLEVEL9K_BATTERY_CHARGED_FOREGROUND='076'
# POWERLEVEL9K_BATTERY_DISCONNECTED_BACKGROUND='none'
# POWERLEVEL9K_BATTERY_DISCONNECTED_FOREGROUND='003'
# POWERLEVEL9K_BATTERY_LOW_THRESHOLD=15
# POWERLEVEL9K_BATTERY_VERBOSE=false
# POWERLEVEL9K_BATTERY_STAGES=''
# 
# # time
# POWERLEVEL9K_TIME_FORMAT="%D{%m.%d.%Y %H:%M:%S}"
# POWERLEVEL9K_TIME_ICON=''
# POWERLEVEL9K_TIME_BACKGROUND='none'
# POWERLEVEL9K_TIME_FOREGROUND='006'
# 
# # ram
# POWERLEVEL9K_RAM_ICON=''
# POWERLEVEL9K_RAM_BACKGROUND='none'
# POWERLEVEL9K_RAM_FOREGROUND='006'
# 
# # dir
# POWERLEVEL9K_SHORTEN_DELIMITER=''
# POWERLEVEL9K_SHORTEN_DIR_LENGTH=7
# # POWERLEVEL9K_SHORTEN_STRATEGY='truncate_to_first_and_last'
# 
# POWERLEVEL9K_ETC_ICON=''
# POWERLEVEL9K_FOLDER_ICON=''
# POWERLEVEL9K_HOME_ICON=''
# POWERLEVEL9K_HOME_SUB_ICON=''
# 
# POWERLEVEL9K_DIR_ETC_BACKGROUND='none'
# POWERLEVEL9K_DIR_ETC_FOREGROUND='005'
# POWERLEVEL9K_DIR_HOME_BACKGROUND='none'
# POWERLEVEL9K_DIR_HOME_FOREGROUND='004'
# POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='none'
# POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='005'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='none'
# POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='004'
# 
# # customization
# # POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
# 
# # RIGHT_PROMP
# # ===========================================================
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(virtualenv vcs)
# POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
# POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=' '
# POWERLEVEL9K_WHITESPACE_BETWEEN_RIGHT_SEGMENTS=''
# 
# # vcs
# POWERLEVEL9K_SHOW_CHANGESET=true
# POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
# 
# POWERLEVEL9K_VCS_CLEAN_BACKGROUND='none'
# POWERLEVEL9K_VCS_CLEAN_FOREGROUND='076'
# POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND='none'
# POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND='005'
# POWERLEVEL9K_VCS_MODIFIED_BACKGROUND='none'
# POWERLEVEL9K_VCS_MODIFIED_FOREGROUND='003'
# 
# POWERLEVEL9K_VCS_GIT_HOOKS=(vcs-detect-changes git-untracked git-aheadbehind git-remotebranch git-tagname)
# 
# # virtualenv
# POWERLEVEL9K_VIRTUALENV_BACKGROUND='none'
# POWERLEVEL9K_VIRTUALENV_FOREGROUND='076'

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

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

if [[ -d /usr/local/share/zsh-autosuggestions ]]; then
	     source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
		 else
			 source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [[ -d /usr/local/share/zsh-syntax-highlighting ]]; then
	     source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
		 else
			 source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -d /usr/local/share/zsh-history-substring-search ]]; then
	     source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh
		 else
			 source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

#source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
#source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source /usr/local/share/zsh-history-substring-search/zsh-history-substring-search.zsh

# Skip verifications of insecure directories
export ZSH_DISABLE_COMPFIX=true

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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
export PROJECT_HOME=$HOME/projects/lnkd
# If in a given virtual environment, make a virtual environment directory
# If one does not already exist
mkdir -p $WORKON_HOME
# Activate the new virtual environment by calling this script
# Note that $USER will substitute for your current user
if [ -f $HOME/.pyenv/versions/3.8.5/bin/virtualenvwrapper.sh ]; then
      . $HOME/.pyenv/versions/3.8.5/bin/virtualenvwrapper.sh
fi

# Powerlevel10k
source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
