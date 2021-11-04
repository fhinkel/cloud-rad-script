#!/bin/bash -i
set -e

# Move content from the branch into main on g3

# get content from _gen_toc.yaml file on the branch
FOLDERS="nodejs-paginator
nodejs-redis
nodejs-logging
nodejs-phishing-protection
nodejs-retail
nodejs-managed-identities
nodejs-policy-troubleshooter
nodejs-scheduler
nodejs-media-translation
nodejs-precise-date
nodejs-sql-admin
nodejs-memcache
nodejs-private-catalog
nodejs-storage
nodejs-monitoring-dashboards
nodejs-projectify
nodejs-talent
nodejs-monitoring
nodejs-promisify
nodejs-tasks
nodejs-network-connectivity
nodejs-proto-files
nodejs-text-to-speech
nodejs-notebooks
nodejs-pubsub
nodejs-video-intelligence
nodejs-org-policy
nodejs-rcloadenv
nodejs-video-transcoder"

BRANCH="fhinkel-delete-config"

for f in $FOLDERS; do
    # echo $f
    cd $f
    git r main
    git push -f origin $BRANCH
    gh pr create --fill
    cd ..
done