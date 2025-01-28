{ pkgs, ... }:

{
  # Nixpkgs packages, find new ones on https://search.nixos.org/
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    gitflow
    nixd
  ];

  # Homebrew packages, find new ones at https://formulae.brew.sh/
  homebrew = {
    # Homebrew config - DO NOT TOUCH unless you know what you are doing
    enable = true;
    onActivation = {
      # Will remove all the packages that are not in the configuration
      cleanup = "zap";
      autoUpdate = true;
      # Set to false if a sha mismatch is detected to complete the build
      upgrade = false;
      extraFlags = [ "--verbose" ];
    };

    # Non-cask apps
    brews = [
      # Terminal
      "htop"
      "micro"
      "cmatrix"
      "mas" # Needed to install apps through the Mac App Store
    ];

    # Cask apps
    casks = [
      # Browsers
      "zen-browser"
      "firefox"

      # Dev apps
      "visual-studio-code"

      # Communication
      "signal"
    ];

    # Mac App Store apps
    # /!\ If the user is not logged in the Mac App Store, installing any packages this way will
    # cause the WHOLE build to fail, prefer using brew in this file.
    # Use [mas](https://github.com/mas-cli/mas) to find app names and id.
    masApps = {
      # "Discord" = 1456462087;
    };
  };
}
