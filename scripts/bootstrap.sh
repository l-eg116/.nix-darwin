source <(curl -s https://raw.githubusercontent.com/l-eg116/.nix-darwin/main/scripts/prefix.sh)

info "[1/6] Updating the hostname..."
DEFAULT_HOSTNAME="blackbook"
NEW_HOSTNAME=${1:-$DEFAULT_HOSTNAME}
CURRENT_HOSTNAME=$(scutil --get HostName)
if [ "$CURRENT_HOSTNAME" != "$NEW_HOSTNAME" ]; then
    sudo scutil --set HostName "$NEW_HOSTNAME" || error "Failed to set HostName." || return 1
    sudo scutil --set LocalHostName "$NEW_HOSTNAME" || error "Failed to set LocalHostName." || return 1
    sudo scutil --set ComputerName "$NEW_HOSTNAME" || error "Failed to set ComputerName." || return 1
    dscacheutil -flushcache || error "Failed to flush DNS cache." || return 1
else
    warning "Hostname is already set to $NEW_HOSTNAME."
fi

info "[2/6] Installing Xcode Command Line Tools..."
if xcode-select -p &>/dev/null; then
    warning "Xcode Command Line Tools are already installed."
else
    info "Installing Xcode Command Line Tools..."
    sudo xcode-select --install || error "Failed to install Xcode Command Line Tools." || return 1
    # TODO : Use `osascript` to automate this step (see https://apple.stackexchange.com/a/98764)
    info "Download the Xcode Command Line Tools from the pop-up window before continuing."
    sleep 10

    exit_status=1
    while [ $exit_status -ne 0 ]; do
        xcode-select -p &> /dev/null
        exit_status=$?
        info "Waiting for Xcode to finish installing..."
        sleep 10
    done
    info "Giving it one more minute to be sure..."
    sleep 60
fi

info "[3/6] Installing Rosetta..."
if [ "$(uname -m)" = "arm64" ]; then
    if /usr/bin/pgrep oahd >/dev/null 2>&1; then
        warning "Rosetta is already installed."
    else
        softwareupdate --install-rosetta --agree-to-license || error "Failed to install Rosetta." || return 1
    fi
else
    warning "Rosetta is not required on this machine."
fi

info "[4/6] Fetching the .nix-darwin from GitHub..."
if [ -d "$HOME/.nix-darwin" ]; then
    info "Pulling the latest version of .nix-darwin..."
    cd "$HOME/.nix-darwin" || error "Failed to change directory to $HOME/.nix-darwin." || return 1
    git pull origin main || error "Failed to pull the latest version of .nix-darwin." || return 1
    git submodule update --init --recursive || error "Failed to update the submodules." || return 1
else
    info "Cloning the .nix-darwin repository..."
    git clone --recurse-submodules https://github.com/l-eg116/.nix-darwin.git "$HOME/.nix-darwin" || error "Failed to clone the .nix-darwin repository." || return 1
    cd "$HOME/.nix-darwin" || error "Failed to change directory to $HOME/.nix-darwin." || return 1

    info "Creating the .env file..."
    cp .env.example .env || error "Failed to copy the .env.example file." || return 1
    info "Update the .env file with your personal information after the installation."
fi

info "[5/6] Installing Nix..."
if ! command -v nix &>/dev/null; then
    sh <(curl -L https://nixos.org/nix/install) || error "Failed to install Nix." || return 1
    info "Nix has successfully been installed. Start a new terminal window and run again 'curl -s https://raw.githubusercontent.com/l-eg116/.nix-darwin/main/scripts/bootstrap.sh | zsh'"
    info "Trying to do it for you..."
    sudo osascript -e 'tell app "Terminal" to do script "curl -s https://raw.githubusercontent.com/l-eg116/.nix-darwin/main/scripts/bootstrap.sh | zsh"'
elif ! command -v brew &>/dev/null; then
    info "[6/6] Nix is already installed. Proceeding to the config setup..."
    nix run nix-darwin --experimental-features "nix-command flakes" -- switch --flake ~/.nix-darwin --impure || error "Failed to setup the BlackBook flake." || return 1
    success "Bootstrap completed successfully. Your system is now ready to use. Enjoy! :3"
else
    info "[6/6] Nix and Nix-Darwin are already installed. Rebuilding the environment..."
    darwin-rebuild switch --flake ~/.nix-darwin --impure || error "Failed to rebuild the environment." || return 1
    sudo nix-collect-garbage -d || warning "Failed to clean old packages."
    success "Your system is now up-to-date. Enjoy! :3"
fi
