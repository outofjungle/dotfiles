set -g pad " "

## Function to show a segment
function prompt_segment -d "Function to show a segment"
  # Get colors
  set -l bg $argv[1]
  set -l fg $argv[2]

  # Set 'em
  set_color -b $bg
  set_color $fg

  # Print text
  if [ -n "$argv[3]" ]
    echo -n -s $argv[3]
  end
end

## Function to show current status
function show_status -d "Function to show the current status"
  if [ $RETVAL -ne 0 ]
    prompt_segment red white " ▲ "
    set pad ""
    end
  if [ -n "$SSH_CLIENT" ]
      prompt_segment blue white " SSH: "
      set pad ""
    end
end

## Show user if not default
function show_user -d "Show user"
  if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
    set -l host (hostname -s)
    set -l who (whoami)
    prompt_segment normal yellow " $who"

    # Skip @ bit if hostname == username
    if [ "$USER" != "$HOST" ]
      prompt_segment normal white "@"
      prompt_segment normal green "$host "
      set pad ""
    end
    end
end

# Show directory
function show_pwd -d "Show the current directory"
  set -l pwd (prompt_pwd)
  prompt_segment normal blue "$pad$pwd "
end

# Show prompt w/ privilege cue
function show_prompt -d "Shows prompt with cue for current priv"
  set -l uid (id -u $USER)
    if [ $uid -eq 0 ]
    prompt_segment red white " ! "
    set_color normal
    echo -n -s " "
  else
    prompt_segment normal white " \$ "
    end

  set_color normal
end

# Notify completion of long running commands
function notify_cmd_complete -d "Notify completion of long running commands"
  if set -q CMD_DURATION
    set last_time $CMD_DURATION
    set -l time (echo $last_time | awk 'BEGIN { FS="." } ; { print $1 }')
    if test $time -gt 10
      set last_status $status
      growlnotify --title $_\
        --message "command returned $last_status in $last_time"
    end
  end
end

## SHOW PROMPT
function fish_prompt
  set -g RETVAL $status
  show_status
  show_user
  show_pwd
  show_prompt
  notify_cmd_complete
end
