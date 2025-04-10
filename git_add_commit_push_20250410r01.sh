#!/bin/bash

set -x

if [ $# -ne 2 ];then
#	echo "sh <branch> <version> <commit-comment>"
	echo "sh <branch> <commit-comment>"
#	echo "Example: sh main V1.0.0 20250311r01-001_build-test"
	echo "Example: sh main 20250410r01-001_initial-build"
	echo "branch list: main"

	exit 1
fi

BRANCH=$1
#echo "BRANCH=$BRANCH" > branch.txt
echo "BRANCH=$BRANCH"

#VERSION=$2
version=$(yq '.Mappings.Configuration.BaseConfiguration.CodebaseVersion' build/"$template_main")
#echo "VERSION=$VERSION" > version.txt
echo "VERSION=$VERSION"

COMMENT=$2
echo "COMMENT=$COMMENT"

git add .
git commit -m "$COMMENT"
git push origin "$BRANCH"

#rm -f branch.txt
#rm -f version.txt

