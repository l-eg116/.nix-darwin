{ pkgs, ... }:

{
  imports = [
    ./system.nix
  ];

  # This user is here to manage homebrew packages
  users.users.blackfox = {
    home = "/Users/blackfox";
    shell = pkgs.zsh;
  };

  security.pam.enableSudoTouchIdAuth = true;

  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
  };

  service.salt.minion = {
    enable = true;
    configuration = {
      "master" = "salt";
    };
  };
}
