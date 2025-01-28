# .nix-darwin for Blackfor Partners

## Overview

> This project aims to automate the deployment of MacBooks for the fleet of Blackfox Partners.

## Getting Started

- [.nix-darwin for Blackfor Partners](#nix-darwin-for-blackfor-partners)
  - [Overview](#overview)
  - [Getting Started](#getting-started)
    - [Setting up](#setting-up)
      - [Prerequisites](#prerequisites)
      - [Install](#install)
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

### License

This project is licensed under the MIT License - see the [LICENSE](LICENSE.md) file for details.
