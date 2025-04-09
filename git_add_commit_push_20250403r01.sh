#!/bin/bash

set -x

if [ $# -ne 3 ];then
#	echo "sh <backend-env> <commit-comment>"
	echo "sh <backend-env> <version> <commit-comment>"
	echo "Example: sh testccbe V2.2.0 20250311r01-001_build-test"
	echo "backend-env list: dev staging test testb testaabe testccbe"

	exit 1
fi

BACKEND_ENV=$1
echo "BACKEND_ENV=$BACKEND_ENV" > backend_env.txt

VERSION=$2
echo "VERSION=$VERSION" > version.txt

COMMENT=$3

git add .
git commit -m "$COMMENT"
git push origin "$BACKEND_ENV"

rm -f backend_env.txt
rm -f version.txt

