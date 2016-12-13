function git-cleanup
    git stash
    git fetch
    git checkout master
    git rebase origin/master
    git stash pop
end
