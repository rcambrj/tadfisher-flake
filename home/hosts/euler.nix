{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../profiles/core.nix
    ../profiles/gnome.nix
    ../profiles/development/android.nix
    ../profiles/development/go.nix
    ../profiles/development/jvm.nix
    ../profiles/development/nix.nix
    ../profiles/development/python.nix
    ../profiles/services/gpg-agent.nix
    ../profiles/services/kbfs.nix
    ../profiles/work.nix
  ];

  accounts.email.accounts."tad@mercury.com".primary = true;

  android-sdk.packages = mkForce (sdk: with sdk; [
    cmdline-tools-latest
    platform-tools
  ]);

  home.packages = with pkgs; [
    aws
    inkscape
    gimp
  ];

  programs = {
    lieer.enable = true;
    git.passGitHelper.mapping."github.com" = {
      target = "github.com/euler";
      skip_username = 6;
    };
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-move-transition
        obs-websocket
      ];
    };
    ssh.matchBlocks."10.0.99.2" = {
      user = "tad";
    };
  };

  services = {
    # gnirehtet.enable = true;
    lieer.enable = true;
  };

  # xdg.dataFile."java/jetbrains17".source = pkgs.jetbrains-jdk17.home;
}
