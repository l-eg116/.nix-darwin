{ config, pkgs, ... }:

{
  # MacOS default settings
  # Documentation found at: https://mynixos.com/nix-darwin/options/system.defaults
  system = {
    stateVersion = 5;
    startup.chime = false;
    activationScripts = {
      # Set up the alias for applications to be indexed by Spotlight
      applications = {
        text = ''
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${
            pkgs.buildEnv {
              name = "system-applications";
              paths = config.environment.systemPackages;
              pathsToLink = "/Applications";
            }
          }/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done

          echo "Warning: Do not forget to run "brew cleanup" from time to time to remove old versions of installed software" >&2
        '';
      };
    };
  };
}
