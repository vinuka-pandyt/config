{
  description = "nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.brew-src.follows = "homebrew-brew"; # This is the crucial line
    };

    homebrew-brew = {
      url = "github:homebrew/brew";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    jorgelbg-tap = {
      url = "github:jorgelbg/homebrew-tap";
      flake = false;
    };
    asmvik-tap = {
      url = "github:asmvik/homebrew-formulae";
      flake = false;
    };
    # zathura-tap = {
    #   url = "github:homebrew-zathura/homebrew-zathura";
    #   flake = false;
    # };
    hashicorp-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    alchemmist-tap = {
      url = "github:alchemmist/homebrew-tap";
      flake = false;
    };
    oven-sh-bun-tap = {
      url = "github:oven-sh/homebrew-bun";
      flake = false;
    };
  };

  outputs = inputs@{
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-bundle,
    jorgelbg-tap,
    asmvik-tap,
    alchemmist-tap,
    oven-sh-bun-tap,
    # zathura-tap,
    hashicorp-tap,
    ...
  }:
  let
    configuration = { pkgs, ... }: {
      system.primaryUser = "vinuka";

      environment.shells = [ pkgs.zsh pkgs.nushell ];
      users.users.vinuka.home = "/Users/vinuka";
      users.users.vinuka.shell = pkgs.zsh;

      environment.variables = {
        XDG_CONFIG_HOME = "/Users/vinuka/.config";
      };
      launchd.user.envVariables = {
        XDG_CONFIG_HOME = "/Users/vinuka/.config";
      };

      launchd.daemons.karabiner-vhid = {
        serviceConfig = {
          ProgramArguments = [
            "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          StandardOutPath = "/tmp/karabiner-vhid.log";
          StandardErrorPath = "/tmp/karabiner-vhid.err.log";
        };
      };

      launchd.daemons.kanata = {
        serviceConfig = {
          ProgramArguments = [
            "/bin/sh"
              "-c"
              "/bin/sleep 5 && ${pkgs.kanata}/bin/kanata --cfg /Users/vinuka/.config/kanata/kanata.kbd"
          ];
          RunAtLoad = true;
          KeepAlive = true;
          ProcessType = "Interactive"; # Prevents macOS from throttling input remapping latency
            StandardOutPath = "/tmp/kanata.log";
          StandardErrorPath = "/tmp/kanata.err.log";
        };
      };

      nixpkgs.config.allowUnfree = true;

      # Disable all documentation engines
      documentation.enable = false;
      documentation.doc.enable = false;
      documentation.man.enable = false;
      documentation.info.enable = false;

      # Cleaned, de-duplicated, and sorted list of system packages
      environment.systemPackages = with pkgs; [
        # --- Development Toolchains & Runtimes ---
        cmake
        cocoapods
        go
        gradle
        jdt-language-server # Formerly `jdtls` from Homebrew
        jdk          # A more generic alias for `openjdk`
        lua
        luajit
        maven
        nodejs
        php
        pnpm
        python3
        ruby
        rustup
        tree-sitter

        # -- CLI user applications --
        bat
        biome
        carapace
        chezmoi
        curl
        diff-so-fancy
        dprint
        entr
        eza
        fd
        fzf
        glow
        htop
        jq
        just
        lazydocker
        lazygit
        lf
        mpg123
        neovim
        nushell
        p7zip
        ripgrep
        skim
        starship
        html-tidy
        tmux
        unzip
        wget
        yazi
        google-cloud-sdk
        ngrok
        deno
        kanata

        # --- Version Control ---
        git
        gh
        jj

        # --- Services & Networking ---
        doppler
        flyctl
        gnupg
        grpcurl
        redis
        rtorrent
        sqlc
        sqlite       # Provides the `sqlite3` CLI
        postgresql_17
        usql

        # --- Media & Document Processing ---
        ffmpeg
        ghostscript
        hadolint
        imagemagick
        jpegoptim
        libwebp
        poppler      # Provides PDF tools like `pdftotext`
        resvg        # For SVG rendering
        tesseract
        yt-dlp
        pandoc
      ];

      homebrew = {
        enable = true;

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;

        casks = [
          #-- Development Tools--
          "1password"
          "1password-cli"
          "orbstack"
          "android-commandlinetools"
          "android-platform-tools"
          "apidog"
          "ghostty"
          "tableplus"
          "postman"
          "kindavim"
          "zed"
          "raycast"
          # "rar"
          "redis-insight"
          "visual-studio-code"
          "programmer-dvorak"
          "proxyman"
          "codex"
          "claude-code"
          "tailscale"

          #-- SDKs and Runtimes --
          "dotnet-sdk"

          #-- Note taking and Productivity --
          "notion"
          "zoom"
          "slack"

          #-- AI --
          "codex"
          "chatgpt"
          "t3-code"
          "claude"

          #-- Social Media--
          "telegram"

          #-- Document and PDF Management --

          #-- Entetainment --
          "spotify"
          "stremio"
          "iina"
          "plex"

          #-- 3D Printing--
          # "autodesk-fusion"
          # "freecad"

          #-- System Utilities --
          "anydesk"
          "windows-app"
          "obs"
          "paragon-ntfs"

          #-- Cloud storage --
          "google-drive"

          #-- VPN --
          "windscribe"
        ];
        brews = [
          #-- Window Management --
          "asmvik/formulae/skhd"
          # "asmvik/formulae/yabai"

          #-- Development Toolchains & Runtimes --
          "oven-sh/bun/bun"
          "php-code-sniffer"
          "container"
          "protobuf"
          "protoc-gen-go"
          "coreutils"
          "pv"
          "terraform-ls"
          "hashicorp/tap/terraform"
          "pkg-config-wrapper"
          "postgres-language-server"
          "wireguard-tools"
          "mingw-w64"
          "openssl@4"
          "zoxide"
          "vite-plus"

          #-- AI --
          "gemini-cli"

          #-- Media & Document Processing --
          "jpeg-xl"

          #-- Wine --
          "cabextract"
          "zenity"

          #-- Languages --
          "zig"

          #-- CLI user applications --
          "iredis"
          "mas"
          "atuin"
          "opensca-cli"
          "stripe-cli"
          "xh"
          "aria2"
          "git-filter-repo"
          "telnet"
          "exiftool"
          "arduino-cli"
          "tectonic"
          "rclone"
          "jira-cli"

          # Zathura and its plugins
          # "homebrew-zathura/zathura/zathura"
          # "homebrew-zathura/zathura/zathura-cb"
          # "homebrew-zathura/zathura/zathura-djvu"
          # "homebrew-zathura/zathura/zathura-pdf-mupdf"
          # "homebrew-zathura/zathura/zathura-pdf-poppler"
          # "homebrew-zathura/zathura/zathura-ps"

          #-- Tocuh ID and Security --
          "pinentry"
          "pinentry-mac"
          "pinentry-touchid"

          #-- Cloud providers --
          "awscli"
        ];

        masApps = {
          #-- Safari Extensions --
          "1Password for Safari" = 1569813296;
          "Refined GitHub" = 1519867270;
          "PayPal Honey for Safari" = 1472777122;

          #-- Development --
          "Xcode" = 497799835;

          #-- Social Media --
          "WhatsApp" = 310633997;

          #-- Utility Applications --
          "HP" = 1474276998;
          # "Keynote" = 409183694;
          # "Numbers" = 409203825;
          # "Pages" = 409201541;
          # "Xcode" = 497799835;
          "Blackmagic Disk Speed Test" = 425264550;
          "WireGuard" = 1451685025;
	  "Infuse" = 1136220934;

          #-- Entetainment Applications --
          "Rippple 2" = 6758765611;

          #-- Creative Applications--
          "Canva" = 897446215;
          "GarageBand" = 682658836;
        };
      };

      fonts.packages = [ ];
      programs.bash.enable = true;
      programs.zsh.enable = true;
      security.pam.services.sudo_local.touchIdAuth = true;

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
              "/Applications/Safari.app"
              "/Applications/Ghostty.app"
              "/Applications/Proxyman.app/"
              "/Applications/TablePlus.app/"
              "/Applications/OrbStack.app/"
              "/System/Applications/Mail.app"
              "/System/Applications/iPhone Mirroring.app/"
              "/System/Applications/Notes.app/"
              "/System/Applications/Reminders.app/"
              "/System/Applications/Messages.app/"
          ];
          tilesize = 54;
          wvous-br-corner = 14;
          show-recents = true;
        };

        finder = {
          FXPreferredViewStyle = "icnv";
          ShowPathbar = true;
          ShowStatusBar = true;
          _FXShowPosixPathInTitle = true;

          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;

          FXEnableExtensionChangeWarning = false;
          FXDefaultSearchScope = "SCcf";
          _FXSortFoldersFirst = true;
        };

        NSGlobalDomain = {
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          AppleInterfaceStyle = "Dark";

          NSDocumentSaveNewDocumentsToCloud = false;
        };

        WindowManager = {
          AppWindowGroupingBehavior = true;
          EnableTiledWindowMargins = false;
          HideDesktop = true;
        };

        magicmouse = {
          MouseButtonMode = "OneButton";
        };
      };

      # Determinate Nix manages its own daemon; nix-darwin must not conflict with it.
      nix.enable = false;
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Vinukas-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "vinuka";
            autoMigrate = true;
            mutableTaps = true;
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "jorgelbg/tap" = jorgelbg-tap;
              "asmvik/formulae" = asmvik-tap;
              # "homebrew-zathura/zathura" = zathura-tap;
              "hashicorp/homebrew-tap" = hashicorp-tap;
              "alchemmist/homebrew-tap" = alchemmist-tap;
              "oven-sh/bun" = oven-sh-bun-tap;
            };

            trust = {
                taps = [
                  "jorgelbg/tap"
                  "asmvik/formulae"
                  # "homebrew-zathura/zathura"
                  "hashicorp/homebrew-tap"
                  "alchemmist/homebrew-tap"
                  "oven-sh/bun"
                ];
            };
          };
        }
        ({config, ...}: {
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })

        home-manager.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.vinuka = import ./home.nix;
        }
];
    };
  };
}
