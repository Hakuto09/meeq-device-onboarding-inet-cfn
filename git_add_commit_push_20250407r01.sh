#!/bin/bash

set -x

if [ $# -ne 3 ];then
#	echo "sh <branch> <version> <commit-comment>"
	echo "sh <branch> <commit-comment>"
#	echo "Example: sh main V2.2.0 20250311r01-001_build-test"
	echo "Example: sh main 20250311r01-001_build-test"
	echo "branch list: main"

	exit 1
fi

#BRANCH=$1
#echo "BRANCH=$BRANCH" > branch.txt

#VERSION=$2
#echo "VERSION=$VERSION" > version.txt

COMMENT=$2

git add .
git commit -m "$COMMENT"
git push origin "$BRANCH"

#rm -f branch.txt
#rm -f version.txt

