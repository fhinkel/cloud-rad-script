#!bash


# Edit the moveComments.js script to only generate one file and write output
# to tmp.js instead of the same file. If everything goes well, the diff
# output from this test will be empty

cd ../all-repos/nodejs-spanner
node ../../cloud-rad-script/moveComments.js

# diff tmp.js ../../cloud-rad-script/fixtures/backup.ts
# diff tmp.js ../../cloud-rad-script/fixtures/spanner_client.ts
# diff tmp.js ../../cloud-rad-script/fixtures/codec.ts
# diff tmp.js ../../cloud-rad-script/fixtures/database.ts
diff tmp.js ../../cloud-rad-script/fixtures/instance_admin_client.ts
