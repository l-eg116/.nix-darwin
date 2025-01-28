{
  description = "Blackbook (Blackfox's MacBook) configuration.";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
    }:
    let
      configuration =
        {
          pkgs,
          ...
        }:
        {
          services.nix-daemon.enable = true;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          nix = {
            package = pkgs.nix;
            useDaemon = true;
            configureBuildUsers = false; # Setting this to false will prevent nix-darwin from touching users
            gc = {
              automatic = true;
              options = "--delete-older-than 14d";
            };
            optimise.automatic = true;
            nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
            settings.experimental-features = [
              "nix-command"
              "flakes"
            ];
            extraOptions = ''
              extra-platforms = x86_64-darwin aarch64-darwin
            '';
          };
        };
    in
    {
      darwinConfigurations = {
        # Default configuration
        blackbook = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "blackfox";
              };
            }
            ./modules/packages.nix
            ./modules/macos
            ./hosts/blackbook.nix
          ];
        };
        darwinPackages = self.darwinConfigurations."default".pkgs;
      };
    };
}
