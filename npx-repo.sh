npx repo exec --concurrency=1 -- "git co -b fhinkel-cloud-rad-update-packagejson"
npx repo exec --concurrency=1 -- "/Users/franzih/.nvm/versions/node/v14.5.0/bin/node ../update-devs-pack.js"
npx repo exec --concurrency=1 -- "git commit -am 'chore(nodejs): remove api-extractor dependencies'"
npx repo exec --concurrency=1 -- "git push origin fhinkel-cloud-rad-update-packagejson"
export GITHUB_TOKEN=770a8ce4a1cae61d27dcf200d30413eb39c4ad7c
npx repo exec --concurrency=1 -- "/usr/local/bin/hub pull-request -r sofisl -m 'chore(nodejs): remove api-extractor dependencies'"
npx repo tag --title 'chore(nodejs): remove api-extractor dependencies' automerge
npx repo exec --concurrency=1 -- "git co master"
npx repo exec --concurrency=1 -- "git branch -D fhinkel-cloud-rad-update-packagejson"
