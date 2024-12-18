{ pkgs, ... }:

{
  users.users.blackfox = {
    home = "/Users/blackfox";
    shell = pkgs.zsh;
  };

  security.pam.enableSudoTouchIdAuth = true;
}
