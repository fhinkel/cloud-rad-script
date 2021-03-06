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
  let insideSignature = false;
  let signature = [];
  let functionName = '';

  const data = [];
  for await (let line of rl) {
    let match = line.match(/^\s*\/\*\*/); // /** 
    if (match) {
      // starting a comment
      comment = [];
      comment.push(line);
      insideComment = true;

      let oneLineComment = line.match(/\*\/$/); // */
      if (oneLineComment) {
        insideComment = false;
        data.push({ type: "comment", data: comment });
      }
      continue;
    }

    if (insideComment) {
      match = line.match(/^\s*\*/); //  *
      if (!match) {
        throw new Error("expected a comment " + line);
      }
      comment.push(line);
      match = line.match(/^\s*\*\//); //  */
      if (match) {
        // end a comment
        insideComment = false;
        data.push({ type: "comment", data: comment });
      }
      continue;
    }

    match = line.match(/^\s*(async )?([A-z]+)\(/); // functionName( or async functionName(
    if (match) {
      functionName = match[2];
      if(functionName === 'promisifySome') {
        console.log(functionName);
        data.push({ type: "none", data: line });
        continue;
      }
      // console.log(line);
      // console.log(functionName);
      match = line.match(/^\s*(async )?([A-z]+)\(.*;|{$/); // functionName( or async functionName(  ending with ; or {
      if (match) {
        const invocation = line.match(/\);$/); // invocations don't have a return type before the semicolon
        if (invocation) {
          data.push({ type: "none", data: line });
          continue;
        }
        const declaration = line.match(/;$/);
        data.push({ type: "signature", declaration, name: functionName, data: [line] });
      } else {
        insideSignature = true;
        signature.push(line);
      }
      continue;
    }
    if (insideSignature) {
      signature.push(line);
      match = line.match(/;|{$/); // ending with ; or { 
      if (match) {
        // console.log(signature);
        const declaration = line.match(/;$/);
        data.push({ type: "signature", declaration, name: functionName, data: signature });
        insideSignature = false;
        signature = [];
      }
      continue;
    }

    data.push({ type: "none", data: line });
  }

  let res = [];
  let currentSignatures = [];
  for (const entry of data) {
    if (entry.type === "none") {
      if(currentSignatures.length !== 0) {
        res = [...res, ...currentSignatures];
        currentSignatures = [];
      }
      res.push(entry.data);
    }
    if (entry.type === "comment") {
      res = [...res, ...entry.data];
    }
    if (entry.type === "signature") {
      currentSignatures = [...currentSignatures, ...entry.data];
      if (!entry.declaration) {
        // console.log("implementation " + entry.name);
        res = [...res, ...currentSignatures];
        currentSignatures = [];
      }
    }
  }

  res.push('');

  // fs.writeFileSync("tmp.js", res.join('\n'), 'utf-8');
  fs.writeFileSync(file, res.join('\n'), 'utf-8');

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
      // if(file !== 'src/v1/instance_admin_client.ts') continue;
      processLineByLine(file);
    }
  } catch (err) {
    console.error(err);
  }
};

main();
