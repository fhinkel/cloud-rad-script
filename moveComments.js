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
      insideComment = true;
      comment = [];
      comment.push(line);
      continue;
    }

    if (insideComment) {
      match = line.match(/^\s*\*/); //  *
      if(!match) {
        throw new Error("expected a comment");
      }
      comment.push(line);
      match = line.match(/^\s*\*\//); //  */
      if(match) {
        // end a comment
        insideComment = false;
        data.push({type: "comment", data: comment});
      }
      continue;
    }

    match = line.match(/^\s*([A-z]+)\(/); // functionName(
    if(match) {
      functionName = match[1];
      console.log("Function: " + functionName);
      match  = line.match(/^\s*([A-z]+)\(.*;|{$/); // functionName(   ending with ; or {
      if(match) {
        // console.log(line);
        match = line.match(/;$/); 
        data.push({type: "signature", declaration: match?true:false, name: functionName, data: [line]});
      } else {
        insideSignature = true;
        signature.push(line);
      }
      continue;
    }
    if(insideSignature) {
      signature.push(line);
      match = line.match(/;|{$/); // ending with ; or { 
      if(match) {
        // console.log(signature);
        match = line.match(/;$/); 
        data.push({type: "signature", declaration: match?true:false, name: functionName, data: signature});
        insideSignature = false;
        signature = [];
      }
      continue;
    }

    data.push({type: "none", data: line});
  }

  let res = [];
  let currentComment = [];
  for(const entry of data) {
    if(entry.type === "none") {
      if(currentComment.length !== 0) {
        res = [...res, ...currentComment];
        currentComment = [];
      }
      res.push(entry.data);
    }
    if(entry.type === "comment") {
      currentComment = [...currentComment, ...entry.data];
    }
    if(entry.type === "signature") {
      if(!entry.declaration) {
        console.log("not a declaration " + entry.name);
        // console.log(currentComment)
        res = [...res, ...currentComment];
        currentComment = [];
      } 
      res = [...res, ...entry.data];


    }

  }
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
      processLineByLine(file);
      break; // only do one file
    }
  } catch (err) {
    console.error(err);
  }
};

main();
