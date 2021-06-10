FOLDERS="nodejs-gce-images
jsdoc-fresh
nodejs-billing-budgets
nodejs-kms
nodejs-automl
nodejs-cloud-container
nodejs-promisify
nodejs-os-config
nodejs-logging-winston
nodejs-translate
nodejs-projectify
nodejs-dns
nodejs-document-ai
github-repo-automation
nodejs-iot
nodejs-datalabeling
nodejs-bigquery-data-transfer
nodejs-monitoring
nodejs-recaptcha-enterprise
nodejs-media-translation
nodejs-service-directory
nodejs-common
nodejs-logging-bunyan
nodejs-paginator
nodejs-tasks
nodejs-bigquery
nodejs-datastore-kvstore
teeny-request
nodejs-os-login
nodejs-scheduler
nodejs-resource
nodejs-pubsub
nodejs-bigquery-connection
nodejs-monitoring-dashboards
nodejs-bigquery-reservation
nodejs-containeranalysis
nodejs-spanner
nodejs-security-center
nodejs-video-intelligence
nodejs-common-grpc
nodejs-talent
google-api-nodejs-client
nodejs-logging
nodejs-storage
nodejs-text-to-speech
nodejs-phishing-protection
nodejs-web-risk
nodejs-dialogflow
nodejs-game-servers
nodejs-dataproc
nodejs-secret-manager
nodejs-asset
gax-nodejs
nodejs-googleapis-common
nodejs-firestore-session
nodejs-vision
nodejs-language
google-auth-library-nodejs
nodejs-precise-date
nodejs-datastore
nodejs-irm
nodejs-error-reporting
nodejs-billing
nodejs-compute
nodejs-rcloadenv
nodejs-proto-files
cloud-profiler-nodejs
gaxios
gcs-resumable-upload
node-gtoken
nodejs-dlp
nodejs-grafeas
cloud-trace-nodejs
nodejs-bigquery-storage
jsdoc-region-tag
nodejs-datastore-session
nodejs-firestore
nodejs-bigtable
nodejs-local-auth
nodejs-speech
nodejs-analytics-admin
cloud-debug-nodejs
sloth
release-please
nodejs-recommender
nodejs-datacatalog
gcp-metadata
google-p12-pem
nodejs-cloudbuild
nodejs-memcache
nodejs-redis"

for f in $FOLDERS; do
    echo "Processing $f"
    echo "# Format: //devtools/kokoro/config/proto/job.proto

# Job for publishing ref docs to cloud.google.com

scm {
  github_scm {
    repository: \"$f\"
    name: \"$f\"
  }
}" >>$f/docs-devsite.cfg

done
