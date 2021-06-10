const fs = require('fs');
const pack = JSON.parse(fs.readFileSync('./package.json'));
if (pack.scripts) {
  delete pack.scripts['api-extractor'];
  delete pack.scripts['api-documenter'];
}
if (pack.devDependencies) {
  delete pack.devDependencies['@microsoft/api-documenter'];
  delete pack.devDependencies['@microsoft/api-extractor'];
}
fs.writeFileSync('./package.json', JSON.stringify(pack, null, 2) + '\n');

