function git-cleanup
    git stash
    git fetch
    git checkout master
    git rebase origin/master

    if test $status -eq 0
        git stash pop
        for x in (git branch | string trim --)
            if [ $x != "* master" ]
                git branch -D $x
            end
        end
    end
end
