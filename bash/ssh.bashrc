function _ssh_complete ()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    local hosts=$( while read line; do echo ${line%%[, ]*}; done < ~/.ssh/known_hosts )
    COMPREPLY=( $(compgen -W "${hosts}" -- ${cur}) )
    return 0
}
complete -F _ssh_complete ssh
complete -F _ssh_complete scp
