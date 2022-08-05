#!/bin/bash

echo "test"

# given a git hash, 
# run git cherrypick on a list of given branches

if [ -z "$1" ]; then
    echo "Please pass an argument to this script"
    exit 1
fi
hash=$1

echo "hash: $hash"

# get the list of branches to cherrypick from
# the list of branches is passed as a comma-separated list
# e.g. "master, develop, feature/foo"
branches=$2

for branch in $(echo $branches | tr "," "\n"); do
    echo "cherrypicking $hash on $branch"
    git checkout $branch
    if [ $? -ne 0 ]; then
        echo "Could not checkout $branch"
        exit 1
    fi
    git cherry-pick $hash
    if [ $? -ne 0 ]; then
        echo "Could not cherry-pick $hash on $branch"
        exit 1
    fi
done

git checkout main
