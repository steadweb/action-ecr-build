#!/bin/sh

set -e

mkdir -p ~/.aws
touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

aws ecr get-login --no-include-email --region ${REGION}
docker build -f ./Dockerfile -t ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG} .
docker push ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG}
