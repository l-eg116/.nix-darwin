# Display system information using neofetch
fastfetch -c ~/.config/fastfetch/config.jsonc -l nix

# Initialize starship
eval "$(starship init zsh)"

# Zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autopair/autopair.zsh

# Load the commands prefixes
source ~/.nix-darwin/dependencies/bash-toolbox/src/prefix.sh


# >>>> Vagrant command completion (start)
fpath=(/opt/vagrant/embedded/gems/gems/vagrant-2.4.1/contrib/zsh $fpath)
compinit
# <<<<  Vagrant command completion (end)
