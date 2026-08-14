!#/bin/bash

$sourceBranch = $1
$relativePath = $2

git restore --source=$sourceBranch -- $relativePath 