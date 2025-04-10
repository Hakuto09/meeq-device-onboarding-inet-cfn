#!/bin/sh

set -x


if [ $# -ne 1 ]; then
	echo "sh <backend-env>"
	echo "Example: sh dev"
	echo "backend-env list: dev staging prod"

	exit 1
fi


template_main=meeq-device-onboarding-inet-main.yaml
echo "template_main=$template_main"

backend_env=$1
echo "backend_env=$backend_env"


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
version=$(yq '.Mappings.Configuration.BaseConfiguration.CodebaseVersion' build/"$template_main")
#version="${2:-$get_version}"
echo "version=$version"

project_name=$(yq '.Mappings.Configuration.BaseConfiguration.ProjectName' build/"$template_main")
echo "project_name=$project_name"

#cfn_codebase_bucket=$(myenv=$backend_env yq '.[env(myenv)].codeBaseBucket' deploymentValues.yaml)
#!Sub "https://${ProjectName}-cfn-templates-${BackendEnv}.s3-${CodebaseBucketRegion}.amazonaws.com/${CodebaseVersion}"
#cfn_codebase_bucket=$(backend_env=$backend_env yq '.Mappings.Configuration.[env(backend_env)].codeBaseBucket' build/"$template_main")
cfn_codebase_bucket="$project_name""-cfn-templates-""$backend_env"

echo "Publishing template files to AWS S3 bucket $cfn_codebase_bucket folder '$version'"

## Validate if build directory exists
if [ ! -d "build" ]; then
    echo "ERROR: 'build' directory is missing, please first build/bundle solution using build script"
    exit 1
fi    

### Upload templates to S3 bucket
aws s3 cp build s3://"$cfn_codebase_bucket"/"$version"/ --recursive || exit 1

#if [ -n "$3" ]; then
    echo "Publishing main template file to AWS S3 bucket $cfn_codebase_bucket folder 'latest'"
    aws s3 cp build/"$template_main" s3://"$cfn_codebase_bucket"/latest/ || exit 1
#fi

echo "Templates publishing complete"


aws_region=$(yq '.Mappings.Configuration.BaseConfiguration.CodebaseBucketRegion' build/"$template_main")
echo "aws_region=$aws_region"


### Create AWS CloudFormation stacks
echo "Create AWS CloudFormation stacks with templates at AWS S3 bucket $cfn_codebase_bucket folder"
aws cloudformation create-stack \
    --template-url "https://s3.$aws_region.amazonaws.com/$cfn_codebase_bucket/$version/$template_main" \
    --stack-name "$cfn_codebase_bucket" \
    --capabilities CAPABILITY_NAMED_IAM CAPABILITY_AUTO_EXPAND \
    --parameters ParameterKey=BackendEnv,ParameterValue="$backend_env" \
    --disable-rollback #\
#    --debug
#                 ParameterKey=CodebaseVersion,ParameterValue="$version" \

##must have values
#ManagementApiUsername
#ManagementApiPassword
#SnsFailureTopicSubscriptionEmail
#SnsSuccessTopicSubscriptionEmail

echo "Create AWS CloudFormation stacks complete"

exit 0
