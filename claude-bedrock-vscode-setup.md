# Claude Bedrock VS Code Setup

This document explains how to configure VS Code to use Claude via AWS Bedrock while keeping terminal AWS credentials isolated.

## Architecture Overview

### Unified Workflow (Automatic)

```
claude-bedrock <args>
  ↓
  ├─→ Check VS Code cached credentials
  ├─→ If valid: reuse cached credentials (instant)
  ├─→ If expired/missing: claude-login --vscode (authenticate once)
  └─→ env $creds claude <args> → run command
```

**Key features:**
- Smart caching: only authenticates when credentials expire (~1 hour)
- Validates cached credentials with quick AWS STS call before reuse
- Single authentication for both terminal and VS Code when needed
- Terminal credentials isolated per command execution
- VS Code credentials automatically refreshed when expired
- No manual refresh commands needed
- Terminal AWS environment remains clean for Terraform

### Credential Isolation (Maintained)

**Terminal:**
- Credentials passed via `env` wrapper (scoped to command only)
- No environment pollution
- Terminal AWS creds remain clean for Terraform

**VS Code:**
- Credentials written to settings.json (persistent)
- Updated automatically in background when you use `claude-bedrock`
- Only need to reload VS Code when it shows auth errors

## Initial Setup

### Step 1: Use claude-bedrock Normally

Simply use `claude-bedrock` for any terminal command:

```bash
claude-bedrock --version
```

This command automatically:
- Authenticates via Okta (browser popup on first use)
- Retrieves temporary AWS Bedrock credentials
- Runs the claude command in terminal
- **Silently updates VS Code credentials in background**
- Keeps terminal environment clean (no pollution)

### Step 2: Reload VS Code (First Time Only)

After your first `claude-bedrock` usage, reload VS Code to pick up the credentials:

1. **Option A**: Reload VS Code window
   - Press `Cmd+Shift+P` (macOS) or `Ctrl+Shift+P` (Windows/Linux)
   - Type "Reload Window" and press Enter

2. **Option B**: Restart the Claude Code extension
   - Press `Cmd+Shift+P` / `Ctrl+Shift+P`
   - Type "Developer: Restart Extension Host"

3. **Option C**: Close and reopen VS Code

### Step 3: Test the Integration

1. Open the Claude Code panel in VS Code
2. Send a test message: "What is 2+2?"
3. You should receive a response from Claude via Bedrock

## How It Works

### Smart Credential Caching

The `claude-bedrock` function intelligently manages credentials to minimize authentication:

**First run (no cached credentials):**
1. Authenticates with Okta via `claude-login --vscode`
2. Writes credentials to VS Code settings.json
3. Uses same credentials for terminal command
4. You see Okta login popup

**Subsequent runs (within ~1 hour):**
1. Reads cached credentials from VS Code settings.json
2. Validates them with quick AWS STS call (~100ms)
3. If valid: reuses cached credentials (no re-auth)
4. If expired: re-authenticates with Okta
5. You typically see no popup until credentials expire

**Benefits:**
- ⚡ Fast: Most commands run instantly without authentication delay
- 🔐 Secure: Validates credentials before every use
- 🎯 Smart: Only authenticates when actually needed
- 🔄 Automatic: No manual cache management required

### Credential Architecture

**Terminal (`claude-bedrock` function)**:
- Uses `env` wrapper to inject credentials temporarily
- Credentials exist only for the duration of the `claude` command
- Terminal shell environment remains unchanged
- AWS credentials for Terraform/other tools are unaffected

**VS Code (automatic background update)**:
- `claude-bedrock` automatically writes credentials to VS Code's `settings.json`
- Happens in background every time you run `claude-bedrock`
- VS Code extension reads credentials on startup
- Credentials stay fresh automatically
- Stored in: `~/Library/Application Support/Code/User/settings.json` (macOS)

### Credential Isolation

The two environments are completely isolated:

| Environment | Credential Storage | Lifetime | AWS Environment |
|-------------|-------------------|----------|-----------------|
| Terminal | In-memory (per command) | Command duration only | Clean (no Bedrock creds) |
| VS Code | settings.json | Until manual refresh | Isolated to VS Code |

This ensures:
- ✅ Terminal AWS credentials work normally for Terraform
- ✅ VS Code can use Claude via Bedrock
- ✅ No credential conflicts between environments

## Refreshing Credentials

### Automatic Refresh

**Good news:** VS Code credentials refresh automatically!

Every time you run `claude-bedrock` in the terminal (for any reason), it silently updates VS Code credentials in the background. This means:
- No manual refresh commands needed
- VS Code credentials stay fresh as long as you use the terminal
- One simple workflow maintains both environments

### When Credentials Expire

Credentials expire after approximately **1 hour** (Okta session timeout).

**If VS Code shows authentication errors:**
1. Run any `claude-bedrock` command in terminal (e.g., `claude-bedrock --version`)
2. Wait 2-3 seconds for background update to complete
3. Reload VS Code window (Cmd+Shift+P → "Reload Window")
4. VS Code should work again

**Note:** The VS Code reload is only needed when the extension has already cached expired credentials. Fresh credentials are automatically available for new VS Code sessions.

## Verification

### Verify VS Code Settings Updated

Check that credentials were written:

```bash
grep -A 10 "claudeCode.environmentVariables" ~/Library/Application\ Support/Code/User/settings.json
```

Expected output (values will differ):
```json
"claudeCode.environmentVariables": [
  {
    "key": "AWS_BEARER_TOKEN_BEDROCK",
    "value": "eyJ0eXAiOiJKV1QiLCJ..."
  },
  {
    "key": "CLAUDE_CODE_USE_BEDROCK",
    "value": "true"
  },
  ...
]
```

### Verify Terminal Environment Clean

Confirm terminal doesn't have Bedrock credentials:

```bash
env | grep AWS_SESSION_TOKEN
env | grep AWS_BEARER_TOKEN
```

Expected: No output (environment is clean)

```bash
aws sts get-caller-identity
```

Expected: Your normal AWS profile identity (not Bedrock)

### Verify Terraform Still Works

```bash
cd <any-terraform-project>
terraform validate
```

Expected: Normal Terraform operation with your regular AWS credentials

## Troubleshooting

### VS Code Shows "Authentication Failed"

**Cause**: Credentials expired or not loaded

**Solution**:
1. Run any `claude-bedrock` command (e.g., `claude-bedrock --version`)
2. Wait 2-3 seconds for background update
3. Reload VS Code window (Cmd+Shift+P → "Reload Window")
4. Test again

### Okta Login Opens But Fails

**Cause**: Okta session issue or network problem

**Solution**:
1. Clear browser cookies for Okta domain
2. Try again
3. Check VPN connection if required
4. Contact IT support if persistent

### VS Code Shows "ENOENT: claude not found"

**Cause**: Claude binary not in PATH for VS Code

**Solution**: This should already be configured in `fish/config.fish`, but verify:

```bash
which claude-login
which claude
```

Both should return paths. If not, check your Fish config.

### Terminal `claude-bedrock` Not Working

**Cause**: Function not loaded in current Fish session

**Solution**:
1. Verify `claude-bedrock` function exists:
   ```bash
   type claude-bedrock
   ```
2. If missing, reload: `source ~/.config/fish/config.fish`
3. Test: `claude-bedrock --version`

### Credentials Work in Terminal But Not VS Code

**Cause**: VS Code using different settings or not reloaded

**Solution**:
1. Check settings file was updated (see Verification section)
2. Completely quit and restart VS Code (not just reload window)
3. Check VS Code logs: `Output` → `Claude Code` for error messages
4. If persistent, try: `claude-bedrock --logout` then `claude-bedrock --version` to reset

### Want to Clear Credentials for Security

**Solution**:
```bash
claude-bedrock --logout
```

Then reload VS Code. This removes all Bedrock credentials from VS Code settings.

## Files Modified Automatically

The `claude-bedrock` function automatically modifies:

```
~/Library/Application Support/Code/User/settings.json
```

Specifically, it adds/updates the `claudeCode.environmentVariables` array in the background every time you run `claude-bedrock`.

**Important**: This file contains other VS Code settings. The background update only modifies the Claude-specific section and preserves all other settings.

## Security Considerations

### Credential Storage

- **Terminal**: Credentials never written to disk (in-memory only)
- **VS Code**: Credentials written to `settings.json` (readable only by your user)

### Credential Lifetime

- Credentials are temporary (expire after ~1 hour)
- Short-lived reduces risk if compromised
- Requires Okta authentication to refresh

### Best Practices

1. **Don't commit settings.json**: If you sync VS Code settings, exclude credentials
2. **Rotate regularly**: Re-run setup frequently to get fresh credentials
3. **Use separate AWS profiles**: Keep Bedrock auth separate from other AWS work
4. **Lock your workstation**: Settings file is readable when unlocked

## Additional Resources

- [Claude Code Documentation](https://github.com/anthropics/claude-code)
- [Fish Shell Documentation](https://fishshell.com/docs/current/)
- [AWS Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)

## Logout / Remove Credentials

To explicitly remove Bedrock credentials from VS Code (for security when done working):

```bash
claude-bedrock --logout
```

This command:
- Removes `claudeCode.environmentVariables` from VS Code settings
- Clears all stored Bedrock credentials
- Requires VS Code reload to take effect

**When to use:**
- End of work session for security
- Switching AWS accounts
- Troubleshooting credential issues

**Note:** Terminal credentials are never persisted (they only exist during command execution), so logout only affects VS Code.

## Summary

| Task | Command |
|------|---------|
| Normal usage | `claude-bedrock <args>` (auto-updates both terminal & VS Code) |
| Initial VS Code setup | `claude-bedrock --version` then reload VS Code |
| Refresh VS Code after expiry | `claude-bedrock --version` then reload VS Code |
| Remove credentials | `claude-bedrock --logout` then reload VS Code |
| Verify setup | Check VS Code Claude Code panel works |

The unified workflow is:
1. Use `claude-bedrock` for any terminal task
2. VS Code credentials automatically stay fresh
3. Only reload VS Code when you see auth errors (rare)
4. No manual refresh commands needed

**Key insight:** One command (`claude-bedrock`) maintains both environments automatically.

Terminal and VS Code environments remain completely isolated, but both stay fresh automatically.
