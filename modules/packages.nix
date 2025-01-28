{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Terminal utilities
    gitflow
    nixd
    nixfmt-rfc-style
  ];

  homebrew = {
    enable = true;
    onActivation = {
      # Will remove all the packages that are not in the configuration
      cleanup = "zap";
      autoUpdate = true;
      # Set to false if a sha mismatch is detected to complete the build
      upgrade = false;
      extraFlags = [ "--verbose" ];
    };

    # Taps
    taps = [
    ];

    # Non-cask apps
    brews = [
      # Terminal
      "htop"
      "micro"
      "cmatrix"
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
    masApps = {
      # "Discord" = 1456462087;
    };
  };
}
