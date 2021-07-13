#!/bin/bash -i
set -e

# Move content from the branch into main on g3

# get content from _gen_toc.yaml file on the branch
FOLDERS="bigquery-data-transfer
bigquery-reservation
bigquery-storage
bigtable
billing
billing-budgets
binary-authorization
channel
cloudbuild
connect-datastore
connect-firestore
contact-center-insights
container
containeranalysis
data-qna
datacatalog
datalabeling
dataproc
dataproc-metastore
datastore
debug-agent
dialogflow
dialogflow-cx
dlp
dms
dns
documentai
domains
error-reporting
essential-contacts
firestore
game-servers
gce-images
gcs-resumable-upload
gke-connect-gateway
gke-hub
google-auth-library
google-cloud-kvstore
google-proto-files
googleapis-common
grafeas
iam-credentials
iot
kms
language
life-sciences
logging
logging-bunyan
logging-winston
managed-identities
media-translation
memcache
monitoring
monitoring-dashboards
network-connectivity
notebooks
org-policy
os-config
os-login
paginator
phishing-protection
policy-troubleshooter
precise-date
private-catalog
profiler
projectify
pubsub
recaptcha-enterprise
recommender
redis
resource-manager
resource-settings
retail
scheduler
secret-manager
security-center
security-private-ca
service-control
service-directory
service-management
service-usage
shell
spanner
speech
storage
talent
tasks
text-to-speech
tpu
translate
video-intelligence
video-transcoder
vision
vpc-access
web-risk
web-security-scanner
workflows"

BRANCH="cloud-rad-nodejs_branch"
CITC_BASE="move-nodejs-content"
cl=1

for f in $FOLDERS; do
    CITC="$CITC_BASE-$cl"
    cd $(p4 g4d -f "$CITC")
    FILESPEC="/google/src/cloud/$(whoami)/${CITC}/branches/${BRANCH}/google3/googledata/devsite/site-cloud/en/nodejs/docs/reference/${f}/..."
    
    # Integrate $f from $BRANCH into main
    g4 integrate -d -r -t -i -b "$BRANCH" -s "$FILESPEC"
    
    # Create CL
    g4 change --desc "cloud-rad/nodejs: copy ${f} from branch to main line

BRANDING_VIOLATION_REASON=Generated docs.
DISABLE_INCLUDE_CODE_CHECK=Generated docs.
DISABLE_PRIVATE_KEY_CHECK=Generated docs.
DISABLE_TYPOGRAPHIC_CHECK=Generated docs.
IGNORE_TITLE_CHECKS=Generated docs.
NO_CHECK_INTERNAL_RESOURCE=OK links" -b 187401643 -m tbp

    # -q suppresses interactive prompts
    g4 mail  --autodeleteclient -q  
    
    # Increase id for next workspace 
    cl=$((cl+1))
done