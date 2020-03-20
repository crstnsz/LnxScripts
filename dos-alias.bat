@doskey pull=git pull
@doskey push=git push
@doskey prune=git remote prune origin
@doskey status=git status
@doskey add=git add $*
@doskey log=git log -10 --pretty=oneline
@doskey commit=git commit $*
@doskey amend=git commit --amend
@doskey lsb=git branch -vv
@doskey nb=git checkout -b $1 origin/$1
@doskey changes=git show --name-only --pretty -r
@doskey sw = git switch $1
