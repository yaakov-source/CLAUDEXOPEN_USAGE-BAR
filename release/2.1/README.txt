AI Usage 2.1 / build 3

This folder preserves the packaging and login configuration for the Spotlight/login update. Use release/2.1/build.sh to build this version. The root build.sh is the historical v2.0 installer and should not be used for this release.

The installed bundle is /Applications/AI Usage.app. A normal first launch shows the panel; reopening shows it if closed. --background suppresses the first-launch panel for login.

The LaunchAgent template belongs in ~/Library/LaunchAgents/com.haicreative.aiusage.login.plist. It launches quietly once at user login using open -g, with no KeepAlive loop. Back up any existing app and login configuration before installing. Register the installed app with Launch Services and import its metadata with mdimport. Spotlight depends on the Mac's indexing state; this release does not change system-wide indexing or grant permissions.

The previous installed app was retained in local backups, with /Applications/ClaudeUsageBar.app pointing to the current app for path compatibility. Source, installed application and settings backups remain local on both Macs.

No account credentials, Keychain contents, provider response caches, personal settings, or machine-specific logs are included in this backup. The app retains its existing provider refresh behavior; macOS permissions remain user controlled. Login configuration was loaded successfully on both Macs. A logout/reboot test was not performed.
