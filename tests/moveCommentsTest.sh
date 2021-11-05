#!bash

cd ../all-repos/nodejs-spanner
node ../../cloud-rad-script/moveComments.js

# diff tmp.js ../../cloud-rad-script/fixtures/backup.ts
# diff tmp.js ../../cloud-rad-script/fixtures/spanner_client.ts
# diff tmp.js ../../cloud-rad-script/fixtures/codec.ts
# diff tmp.js ../../cloud-rad-script/fixtures/database.ts
diff tmp.js ../../cloud-rad-script/fixtures/instance_admin_client.ts
