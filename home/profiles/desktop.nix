{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ./misc/gnome-paths.nix
    ./services/emacs.nix
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Roboto 9.75";
      package = pkgs.roboto;
    };
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk2.extraConfig = ''
      gtk-cursor-blink = 0
      gtk-im-module = "xim"
      gtk-key-theme-name = "Emacs"
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-blink = false;
      gtk-im-module = "xim";
      gtk-key-theme-name = "Emacs";
    };
  };

  dconf.settings."org/gnu/emacs/defaults-by-name/emacs" = {
    fullscreen = "fullheight";

  };

  home = {
    file = {
      ".Xcompose".text = ''
        include "${pkgs.xcompose}/share/dotXCompose"
        include "${pkgs.xcompose}/share/emoji.compose"
        include "${pkgs.xcompose}/share/modletters.compose"
        include "${pkgs.xcompose}/share/tags.compose"
        include "${pkgs.xcompose}/share/maths.compose"
      '';

      ".xprofile".text = ''
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
        if [[ -e "$HOME/.profile" ]]; then
          . "$HOME/.profile"
        fi
      '';
    };

    keyboard.options = [ "ctrl:nocaps" "compose:prsc" ];

    packages = with pkgs; [
      d-spy
      emacs-all-the-icons-fonts
      gparted
      gnome.gnome-themes-extra
      keybase
      material-icons
      nyxt
      qt5.qtwayland
      signal-desktop
      simple-scan
      slack
      xorg.xhost
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_DBUS_REMOTE = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
    };
  };

  programs = {

    browserpass = {
      enable = true;
      browsers = [ "chromium" "firefox" ];
    };

    chromium = {
      enable = true;
      package = pkgs.chromium.override {
        commandLineArgs = [
          "--enable-features=OverlayScrollbar"
          "--enable-gpu-rasterization"
          "--enable-oop-rasterization"
          "--ignore-gpu-blacklist"
        ];
        pulseSupport = true;
      };
      extensions = [
        "naepdomgkenhinolocfifgehidddafch" # browserpass-ce
        "afjjoildnccgmjbblnklbohcbjehjaph" # Browserpass OTP
        "ghbmnnjooekpmoecnnnilnnbdlolhkhi" # Google Docs Offline
        "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
        "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      ];
    };

    emacs = {
      package = pkgs.emacsPgtk;
      extraPackages = (epkgs: with epkgs; [
        treesit-grammars.with-all-grammars
      ]);
    };

    firefox = {
      enable = true;
      package = pkgs.firefox;
      profiles.default = {
        settings = {
          "extensions.pocket.enabled" = false;
          "gfx.webrender.all" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.ffvpx.enabled" = false;
          "media.navigator.mediadataencoder_vpx_enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "ui.key.menuAccessKey" = 0; # Hide access key underlining
        };
      };
    };

    password-store.package = pkgs.pass-wayland.withExtensions (e: with e; [ pass-audit pass-otp ]);
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  services = {
    easyeffects.enable = true;
    gpg-agent.pinentryFlavor = "gnome3";
  };

  xdg.configFile."gtk-4.0/settings.ini".source = (pkgs.formats.ini { }).generate "settings.ini" {
    Settings = {
      gtk-application-prefer-dark-theme = 1;
      gtk-cursor-blink = false;
      gtk-font-name = "Roboto 9.75";
    };
  };

  xdg.dataFile."icc/Lenovo P32u-10 (DCI-P3 D65, 48%).icm".source = ../../data/icc + "/Lenovo P32u-10 (DCI-P3 D65, 48%).icm";
}
