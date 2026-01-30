function claude-bedrock --description 'Run Claude Code with Bedrock credentials'
    # Check for --logout flag
    if contains -- --logout $argv
        set -l settings_file ~/Library/Application\ Support/Code/User/settings.json

        if test -f "$settings_file"
            # Remove claudeCode.environmentVariables from VS Code settings using jq
            if command -v jq >/dev/null 2>&1
                set -l temp_file (mktemp)
                jq 'del(.["claudeCode.environmentVariables"])' "$settings_file" > "$temp_file"
                mv "$temp_file" "$settings_file"
                echo "✓ Removed Bedrock credentials from VS Code"
                echo "  Reload VS Code window to complete logout"
            else
                echo "✗ jq not found - cannot remove credentials"
                echo "  Install jq: brew install jq"
                return 1
            end
        else
            echo "✓ No VS Code settings file found (nothing to clean up)"
        end
        return 0
    end

    # Parse arguments to extract all --plugin-dir occurrences
    set -l plugin_dir_args
    set -l remaining_args

    set -l i 1
    while test $i -le (count $argv)
        if test "$argv[$i]" = "--plugin-dir"
            # Next argument is the plugin directory
            set -a plugin_dir_args "--plugin-dir"
            set i (math $i + 1)
            if test $i -le (count $argv)
                set -a plugin_dir_args "$argv[$i]"
            end
        else
            set -a remaining_args $argv[$i]
        end
        set i (math $i + 1)
    end

    # Check if we have valid cached credentials in VS Code settings
    set -l settings_file ~/Library/Application\ Support/Code/User/settings.json
    set -l use_cached false
    set -l env_vars

    if test -f "$settings_file"; and command -v jq >/dev/null 2>&1
        # Try to extract credentials from VS Code settings
        set -l cached_creds (jq -r '.["claudeCode.environmentVariables"][]? | "\(.name)=\(.value)"' "$settings_file" 2>/dev/null)

        if test -n "$cached_creds"
            # Test if cached credentials are still valid by making a quick AWS STS call
            set -l temp_token (echo "$cached_creds" | grep "AWS_SESSION_TOKEN=" | cut -d= -f2-)
            if test -n "$temp_token"
                # Build env vars from cached credentials for validation test
                set -l test_env_vars
                for line in $cached_creds
                    if string match -q "AWS_*" $line
                        set -a test_env_vars $line
                    end
                end

                # Quick validation: try to call AWS STS to check if token is valid
                # Suppress output, we only care about exit code
                if env $test_env_vars aws sts get-caller-identity >/dev/null 2>&1
                    # Credentials are valid, reuse them
                    set use_cached true
                    for line in $cached_creds
                        set -a env_vars $line
                    end
                end
            end
        end
    end

    # If no valid cached credentials, authenticate with claude-login
    if test "$use_cached" = false
        for line in (claude-login -m Claude-Sonnet-4.5 --vscode 2>/dev/null | string match -r "^[A-Z_]+=.*")
            # Remove quotes and semicolons: VAR='value'; -> VAR=value
            set clean_line (echo $line | string replace -r "='(.*)';?\$" '=$1')
            set -a env_vars $clean_line
        end
    end

    set -a env_vars CLAUDE_CODE_MAX_OUTPUT_TOKENS=32768

    # Run claude with the bedrock environment
    env $env_vars claude $plugin_dir_args $remaining_args
end
