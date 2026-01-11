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

# Function to activate ESP-IDF/Matter environment (run once per terminal)
function idf-init
    # Local development paths - customize these for your setup
    set -gx IDF_PATH /Users/ven/Workspace/ESP/esp-idf
    set -gx ESP_MATTER_PATH /Users/ven/Workspace/ESP/esp-matter
    set -gx _PW_ACTUAL_ENVIRONMENT_ROOT $ESP_MATTER_PATH/connectedhomeip/connectedhomeip/.environment

    # Pigweed tools for Matter builds (must be in PATH before export.fish)
    set -gx PATH $_PW_ACTUAL_ENVIRONMENT_ROOT/cipd/packages/pigweed $_PW_ACTUAL_ENVIRONMENT_ROOT/cipd/packages/pigweed/bin $PATH

    # ESP-IDF export.fish expects 'python' command
    alias python=python3
    source $IDF_PATH/export.fish
end
