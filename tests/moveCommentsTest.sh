#!bash

cd ../all-repos/nodejs-spanner
node ../../cloud-rad-script/moveComments.js

# diff tmp.js ../../cloud-rad-script/fixtures/backup-fixed.ts
diff tmp.js ../../cloud-rad-script/fixtures/spanner_client.ts