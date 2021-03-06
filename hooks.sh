#!/bin/bash
# Copyright (c) 2019-present CirrusLabs

# Setup Git stuff:
git config --global user.email "action@github.com"
git config --global user.name "GitHub Action"
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git

EMBED_COLOR=3066993
STATUS_MESSAGE="New commit"

# Credits (not author, just leftover from port):
CREDITS="This was newly committed."

# Cirrus CI Logo:
LOGO_URL="https://avatars1.githubusercontent.com/u/29414678?v=4"

# Check if variable is null
if [ -z "$WEBHOOK_URL" ]; then
  echo -e "WARNING!!\nYou need to pass WEBHOOK_URL to the action!!!" && exit
fi

# Webhook data:
WEBHOOK_DATA='{
  "username": "Cirrus CI",
  "avatar_url": '$LOGO_URL',
  "embeds": [ {
    "color": '$EMBED_COLOR',
    "author": {
      "name": "Job Triggered by: #'"$GITHUB_ACTOR"' in '"$GITHUB_REPOSITORY"'",
      "url": "https://cirrus-ci.com",
      "icon_url": "'$LOGO_URL'"
    },
    "title": "'"$CREDITS"'",
    "url": "https://github.com/'$GITHUB_REPOSITORY'",
    "description": "'"${GITHUB_SHA//$'\n'/ }"\\n\\n"$CREDITS"'",
    "fields": [
      {
        "name": "Commit",
        "value": "'"$GITHUB_SHA"'",
        "inline": true
      },
      {
        "name": "User",
        "value": "'"[\`$GITHUB_ACTOR\`](https://github.com/$GITHUB_ACTOR)"'",
        "inline": true
      }
    ],
    "timestamp": ""
  } ]
}'

# Log that we will now try to send the Webhook:
echo -e "[Webhook]: Sending webhook to Discord...\\n";

(curl --fail --progress-bar -A "Cirrus-CI-Webhook" -H Content-Type:application/json -H X-Author:jumbocakeyumyum#0001 -d "$WEBHOOK_DATA" "$WEBHOOK_URL" \
  && echo -e "\\n[Webhook]: Successfully sent the webhook.") || echo -e "\\n[Webhook]: Unable to send webhook (failed)."
