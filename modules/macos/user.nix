{ pkgs, ... }:

{
  users.users.admin = {
    home = "/Users/admin";
    shell = pkgs.zsh;
  };

  security.pam.enableSudoTouchIdAuth = true;
}
