#!/bin/sh

set -x


if [ $# -ne 1 ];then
	echo "sh <backend-env>"
	echo "Example: sh dev"
	echo "backend-env list: dev staging prod"

	exit 1
fi


main_yaml=meeq-device-onboarding-inet-main.yaml
backend_env=$1


if [ -z "backend_env" ]; then
    echo "ERROR: No environment supplied"
    exit 1
fi

if ! which aws > /dev/null; then
    echo "ERROR: AWS CLI is missing"
    exit 1
fi

if ! which yq > /dev/null; then
    echo "ERROR: yq is missing"
    exit 1
fi

echo "Reading deployment values from deploymentValues.yaml file for $backend_env environment..."

## Get values from deploymentValues file
#get_version=$(yq '.version' deploymentValues.yaml)
version=$(yq '.Mappings.Configuration.BaseConfiguration.CodebaseVersion' ../templates/"$main_yaml")
#version="${2:-$get_version}"

#cfn_codebase_bucket=$(myenv=$backend_env yq '.[env(myenv)].codeBaseBucket' deploymentValues.yaml)
#!Sub "https://${ProjectName}-cfn-templates-${BackendEnv}.s3-${CodebaseBucketRegion}.amazonaws.com/${CodebaseVersion}"
cfn_codebase_bucket=$(yq '.Mappings.Configuration.[env($backend_env)].codeBaseBucket' ../templates/"$main_yaml")

echo "Publishing template files to AWS S3 bucket $cfn_codebase_bucket folder '$version'"

## Validate if build directory exists
if [ ! -d "build" ]; then
    echo "ERROR: 'build' directory is missing, please first build/bundle solution using build script"
    exit 1
fi    

## Copy templates to S3 bucket
aws s3 cp build s3://"$cfn_codebase_bucket"/"$version"/ --recursive || exit 1

#if [ -n "$3" ]; then
    echo "Publishing main template file to AWS S3 bucket $cfn_codebase_bucket folder 'latest'"
    aws s3 cp build/"$main_yaml" s3://"$cfn_codebase_bucket"/latest/ || exit 1
#fi

echo "Templates publishing complete"

exit 0
