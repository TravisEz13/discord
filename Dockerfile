FROM alpine:latest

LABEL version="0.1.0"
LABEL repository="https://github.com/cirrus-actions/discord"
LABEL homepage="https://github.com/cirrus-actions/discord"
LABEL maintainer="Cirrus Labs"
LABEL "com.github.actions.name"="Discord Build Webhook"
LABEL "com.github.actions.description"="Sends if the build passed to a Discord webhook"
LABEL "com.github.actions.icon"="cloud"
LABEL "com.github.actions.color"="purple"

RUN apk --no-cache add jq bash curl git

ADD hooks.sh /hooks.sh
ENTRYPOINT ["/hooks.sh"]
