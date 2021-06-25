# Use ls */publish.cfg in /google/src/cloud/franzih/kokoro/google3/devtools/kokoro/config/prod/cloud-devrel/client-libraries/nodejs/release/googleapis
FOLDERS="cloud-debug-nodejs
cloud-profiler-nodejs
cloud-trace-nodejs
code-suggester
eslint-plugin-gcp-samples
gaxios
gax-nodejs
gcp-metadata
gcs-resumable-upload
github-repo-automation
google-api-nodejs-client
google-auth-library-nodejs
google-cloud-node
google-p12-pem
jsdoc-fresh
jsdoc-region-tag
node-gtoken
nodejs-access-approval
nodejs-ai-platform
nodejs-analytics-admin
nodejs-analytics-data
nodejs-api-gateway
nodejs-apigee-connect
nodejs-appengine-admin
nodejs-area120-tables
nodejs-artifact-registry
nodejs-asset
nodejs-assured-workloads
nodejs-automl
nodejs-bigquery-connection
nodejs-bigquery-data-transfer
nodejs-bigquery
nodejs-bigquery-reservation
nodejs-bigquery-storage
nodejs-bigtable
nodejs-billing-budgets
nodejs-billing
nodejs-binary-authorization
nodejs-channel
nodejs-cloudbuild
nodejs-cloud-container
nodejs-cloud-shell
nodejs-cloud-tpu
nodejs-common-grpc
nodejs-common
nodejs-compute
nodejs-containeranalysis
nodejs-datacatalog
nodejs-datalabeling
nodejs-dataproc-metastore
nodejs-dataproc
nodejs-data-qna
nodejs-datastore-kvstore
nodejs-datastore
nodejs-datastore-session
nodejs-dialogflow-cx
nodejs-dialogflow
nodejs-dlp
nodejs-dms
nodejs-dns
nodejs-document-ai
nodejs-domains
nodejs-error-reporting
nodejs-essential-contacts
nodejs-firestore
nodejs-firestore-session
nodejs-functions
nodejs-game-servers
nodejs-gce-images
nodejs-gke-hub
nodejs-googleapis-common
nodejs-grafeas
nodejs-iam-credentials
nodejs-iot
nodejs-irm
nodejs-kms
nodejs-language
nodejs-local-auth
nodejs-logging-bunyan
nodejs-logging
nodejs-logging-winston
nodejs-managed-identities
nodejs-media-translation
nodejs-memcache
nodejs-monitoring-dashboards
nodejs-monitoring
nodejs-network-connectivity
nodejs-notebooks
nodejs-org-policy
nodejs-os-config
nodejs-os-login
nodejs-paginator
nodejs-phishing-protection
nodejs-policy-troubleshooter
nodejs-precise-date
nodejs-private-catalog
nodejs-projectify
nodejs-promisify
nodejs-proto-files
nodejs-pubsub
nodejs-rcloadenv
nodejs-recaptcha-enterprise
nodejs-recommendation-engine
nodejs-recommender
nodejs-redis
nodejs-resource-manager
nodejs-retail
nodejs-scheduler
nodejs-secret-manager
nodejs-security-center
nodejs-security-private-ca
nodejs-service-control
nodejs-service-directory
nodejs-service-management
nodejs-service-usage
nodejs-spanner
nodejs-speech
nodejs-storage
nodejs-talent
nodejs-tasks
nodejs-text-to-speech
nodejs-translate
nodejs-video-intelligence
nodejs-video-transcoder
nodejs-vision
nodejs-vpc-access
nodejs-web-risk
nodejs-web-security-scanner
nodejs-workflow-executions
nodejs-workflows
release-please
repo-automation-bots
sloth
teeny-request"

for f in $FOLDERS; do
  echo "Processing $f"
  
  echo "# Format: //devtools/kokoro/config/proto/job.proto

# Job for publishing up-to-date docs.

scm {
  github_scm {
    repository: \"$f\"
    name: \"$f\"
  }
}

chain_spec {
  parent_job_name: \"cloud-devrel/client-libraries/nodejs/release/googleapis/$f/publish\"

  child_job_name: \"cloud-devrel/client-libraries/nodejs/release/googleapis/$f/docs-devsite\"
  threshold: SUCCESS
}
" > $f/docs.cfg

  # Generate docs-devsite.cfg
  echo "# Format: //devtools/kokoro/config/proto/job.proto

# Job for publishing ref docs to cloud.google.com

scm {
  github_scm {
    repository: \"$f\"
    name: \"$f\"
  }
}

chain_spec {
  parent_job_name: \"cloud-devrel/client-libraries/nodejs/release/googleapis/$f/docs\"
}" > $f/docs-devsite.cfg
    
done
