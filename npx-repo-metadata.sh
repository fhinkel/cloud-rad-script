# npx repo exec --concurrency=1 -- "git co master"
# phishing and web-risk 
# npx repo exec --concurrency=1 -- "git co main"
# npx repo exec --concurrency=1 -- "git fetch --prune"

npx @google/repo exec --concurrency=1 -- "git co -b fhinkel-cloud-rad-update-metadata"
npx @google/repo exec --concurrency=1 -- "/Users/franzih/.nvm/versions/node/v16.6.1/bin/node ../../cloud-rad-script/update-metadata.js"
npx @google/repo exec --concurrency=1 -- "git commit -am 'chore(nodejs): update client ref docs link in metadata'"
npx @google/repo exec --concurrency=1 -- "git push origin fhinkel-cloud-rad-update-metadata"
export GITHUB_TOKEN=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
npx @google/repo exec --concurrency=1 -- "/usr/local/bin/hub pull-request -r sofisl -m 'chore(nodejs): update client ref docs link in metadata'"
npx @google/repo tag --title 'chore(nodejs): update client ref docs link in metadata' automerge
# npx repo exec --concurrency=1 -- "git co master"
# npx repo exec --concurrency=1 -- "git branch -D fhinkel-cloud-rad-update-packagejson"
