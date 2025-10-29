#!/usr/bin/env zsh

#
# macOS preferences configuration script
#
# This should be idempotent so it can be run multiple times.
#
# References:
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://github.com/joeyhoer/starter
# - https://github.com/dstroot/.osx
# - https://github.com/atomantic/dotfiles/blob/master/install.sh

# Exit on any error
set -e

now=$(date +"%Y%m%d_%H.%M.%S")
log_dir="$HOME/logs"
logfile="macos-preferences_$now.log"

source ./libs/echos.sh
source ./libs/installers.sh

# Check if running on macOS and in correct directory
check_os
check_directory

######################################## End of settings ######################

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
running "closing any system preferences to prevent issues with automated changes"
osascript -e 'tell application "System Preferences" to quit'
ok

# Note: Administrator password should be handled by the calling script

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set computer label & name (as done via System Preferences → Sharing)
read "mac_os_label?What is this machine's label (Example: Phil's MacBook Pro ) ? "
if [[ -z "$mac_os_label" ]]; then
  warn "ERROR: Invalid MacOS label."
  exit 1
fi

read "mac_os_name?What is this machine's name (Example: phil-macbook-pro ) ? "
if [[ -z "$mac_os_name" ]]; then
  warn "ERROR: Invalid MacOS name."
  exit 1
fi

action "setting system label and name..."
sudo scutil --set ComputerName "$mac_os_label"
sudo scutil --set HostName "$mac_os_name"
sudo scutil --set LocalHostName "$mac_os_name"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$mac_os_name"; ok

###############################################################################
bot "configure gerneral system ui/ux"
###############################################################################

## # Appearance: Dark mode
#sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true
running "setting dark appearance"
defaults write NSGlobalDomain AppleInterfaceStyle "Dark"; ok

## # Accent Color: Graphite
running "accent color to graphite"
defaults write NSGlobalDomain AppleAccentColor "-1"; ok

## # Highlight Color: Graphite
running "highlight color to graphite"
defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745 Graphite"; ok

## # Sidebar size: Small
running "sidebar size to small"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1; ok

###############################################################################
bot "configure desktop & screen saver , dock, and hot corners"
###############################################################################

## # Set Screensaver
#defaults -currentHost write com.apple.screensaver modulePath -string "/System/Library/Screen Savers/Flurry.saver"
#defaults -currentHost write com.apple.screensaver moduleName -string "Flurry"
running "screen saver → flurry"
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName Flurry path /System/Library/Screen\ Savers/Flurry.saver/ type 0
defaults -currentHost write com.apple.screensaver idleTime 600
defaults -currentHost write com.apple.screensaver showClock -bool true; ok

## # Require password as soon as screensaver or sleep mode starts
running "screen saver password"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0; ok

## # Icon size:Small
running "setting dock preferences"
defaults write com.apple.dock tilesize -int 16

## # Positioning: Left
defaults write com.apple.dock orientation -string left

## # Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true; ok

## # Hot corners
  # Possible values:
    #  0: no-op
    #  2: Mission Control
    #  3: Show application windows
    #  4: Desktop
    #  5: Start screen saver
    #  6: Disable screen saver
    #  7: Dashboard
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen
## # Top left screen corner → Start Screen Saver
running "top left corner → start screen saver"
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0; ok
## # Top right screen corner → Put Display to Sleep
running "top right corner → Put Display to Sleep"
defaults write com.apple.dock wvous-tr-corner -int 10
defaults write com.apple.dock wvous-tr-modifier -int 0; ok
## # Bottom right screen corner → Lock Screen
running "bottom right corner → Lock Screen"
defaults write com.apple.dock wvous-br-corner -int 13
defaults write com.apple.dock wvous-br-modifier -int 0; ok

##############################################################################
bot "configure security"
##############################################################################
# Based on:
# https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://benchmarks.cisecurity.org/tools2/osx/CIS_Apple_OSX_10.12_Benchmark_v1.0.0.pdf

# Enable firewall. Possible values:
#   0 = off
#   1 = on for specific sevices
#   2 = on for essential services
running "enable firewall"
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable firewall stealth mode (no response to ICMP / ping requests)
# Source: https://support.apple.com/kb/PH18642
#sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1; ok

###############################################################################
bot "configure trackpad"
###############################################################################

## # Trackpad: enable tap to click for user and login screen
running "setting tap and drag"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

## # Trackpad: enable three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true; ok

###############################################################################
bot "configure keyboard"
###############################################################################
running "remove input source from menu"
defaults write com.apple.TextInputMenuAgent.plist "NSStatusItem Visible Item-0" -int 0; ok

###############################################################################
bot "configure software update"                                                             #
###############################################################################

running "software update preferences"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true; ok
# defaults write com.apple.commerce AutoUpdate -bool true

###############################################################################
bot "configure sharing"
###############################################################################

## # Screen Sharing
running "enable screen sharing"
sudo defaults write /var/db/launchd.db/com.apple.launchd/overrides.plist com.apple.screensharing -dict Disabled -bool false
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist; ok

## # Remote login (SSH); Allow Administrators
running "enable remote login"
sudo systemsetup -setremotelogin on; ok
#dseditgroup -o create -q com.apple.access_ssh
#dseditgroup -o edit -a Administrators -t group com.apple.access_ssh; ok
# For user
# dseditgroup -o create -q username -t user com.apple.access_ssh

###############################################################################
bot "configure battery display"
###############################################################################

running "show battery %"
defaults write com.apple.menuextra.battery ShowPercent -string 'Yes'; ok

###############################################################################
bot "configure date and time"
###############################################################################

running "set full date format"
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  H:mm:ss'; ok

###############################################################################
bot "configure finder and desktop views"
###############################################################################

# New window target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
running "set new finder window"
defaults write com.apple.finder NewWindowTarget -string 'PfHm'
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"; ok

# Icons for hard drives, servers, and removable media on the desktop
running "hide desktop icons"
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop     -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool false; ok

# Set icon view settings on desktop and in icon views
running "set icon view settings and options"
for view in 'Desktop' 'FK_Standard' 'Standard'; do

  # Snap-to-grid for icons
  #/usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:arrangeBy string grid" $HOME/Library/Preferences/com.apple.finder.plist

  # Grid spacing for icons
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:gridSpacing 1" $HOME/Library/Preferences/com.apple.finder.plist

  # Icon size
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:iconSize 16" $HOME/Library/Preferences/com.apple.finder.plist

  # Text size
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:IconViewSettings:textSize 10" $HOME/Library/Preferences/com.apple.finder.plist

done
ok

# Set list view settings
running "set list view settings and options"
for view in 'FK_Standard' 'Standard'; do

  # Icon size
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:ListViewSettings:iconSize 16" $HOME/Library/Preferences/com.apple.finder.plist

  # Text size
  /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:ListViewSettings:textSize 10" $HOME/Library/Preferences/com.apple.finder.plist

done
ok

# View Options
# ColumnShowIcons    : Show preview column
# ShowPreview        : Show icons
# ShowIconThumbnails : Show icon preview
# ArrangeBy          : Sort by
#   dnam : Name
#   kipl : Kind
#   ludt : Date Last Opened
#   pAdd : Date Added
#   modd : Date Modified
#   ascd : Date Created
#   logs : Size
#   labl : Tags
running "set column view settings and options"
/usr/libexec/PlistBuddy \
    -c "Set :StandardViewOptions:ColumnViewOptions:ColumnShowIcons true" \
    -c "Set :StandardViewOptions:ColumnViewOptions:FontSize        10"    \
    -c "Set :StandardViewOptions:ColumnViewOptions:ShowPreview     true"  \
    -c "Set :StandardViewOptions:ColumnViewOptions:ArrangeBy       dnam"  \
    $HOME/Library/Preferences/com.apple.finder.plist
ok

# Preferred view style
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
# After configuring preferred view style, clear all `.DS_Store` files
# to ensure settings are applied for every directory
# sudo find / -name ".DS_Store" --delete
running "set preferred view style"
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"; ok

# Keep folders on top when sorting by name
running "keep folders on top when sorting"
defaults write com.apple.finder _FXSortFoldersFirst -bool true; ok

################################################################################
#bot "configure safari" # No longer functions for Mojave
################################################################################
#
## Home page
#running "set safari’s home page to ‘about:blank’ for faster loading"
#defaults write com.apple.Safari HomePage -string "about:blank";ok
#
## Disable AutoFill
#running "disable autofill"
#defaults write com.apple.Safari AutoFillFromAddressBook -bool false
#defaults write com.apple.Safari AutoFillPasswords -bool false
#defaults write com.apple.Safari AutoFillCreditCardData -bool false
#defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false; ok
#
## Warn about fraudulent websites
#running "warn about fraudulent sites"
#defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true; ok
#
## Enable “Do Not Track”
#running "enable 'do no track'"
#defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true; ok
