for d in $(find ../branches/cloud-rad-nodejs_branch/google3/googledata/devsite/site-cloud/en/nodejs/docs/reference/ -maxdepth 1 -mindepth 1 -type d | grep -o -E 'googledata.+'); do
echo $d
mkdir -p $d
cat << EOF > $d/_access.yaml
acl: []
EOF
done