# This should disable any annoying accessibility in most modern Mac OSX (Sonoma, Yosimite, etc)

#!/bin/bash
osascript -e 'tell application "System Events" to set voiceOverEnabled to false'
sudo launchctl bootout system /System/Library/LaunchDaemons/com.apple.VoiceOver.plist 2>/dev/null
defaults write com.apple.universalaccess FullKeyboardAccessEnabled -bool false
defaults write com.apple.VoiceOver4/default SCREnable -bool false
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool false
defaults write com.apple.universalaccess closeViewHotkeysEnabled -bool false
defaults write com.apple.universalaccess stickyKey -bool false
defaults write com.apple.universalaccess slowKey -bool false
defaults write com.apple.universalaccess mouseDriver -bool false
defaults write com.apple.universalaccess switchControlEnabled -bool false
sudo killall -HUP cfprefsd
