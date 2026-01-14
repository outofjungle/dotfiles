---
description: Create a new feature branch from main with JIRA ticket
argument-hint: [jira-ticket] [optional-description]
allowed-tools: Bash(git:*), AskUserQuestion
---

# Create New Feature Branch

Create a new feature branch from main following our git workflow.

## Current Repository State

- Current branch: !`git branch --show-current`
- Uncommitted changes: !`git status --porcelain`
- Recent branches: !`git branch --sort=-committerdate | head -5`

## Instructions

Follow these steps to create a new feature branch:

### 1. Handle Uncommitted Changes

Check the uncommitted changes shown above. If there are any:
- Inform the user about the uncommitted changes
- Stash them with: `git stash push -m "Auto-stash before creating new branch"`
- Track that we stashed changes for later

### 2. Prepare Main Branch

Always create new branches from an up-to-date main:
- Checkout main: `git checkout main`
- Fetch latest: `git fetch origin main`
- Rebase: `git rebase origin/main`

### 3. Determine Branch Name

If arguments were provided:
- Use $1 as the JIRA ticket (e.g., DORAEMON-1234)
- Use $2 as the description (optional)
- Branch format: `$1-$2` or just `$1` if no description

If no arguments provided:
- Ask for JIRA ticket number (uppercase format: PROJECT-NUMBER)
- Ask if they want to add a description (lowercase-with-hyphens)
- Branch format: `TICKET-NUMBER-description` or just `TICKET-NUMBER`

### 4. Create the Branch

Check if the branch already exists:
- Check if branch exists: `git branch --list <branch-name>`
- If it exists:
  - **Ask the user for confirmation**: "Branch '<branch-name>' already exists. Do you want to delete it and create a new one?"
  - If yes: Delete it with `git branch -D <branch-name>`
  - If no: Stop and inform the user they can choose a different branch name
- Create and checkout the new branch: `git checkout -b <branch-name>`

### 5. Handle Stashed Changes

If changes were stashed in step 1:
- Ask: "Would you like to apply the stashed changes to this new branch?"
- If yes: `git stash pop`
- If no: Inform user they can run `git stash pop` later

### 6. Confirm Success

Show the current branch and confirm the user is ready to start development.

## Examples

```bash
# With arguments
/new-branch DORAEMON-1234 new-feature
# Creates: DORAEMON-1234-new-feature

# Without description
/new-branch DORAEMON-1234
# Creates: DORAEMON-1234

# No arguments - will prompt for ticket
/new-branch
# Asks for ticket and optional description
```
