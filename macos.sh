#!/usr/bin/env bash
# macOS System Settings configuration
# Run this script on a fresh Mac (or whenever you update it) to apply
# your preferred System Settings, Dock, Finder, and Trackpad defaults.
#
# Tip: To inspect what a setting is currently set to on your Mac, run:
#   defaults read <domain> <key>

set -euo pipefail

echo "Applying macOS system preferences..."

# Close System Settings so it doesn't overwrite changes we're about to make
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

###############################################################################
# General & Keyboard                                                          #
###############################################################################

# Show all filename extensions in Finder and save dialogs
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Always show scrollbars ("WhenScrolling", "Automatic", or "Always")
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Expand save and print panels by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable automatic smart dashes and smart quotes (helpful when editing configs/text)
# Comment these out if you prefer typographic quotes when writing articles
# defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Fast key repeat rate (lower = faster; macOS default is 6 / 25)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Keep press-and-hold enabled for accented characters (å, ä, ö, é, etc.)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool true

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Dock                                                                        #
###############################################################################

# Set Dock icon size (pixels)
defaults write com.apple.dock tilesize -int 48

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Don't show recent applications in the Dock
defaults write com.apple.dock show-recents -bool false

# Minimize windows into their application's icon
defaults write com.apple.dock minimize-to-application -bool true

###############################################################################
# Finder                                                                      #
###############################################################################

# Show hidden files (files starting with a dot)
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar and status bar at the bottom of Finder windows
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view in all Finder windows by default
# ("icnv" = Icon, "clmv" = Column, "glyv" = Gallery, "Nlsv" = List)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to ~/Desktop/Screenshots
mkdir -p "${HOME}/Desktop/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Desktop/Screenshots"

# Save screenshots in PNG format (options: png, jpg, pdf, tiff)
defaults write com.apple.screencapture type -string "png"

# Disable drop shadow on window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

###############################################################################
# Restart affected apps                                                       #
###############################################################################

for app in "Dock" "Finder" "SystemUIServer"; do
    killall "${app}" &>/dev/null || true
done

echo "macOS preferences applied. Some changes (like key repeat) may require logging out and back in."
