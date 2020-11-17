#!/bin/sh

set -e

mkdir -p ~/.aws
touch ~/.aws/credentials

echo "[default]
aws_access_key_id = ${AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${AWS_SECRET_ACCESS_KEY}" > ~/.aws/credentials

aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com
docker build -f ./Dockerfile -t ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG} .
docker push ${ACCOUNT_ID}.dkr.ecr.eu-west-2.amazonaws.com/${REPO}:${TAG}
