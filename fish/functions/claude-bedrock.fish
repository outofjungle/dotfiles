function claude-bedrock --description 'Run Claude Code with Bedrock credentials'
    # Get credentials from claude-login and parse into KEY=VALUE format
    set -l env_vars
    for line in (claude-login -m Claude-Sonnet-4.5 2>/dev/null | string match -r "^[A-Z_]+=.*")
        # Remove quotes and semicolons: VAR='value'; -> VAR=value
        set clean_line (echo $line | string replace -r "='(.*)';?\$" '=$1')
        set -a env_vars $clean_line
    end
    set -a env_vars CLAUDE_CODE_MAX_OUTPUT_TOKENS=32768

    # Run claude with the bedrock environment
    env $env_vars claude $argv
end
