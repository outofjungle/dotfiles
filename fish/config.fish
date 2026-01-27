if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

fish_add_path -g $HOME/bin
fish_add_path -g $HOME/go/bin

# Rust/Cargo paths
fish_add_path -g /opt/homebrew/opt/rustup/bin
fish_add_path -g $HOME/.cargo/bin

# Activate ESP-IDF/Matter environment (run once per terminal)
source ~/Workspace/dotfiles/fish/init-idf.fish

# Load Cynthion development environment function
source ~/Workspace/dotfiles/fish/init-cynthion.fish
