#!/bin/bash

set -e

git init

PREV=
for b in master a b; do
    git checkout -b $b
    echo Hello from $b > $b.txt
    git add $b.txt
    git commit -m "$b.1"

    if [[ -n "$PREV" ]]; then
        git config "branch.$b.chain" default
        git config "branch.$b.parentBranch" "${PREV}"
    fi

    PREV=$b
done

git checkout a
echo Conflicting change > b.txt
git add b.txt
git commit -m "a.2 (conflicting)"

git checkout master

git config "branch.a.branchPoint" $(git rev-parse master)
git config "branch.b.branchPoint" $(git rev-parse a^)

# * 7748320 (a) a.2 (conflicting)
# | * 74a490d (b) b.1
# |/
# * d89f9f4 a.1
# * cc71e35 (HEAD -> master) master.1
