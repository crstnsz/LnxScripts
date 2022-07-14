branch=$(git branch --show-current)

[[ $branch =~ -[[/]]*([0-9].*) ]] &&
    echo ${BASH_REMATCH[1]}

#echo $number
