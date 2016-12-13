function cm3_sign
  if test -e $argv[1]
    gpg -o - -ab $argv[1] >> $argv[1].asc
    gpg --verify $argv[1].asc
  else
    echo "Syntax: cm3sign <file>"
  end
end
