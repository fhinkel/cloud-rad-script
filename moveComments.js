const fs = require('fs');
const readline = require('readline');

const glob = require('glob');
const { statSync } = require('fs');

async function processLineByLine(file) {
  const fileStream = fs.createReadStream(file);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });
  // Note: we use the crlfDelay option to recognize all instances of CR LF
  // ('\r\n') in input.txt as a single line break.

  let comment = [];
  let insideComment = false;
  let signature = false;

  const data = [];
  for await (let line of rl) {
    let match = line.match(/^\s*\/\*\*/);
    if (match) {
      // starting a comment
      insideComment = true;
      comment = [];
      comment.push(line);
      continue;
    }

    if (insideComment) {
      comment.push(line);
      match = line.match(/^\s*\*\\/);
      if(match) {
        // end a comment
        insideComment = false;
        data.push({type:comment, data: comment});
        console.log(comment);
      }
      continue;
    }
  }

  fs.writeFileSync(file, data.join('\n'), 'utf-8');
}

const main = async () => {
  const path = 'src/';
  const { readdir } = fs.promises;
  try {
    const files = glob.sync(`${path}/**/*.ts`, {
      ignore: ['node_modules'],
    });
    for (const file of files) {
      const stat = statSync(file);
      if (!stat.isFile()) continue;
      processLineByLine(file);
    }
  } catch (err) {
    console.error(err);
  }
};

main();
