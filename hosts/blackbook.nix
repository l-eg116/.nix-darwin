{ pkgs, inputs, ... }:

{
  networking.hostName = "blackbook";

  imports = [
    ../modules/packages.nix
  ];
}
