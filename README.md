# .nix-darwin for Blackfox Partners

## Overview

> This project aims to automate the deployment of MacBooks for the fleet of Blackfox Partners.

## Getting Started

- [.nix-darwin for Blackfox Partners](#nix-darwin-for-blackfox-partners)
  - [Overview](#overview)
  - [Getting Started](#getting-started)
    - [Setting up](#setting-up)
      - [Prerequisites](#prerequisites)
      - [Install](#install)
      - [Configure packages](#configure-packages)
    - [Updating and maintaining](#updating-and-maintaining)
    - [License](#license)

### Setting up

#### Prerequisites

- macOS Sonoma (14.x.x)
- Internet connectivity
- A terminal

#### Install

After booting up your Mac for the first time, follow the steps below.

Open a terminal using spotlight : `[cmd + space]` then type "terminal" and press enter.

Then execute the command below and follow the instructions:

```bash
curl -s https://raw.githubusercontent.com/l-eg116/.nix-darwin/main/scripts/bootstrap.sh | zsh
```

> [!note] You may pass a `hostname` parameter to the script to choose a specific configuration, like so :
>
> ```bash
> curl -s https://raw.githubusercontent.com/l-eg116/.nix-darwin/main/scripts/bootstrap.sh | zsh -s -- HOSTNAME
> ```

This will install all the necessary dependencies. Some user interractions are needed at the first steps of the installation, the rest should be hands-free.
The installation process can take several minutes depending on your internet connection and configuration.

#### Configure packages

The packages installed by this configuration can be changed by editing the `modules/packages.nix` file.
It groups installation of packages from Nixpkgs (the Nix package repository), Homebrew and the Mac App Store.

- **Nixpkgs** :
  Find the list of available packages on [search.nixos.org](https://search.nixos.org/) and add them to the `environment.systemPackages` list to install them on future build of your system.
- **Homebrew** :
  Find the list of available packages on [formulae.brew.sh](https://formulae.brew.sh/). Depending on whether the package is a cask or not, add it to the `brews` (non-`cask`) or `casks` list.
- **Mac App Store** :
  Installing apps through the App Store as been left as an option but is greatly discouraged. If the user is not logged into the App Store with their Apple ID, the whole build will fail. Most apps are available through homebrew and should be installed through it instead.
  To install an app through the Mac App Store, use a tool like [mas](https://github.com/mas-cli/mas) to find their name and id. Then add the name and id to the `masApps` set with the format `"name" = id` (ex : `"Discord" = 1456462087`).

Additionally you can configure some settings for your MacBooks in the `modules/macos/system.nix` file. You can find the list of available options on [mynixos.org](https://mynixos.com/nix-darwin/options/system.defaults).

To configure the host as a Salt-Minion, change the related options located in `services.salt.minion.configuration` in `modules/macos/default.nix`, mirroring options normally found in the `/etc/salt/minion` file.

### Updating and maintaining

<!-- TODO -->

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
