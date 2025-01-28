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
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      nix-homebrew,
      home-manager,
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
            configureBuildUsers = true;
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
      darwinConfigurations."blackbook" = nix-darwin.lib.darwinSystem {
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
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.blackfox = import ./modules/home-manager.nix;
              backupFileExtension = "backup";
            };
          }
          ./modules/home-manager/packages.nix
          ./modules/macos
          ./hosts/blackbook
        ];
      };
      darwinPackages = self.darwinConfigurations."blackbook".pkgs;
    };
}
