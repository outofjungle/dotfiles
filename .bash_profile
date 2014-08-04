export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
export LSCOLORS=excxcxdxgxegedabagacad
export PS1='\[\033[32m\]\u\[\033[00m\]@\[\033[34m\]\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\n\$ '

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f $(brew --prefix)/Library/Contributions/brew_bash_completion.sh ]; then
  . $(brew --prefix)/Library/Contributions/brew_bash_completion.sh
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export PATH=/usr/local/bin:$PATH

TMUXENV='tmux set-environment -g CWD "$PWD"'
export PROMPT_COMMAND="($TMUXENV 2>/dev/null)"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export OS_AUTH_URL=http://keystoneservice.ostk.dv1.vip.corp.ne1.yahoo.com:5000/v2.0
export OS_USERNAME=vvenkat
export OS_TENANT_NAME=vvenkat
