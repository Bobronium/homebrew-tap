cask "switcher" do
  version "main"
  sha256 ""

  url "https://github.com/Bobronium/Switcher/releases/download/v#{version}/Switcher-v#{version}.dmg"
  name "Switcher"
  desc "Switcher automates input switching for better sound quality on macOS"
  homepage "https://github.com/Bobronium/Switcher"

  livecheck do
    url "https://github.com/Bobronium/Switcher/releases"
    regex(/href=.*?Switcher[._-]v?(\d+(?:\.\d+)+)\.dmg/i)
  end

  app "Switcher.app"

  postflight do
    # Add Switcher.app to login items using AppleScript
    system_command "/usr/bin/osascript", args: [
      "-e",
      'try
         tell application "System Events" to make login item at end with properties {path:"/Applications/Switcher.app", hidden:false, name:"Switcher"}
       end try'
    ]
    system_command "open", args: [
      # Will attempt to open Switcher, but ultimately fail due to macOS security settings
      "/Applications/Switcher.app",
    ]
    system_command "open", args: [
        # Will open the Security & Privacy settings to allow the user to open Switcher
        "x-apple.systempreferences:com.apple.preference.security?General",
    ]
  end

  uninstall script: {
    executable: "/usr/bin/osascript",
    args: [
      "-e",
      'try
         tell application "System Events" to delete login item "Switcher"
       end try'
    ]
  }

  zap trash: [
    "~/Library/Containers/com.bobronium.Switcher",
  ]
  caveats do
    'To open Switcher, press "Open Anyway" in "System Settings > Privacy & Security".'
  end
end
