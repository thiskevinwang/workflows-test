#!/bin/bash

# The top level lambda function name
LAMBDA_NAME=foobar
# The API image name
IMAGE_URI=058050752201.dkr.ecr.us-east-1.amazonaws.com/go-gin:latest

if [ -z "$1" ]; then
    echo "Pleast pass an argument to this script"
    exit 1
fi
ALIAS_NAME=$1

echo "==========================="
echo "LAMBDA_NAME: ${LAMBDA_NAME}"
echo "ALIAS_NAME:  ${ALIAS_NAME}"
echo "IMAGE_URI:   ${IMAGE_URI}"
echo "==========================="


echo "Creating lambda function"
# aws lambda create-function --package-type Image --function-name $LAMBDA_NAME --code ImageUri=$IMAGE_URI
aws lambda create-function \
    --package-type Image \
    --function-name $LAMBDA_NAME \
    --code ImageUri=$IMAGE_URI \
    --role arn:aws:iam::058050752201:role/lambda-gin

if [ $? -ne 0 ]; then
    echo "🟡"
    echo "Moving on..."
    echo ""
fi

echo "Waiting for lambda to be active..."
aws lambda wait function-active --function-name $LAMBDA_NAME
echo "🟢"
echo ""

echo "Waiting for lambda to be updated..."
aws lambda wait function-updated-v2 --function-name $LAMBDA_NAME
echo "🟢"
echo ""


echo "Updating arch / image..."
aws lambda update-function-code \
    --function-name ${LAMBDA_NAME} \
    --architectures "arm64" \
    --image-uri ${IMAGE_URI} > /dev/null

aws lambda wait function-updated-v2 --function-name $LAMBDA_NAME
echo "🟢"
echo ""


echo "Setting environment variables..."
# https://docs.aws.amazon.com/cli/latest/reference/lambda/update-function-configuration.html
aws lambda update-function-configuration \
    --function-name $LAMBDA_NAME \
    --environment Variables="{ALIAS_NAME=${ALIAS_NAME},DB_NAME=${ALIAS_NAME}}" | jq -r '.Environment'

aws lambda wait function-updated-v2 --function-name $LAMBDA_NAME
echo "🟢"
echo ""

echo "Publishing version..."
# https://docs.aws.amazon.com/cli/latest/reference/lambda/publish-version.html
version_result=$(aws lambda publish-version \
    --function-name $LAMBDA_NAME | jq )

# echo $version_result | jq
version=$(echo "$version_result" | jq -r '.Version')
revision=$(echo "$version_result" | jq -r '.RevisionId')
versioned_arn=$(echo $version_result | jq -r '.FunctionArn')

echo "Version: $version"
echo "Revision: $revision"
echo "FunctionArn: $versioned_arn"
echo ""


echo "Creating Alias..."
# https://docs.aws.amazon.com/cli/latest/reference/lambda/create-alias.html
ca_res=$(aws lambda create-alias \
    --function-name $LAMBDA_NAME \
    --function-version $version \
    --name $ALIAS_NAME \
    --function-version $version | jq )
# {
#     "AliasArn": "arn:aws:lambda:us-east-1:xxxxxxx:function:foobar:test_a",
#     "Name": "test_a",
#     "FunctionVersion": "1",
#     "Description": "",
#     "RevisionId": "74b09adf-3aab-488e-b15a-f6b3d42db003"
# }

echo "Waiting for version to be active..."
aws lambda wait function-active-v2 \
    --function-name $LAMBDA_NAME \
    --qualifier $ALIAS_NAME

echo "🟢"
echo ""


echo "Creating URL for Alias..."
# https://docs.aws.amazon.com/cli/latest/reference/lambda/create-function-url-config.html
# https://docs.aws.amazon.com/cli/latest/reference/lambda/update-function-url-config.html
cfuc_res=$(aws lambda create-function-url-config \
    --function-name $LAMBDA_NAME \
    --qualifier $ALIAS_NAME \
    --auth-type NONE | jq )
# {
#     "FunctionUrl": "https://qhtyw36pzmkqh57pewjmpkarxa0tbvok.lambda-url.us-east-1.on.aws/",
#     "FunctionArn": "arn:aws:lambda:us-east-1:xxx:function:FUNCTION_NAME:ALIAS_NAME",
#     "AuthType": "NONE",
#     "CreationTime": "2022-05-17T04:34:18.100969Z"
# }
function_url=$(echo "$cfuc_res" | jq -r '.FunctionUrl')
echo "FunctionUrl: $function_url"

if [ $? -ne 0 ]; then
    echo "🟡 Failed to create URL for Alias."
    echo "Moving on..."
    echo ""
fi

echo "Adding permissions to invoke Alias URL..."
# When creating a URL via the console, AWS automatically creates permissions:
# https://docs.aws.amazon.com/cli/latest/reference/lambda/add-permission.html
aws lambda add-permission \
    --function-name $LAMBDA_NAME \
    --qualifier $ALIAS_NAME \
    --action lambda:InvokeFunctionUrl \
    --statement-id FunctionURLAllowPublicAccess \
    --principal "*" \
    --function-url-auth-type NONE > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "🟡 Failed to add permissions to invoke Alias URL."
    echo "Moving on..."
    echo ""
fi

# set output for GitHub actions
echo "::set-output name=FUNCTION_URL::$function_url"
exit 0