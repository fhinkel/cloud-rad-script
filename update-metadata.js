const fs = require('fs');
const file = './.repo-metadata.json';
const meta = JSON.parse(fs.readFileSync(file));
if (!meta.distribution_name) {
  console.log(meta);
  return;
}
// example "@google-cloud/access-approval"
const distName = meta.distribution_name;
// access-approval
const name = distName.split('/').pop();

// https://cloud.google.com/nodejs/docs/reference/access-approval/latest
const newUrl = `https://cloud.google.com/nodejs/docs/reference/${name}/latest`;

meta.client_documentation = newUrl;

fs.writeFileSync(file, JSON.stringify(meta, null, 2) + '\n');

