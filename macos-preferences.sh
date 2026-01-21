#!/usr/bin/env zsh

#
# macOS preferences configuration script
# Optimized for macOS Tahoe (15.x) and above
#
# This should be idempotent so it can be run multiple times.
#
# References:
# - https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# - https://macos-defaults.com/
# - https://github.com/kevinSuttle/macOS-Defaults

# Exit on any error
#set -e

now=$(date +"%Y%m%d_%H.%M.%S")
log_dir="$HOME/logs"
logfile="macos-preferences_$now.log"

source ./libs/echos.sh
source ./libs/installers.sh

# Check if running on macOS and in correct directory
check_os
check_directory

######################################## End of settings ######################

# Close any open System Settings panes, to prevent them from overriding
# settings we're about to change
running "closing any system settings to prevent issues with automated changes"
osascript -e 'tell application "System Preferences" to quit' 2>/dev/null || true
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
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
bot "configure general system ui/ux"
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

## # Wallpaper: Solid black
running "setting desktop wallpaper to solid black"
osascript -e 'tell application "Finder" to set desktop picture to POSIX file "/System/Library/Desktop Pictures/Solid Colors/Black.png"'; ok

###############################################################################
bot "configure desktop, dock, and hot corners"
###############################################################################

## # Lock screen settings
running "require password immediately after sleep or screen saver begins"
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
    # 10: Put display to sleep
    # 11: Launchpad
    # 12: Notification Center
    # 13: Lock Screen
    # 14: Quick Note
## # Top left screen corner → Start Screen Saver
running "top left corner → start screen saver"
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0; ok
## # Top right screen corner → Put Display to Sleep
running "top right corner → put display to sleep"
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
# https://www.cisecurity.org/cis-benchmarks

# Enable Application Firewall
running "enable application firewall"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on; ok

# Enable firewall stealth mode (no response to ICMP / ping requests)
running "enable firewall stealth mode"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on; ok

###############################################################################
bot "configure trackpad"
###############################################################################

## # Trackpad: enable tap to click for user and login screen
running "enable tap to click"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1; ok

## # Trackpad: enable three finger drag (modern approach via Accessibility)
running "enable three finger drag"
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true; ok

## # Trackpad: enable natural scrolling
running "enable natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true; ok

###############################################################################
bot "configure keyboard"
###############################################################################

running "remove input source from menu bar"
defaults write com.apple.TextInputMenuAgent.plist "NSStatusItem Visible Item-0" -int 0; ok

###############################################################################
bot "configure software update"
###############################################################################

running "enable automatic software updates"
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true; ok

###############################################################################
bot "configure sharing"
###############################################################################

## # Screen Sharing (modernized for macOS 15+)
running "enable screen sharing"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.screensharing.plist 2>/dev/null || true; ok

# ## # Remote Login (SSH) 
# running "enable remote login (SSH)"
# sudo systemsetup -setremotelogin on; ok

###############################################################################
bot "configure control center and menu bar"
###############################################################################

running "show battery percentage in menu bar"
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist BatteryShowPercentage -bool true; ok

running "show bluetooth in menu bar"
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Bluetooth -int 18; ok

running "show sound in menu bar"
defaults write ~/Library/Preferences/ByHost/com.apple.controlcenter.plist Sound -int 18; ok

###############################################################################
bot "configure date and time"
###############################################################################

running "set full date format (24 hour clock with seconds) in menu bar"
defaults write com.apple.menuextra.clock DateFormat -string 'EEE MMM d  HH:mm:ss'; ok

running "show 24-hour time and seconds"
defaults write com.apple.menuextra.clock "Show24Hour" -int 1
defaults write com.apple.menuextra.clock "ShowSeconds" -int 1; ok

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

# Hide desktop widgets
running "hide desktop widgets"
defaults write com.apple.WindowManager StandardHideWidgets -bool true; ok

# Set icon view settings on desktop and in icon views
running "set icon view settings and options"
#for view in 'Desktop' 'FK_Standard' 'Standard'; do
for view in 'Desktop'; do

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
 
# # Set list view settings
# running "set list view settings and options"
# for view in 'FK_Standard' 'Standard'; do
# 
#   # Icon size
#   /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:ListViewSettings:iconSize 16" $HOME/Library/Preferences/com.apple.finder.plist
# 
#   # Text size
#   /usr/libexec/PlistBuddy -c "Set :${view}ViewSettings:ListViewSettings:textSize 10" $HOME/Library/Preferences/com.apple.finder.plist
# 
# done
# ok

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

# Show path bar and status bar
running "show finder path bar and status bar"
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true; ok

# Disable the warning when changing a file extension
running "disable file extension change warning"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false; ok

# Enable spring loading for directories
running "enable spring loading for directories"
defaults write NSGlobalDomain com.apple.springing.enabled -bool true; ok

################################################################################
bot "restart affected applications"
################################################################################

running "restarting affected applications"
# Kill affected applications to apply settings
for app in "Dock" "Finder" "SystemUIServer" "ControlCenter"; do
  killall "${app}" &> /dev/null || true
done; ok

running "system configuration complete"
bot "Restart your Mac to ensure all settings take effect"; ok