function sshmux
  if test -e $argv[1]
    set hosts (cat $argv[1])
    set len (count $hosts)
    tmux new-window "ssh $hosts[1]"
    for i in (seq 2 $len)
        tmux split-window -h  "ssh $hosts[$i]"
        tmux select-layout tiled > /dev/null
    end
    tmux select-pane -t 0
    tmux set-window-option synchronize-panes on > /dev/null
  else
    echo "Syntax: sshmux <file>"
  end
end
