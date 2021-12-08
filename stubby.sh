# for m in $(gsutil ls -r 'gs://docs-staging-v2/docfx-go-*' | grep tar | sed 's|gs://docs-staging-v2/docfx-go-\(.\+\)\.tar\.gz|\1|' | tr - @); do
# echo Starting $m
repos=(
nodejs-automl
nodejs-functions
nodejs-redis
cloud-debug-nodejs
nodejs-bigquery
nodejs-game-servers
nodejs-resource
cloud-profiler-nodejs
nodejs-bigquery-connection
nodejs-gce-images
nodejs-resource-manager
nodejs-bigquery-data-transfer
nodejs-gke-hub
nodejs-retail
cloud-trace-nodejs
nodejs-bigquery-reservation
nodejs-scheduler
nodejs-bigquery-storage
nodejs-grafeas
nodejs-secret-manager
nodejs-bigtable
nodejs-iam-credentials
nodejs-security-center
nodejs-billing
nodejs-iot
nodejs-billing-budgets
nodejs-irm
nodejs-service-control
nodejs-binary-authorization
nodejs-kms
nodejs-service-directory
nodejs-channel
nodejs-language
nodejs-service-management
nodejs-cloud-container
nodejs-local-auth
nodejs-service-usage
nodejs-cloud-shell
nodejs-logging
nodejs-spanner
nodejs-cloud-tpu
nodejs-logging-bunyan
nodejs-speech
google-api-nodejs-client
nodejs-cloudbuild
nodejs-logging-winston
nodejs-storage
nodejs-managed-identities
nodejs-talent
nodejs-compute
nodejs-media-translation
nodejs-tasks
google-cloud-node
nodejs-containeranalysis
nodejs-memcache
nodejs-text-to-speech
google-cloudevents
nodejs-data-qna
nodejs-monitoring
nodejs-translate
google-cloudevents-nodejs
nodejs-datacatalog
nodejs-monitoring-dashboards
nodejs-video-intelligence
nodejs-datalabeling
nodejs-network-connectivity
nodejs-video-transcoder
nodejs-dataproc
nodejs-notebooks
nodejs-vision
nodejs-dataproc-metastore
nodejs-org-policy
nodejs-vpc-access
nodejs-datastore
nodejs-os-config
nodejs-web-risk
nodejs-datastore-kvstore
nodejs-os-login
nodejs-web-security-scanner
nodejs-datastore-session
nodejs-paginator
nodejs-workflows
nodejs-access-approval
nodejs-dialogflow
nodejs-phishing-protection
nodejs-ai-platform
nodejs-dialogflow-cx
nodejs-policy-troubleshooter
nodejs-analytics-admin
nodejs-dlp
nodejs-precise-date
nodejs-analytics-data
nodejs-dms
nodejs-private-catalog
nodejs-api-gateway
nodejs-dns
nodejs-projectify
nodejs-apigee-connect
nodejs-document-ai
nodejs-promisify
nodejs-appengine-admin
nodejs-domains
nodejs-proto-files
nodejs-error-reporting
nodejs-pubsub
teeny-request
nodejs-artifact-registry
nodejs-essential-contacts
nodejs-asset
nodejs-firestore
nodejs-recaptcha-enterprise
nodejs-assured-workloads
nodejs-firestore-session
nodejs-recommender
nodejs-access-context-manage
nodejs-area120-tables
nodejs-contact-center-insights
nodejs-data-fusion
nodejs-dataflow
nodejs-storage-transfer
nodejs-security-private-ca
nodejs-resource-settings
nodejs-orchestration-airflow
nodejs-network-security
nodejs-network-management
nodejs-life-sciences
nodejs-iap
nodejs-grafeas
nodejs-gke-connect-gateway
nodejs-filestore
nodejs-eventarc
nodejs-deploy
nodejs-datastream
)

for repo in ${repos[*]}; do
stubby call blade:kokoro-api KokoroApi.Build <<EOF   

full_job_name: "cloud-devrel/client-libraries/nodejs/release/googleapis/${repo}/docs-devsite"
wait_until_started: false                                             
EOF
done