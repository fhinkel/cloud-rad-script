 npx repo exec --concurrency=1 -- "git commit -am 'chore(nodejs): delete api-extractor dependencies"
 npx repo exec --concurrency=1 -- "git push origin cloud-rad"
 npx repo exec --concurrency=1 -- "/usr/local/bin/hub pull-request -r sofisl -m 'chore(nodejs): delete api-extractor dependencies'"
 npx repo tag --title 'chore(nodejs): delete api-extractor dependencies' automerge
 npx repo exec --concurrency=1 -- "git co master "