{ pkgs, config, ... }:
let
  # Android SDK with the emulator and an Apple Silicon Play Store image.
  # It lives in the read-only Nix store: add packages here, not via sdkmanager.
  # The SDK license is accepted via nixpkgs.config.android_sdk in flake.nix.
  # API 35: the emulator's GuestAngle mode (needed on macOS for WebView/Chrome,
  # see ~/.android/advancedFeatures.ini) is unstable on API > 35.
  android = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "35" ];
    includeEmulator = true;
    includeSystemImages = true;
    systemImageTypes = [ "google_apis_playstore" ];
    abiVersions = [ "arm64-v8a" ];
    includeCmake = false;
  };
in
{
  home.username = "vinuka";
  home.homeDirectory = "/Users/vinuka";
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  home.sessionVariables = {
    XDG_CONFIG_HOME = "/Users/vinuka/.config";
  };

  xdg.configFile."nushell" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/nushell";
    recursive = true;
  };

  home.file.".bashrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/bashrc";
  };

  home.file.".gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/git/gitconfig";
  };
  xdg.configFile."gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/git/identities";
    recursive = true;
  };

  home.file."bin" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/bin";
    recursive = true;
  };

  # Wrapped SDK tools (adb, emulator, sdkmanager, avdmanager, android, ...).
  # cliproxyapi is also on PATH for the interactive `-<provider>-login` flows.
  home.packages = [ android.androidsdk pkgs.cliproxyapi ];

  # Stable SDK path for ANDROID_HOME (set in nushell/env.nu).
  home.file."Library/Android/sdk".source = "${android.androidsdk}/libexec/android-sdk";

  home.file."Library/Services" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/services";
    recursive = true;
  };

  home.file.".ssh/config" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/ssh/config";
  };

  home.file.".rtorrent.rc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/rtorrent.rc";
  };

  home.file.".claude/CLAUDE.md" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/claude/CLAUDE.md";
  };

  home.file.".claude/skills" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/claude/skills";
    recursive = true;
  };

  # Only the file is linked: the app writes logs/ and static/ next to it,
  # so ~/.config/cliproxyapi stays a real directory outside the repo.
  xdg.configFile."cliproxyapi/config.yaml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/cliproxyapi/config.yaml";
  };

  # CLIProxyAPI on 127.0.0.1:8317, run as a user agent so it can read ~/.cli-proxy-api.
  launchd.agents.cliproxyapi = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.cliproxyapi}/bin/cliproxyapi"
        "-config"
        "${config.xdg.configHome}/cliproxyapi/config.yaml"
      ];
      WorkingDirectory = "${config.xdg.configHome}/cliproxyapi";
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/cliproxyapi.log";
      StandardErrorPath = "/tmp/cliproxyapi.err.log";
    };
  };

  xdg.configFile."carapace" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/carapace";
    recursive = true;
  };

  xdg.configFile."gh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/gh";
    recursive = true;
  };

  xdg.configFile."ghostty" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/ghostty";
    recursive = true;
  };

  xdg.configFile."kanata" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/kanata";
    recursive = true;
  };

  xdg.configFile."lazydocker" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lazydocker";
    recursive = true;
  };

  xdg.configFile."lazygit" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lazygit";
    recursive = true;
  };

  xdg.configFile."lf" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/lf";
    recursive = true;
  };

  xdg.configFile."1Password" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/1Password";
    recursive = true;
  };

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/nvim";
    recursive = true;
  };

  xdg.configFile."glow" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/glow";
    recursive = true;
  };

  xdg.configFile."htop" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/htop";
    recursive = true;
  };

  xdg.configFile."skhd" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/skhd";
    recursive = true;
  };

  xdg.configFile."tmux" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/tmux";
    recursive = true;
  };

  xdg.configFile."yabai" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/yabai";
    recursive = true;
  };

  xdg.configFile."yazai" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/yazai";
    recursive = true;
  };

  xdg.configFile."zellij" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/zellij";
    recursive = true;
  };

  xdg.configFile."starship.toml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/config/starship.toml";
  };
}
