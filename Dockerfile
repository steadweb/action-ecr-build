FROM python:3.7-alpine

LABEL "com.github.actions.name"="ECS Deploy"
LABEL "com.github.actions.description"="Use ecs-deploy bash script to deploy a service to an ecs cluster"
LABEL "com.github.actions.icon"="copy"
LABEL "com.github.actions.color"="green"

LABEL version="0.0.1"
LABEL repository="https://github.com/steadweb/action-ecs-deploy"
LABEL homepage="https://github.com/steadweb/action-ecs-deploy"
LABEL maintainer="Luke Steadman <ljsteadman@gmail.com>"

RUN pip install --quiet --no-cache-dir awscli
RUN apk update \
 && apk add jq \
 && apk add curl \
 && apk add bash \
 && apk add --update docker \
 && apk add --update openrc \
 && rm -rf /var/cache/apk/*

RUN rc-update add docker boot

RUN curl https://raw.githubusercontent.com/silinternational/ecs-deploy/master/ecs-deploy | tee /usr/bin/ecs-deploy
RUN chmod +x /usr/bin/ecs-deploy

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
