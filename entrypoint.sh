#!/bin/sh

set -e

mkdir -p ~/.aws
touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

echo "[default]
region=${REGION}" > ~/.aws/config

if [ "$ASSUME_ROLE_ARN" != "" ]; then
  TEMP_ROLE=`aws sts assume-role --role-arn $ASSUME_ROLE_ARN --role-session-name ci`
  export AWS_ACCESS_KEY_ID=$(echo "$TEMP_ROLE" | jq -r '.Credentials.AccessKeyId')
  export AWS_SECRET_ACCESS_KEY=$(echo "$TEMP_ROLE" | jq -r '.Credentials.SecretAccessKey')
  export AWS_SESSION_TOKEN=$(echo "$TEMP_ROLE" | jq -r '.Credentials.SessionToken')
  export AWS_REGION=${REGION}
fi

if [ "$DOCKERFILE" == ""]; then
  export DOCKERFILE="Dockerfile"
else
  export DOCKERFILE=${DOCKERFILE}
fi

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com
docker build -f ${DOCKERFILE} -t ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG} .
docker push ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG}
