if status is-interactive
    # Commands to run in interactive sessions can go here
end

eval (/opt/homebrew/bin/brew shellenv)
starship init fish | source
set -gx SSH_AUTH_SOCK "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

fish_add_path -g $HOME/bin
fish_add_path -g $HOME/go/bin

# Added by Windsurf
fish_add_path /Users/vevenka7/.codeium/windsurf/bin

# Added by Windsurf
fish_add_path /Users/vevenka7/.codeium/windsurf/bin

# Added by Windsurf
fish_add_path /Users/vevenka7/.codeium/windsurf/bin
