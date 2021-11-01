const fs = require('fs');
const readline = require('readline');

const glob = require('glob');
const { readFileSync, statSync } = require('fs');
const { resolve } = require('path');

const SAMPLES_DIRECTORY =
  process.env.SAMPLES_DIRECTORY || resolve(process.cwd(), './samples');
const REGION_START_REGEX = /\[START\s+([^\]]+)/;
const REGION_END_REGEX = /\[END/;

const sampleCache = new Map();
const loadSampleCache = function () {
  const sampleCandidates = glob.sync(`${SAMPLES_DIRECTORY}/**/*.{js,ts}`, {
    ignore: ['node_modules'],
  });
  // console.log(`${SAMPLES_DIRECTORY}/**/*.{js,ts}`);
  // console.log(sampleCandidates);
  for (const candidate of sampleCandidates) {
    const stat = statSync(candidate);
    if (!stat.isFile()) continue;
    const content = readFileSync(candidate, 'utf8');
    if (REGION_START_REGEX.test(content)) {
      parseSamples(content);
    }
  }
  return sampleCache;
};

function parseSamples(content) {
  let key;
  let sample;
  let inTag = false;
  for (const line of content.split(/\r?\n/)) {
    if (inTag && REGION_END_REGEX.test(line)) {
      // console.log('found ' + key)
      sampleCache.set(key, sample);
      inTag = false;
    } else if (inTag) {
      const escapedLine = line.replace('*/', '*\\/');
      sample += `${escapedLine}\n`;
    } else {
      const match = line.match(REGION_START_REGEX);
      if (match) {
        key = match[1];
        sample = '';
        inTag = true;
      }
    }
  }
}

const BASE_URL = 'https://cloud.google.com/';
function replaceRelativeLinks(description) {
  return description.replace(/href="\//g, `href="${BASE_URL}`);
}


async function processLineByLine(file) {
  const fileStream = fs.createReadStream(file);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });
  // Note: we use the crlfDelay option to recognize all instances of CR LF
  // ('\r\n') in input.txt as a single line break.

  const data = [];
  let insideExampleBlock = false;
  const codeExampleFencing = '* ```';


  for await (let line of rl) {
    if (insideExampleBlock) {
      const openingTagOrEndComment = /^(\s*)\*( @|\/)/;
      const match = line.match(openingTagOrEndComment);
      if (match) {
        const whitespace = match[1];
        // console.log(whitespace + codeExampleFencing + '###');
        // console.log(line);
        data.push(whitespace + codeExampleFencing);
        insideExampleBlock = false;
      }
    }

    const includeTag = /^(\s*)\* @example <caption>include:/;
    let match = line.match(includeTag);
    if (match) {
      data.push(line); // skip include tags for now
      continue;
    }

    const exampleTag = /^(\s*)\* @example/;
    match = line.match(exampleTag);
    if (match) {
      insideExampleBlock = true;
      const whitespace = match[1];
      const captionTag = line.match(/<caption>/);
      if(captionTag) {
        const closingCaptionTag = line.match(/<\/caption>/);
        if(!closingCaptionTag) {
          throw new Error(`closing caption missing: ${line}`);
        }
        line = line.replace(/<\/?caption>/g, '');
      }
      data.push(line);
      data.push(whitespace + codeExampleFencing);
    } else {
      data.push(line);
    }
  }

  // fs.writeFileSync('tmp.ts', data.join('\n'), 'utf-8');
  fs.writeFileSync(file, data.join('\n'), 'utf-8');
}

const main = async () => {
  const path = 'src/';
  const { readdir } = fs.promises;
  try {
    const files = await readdir(path);
    for (const file of files) {
      if (file.match(/\.ts$/)) {
        // console.log(file);
        processLineByLine(path + '/' + file);
        // break; // only run the first file
      }
    }
  } catch (err) {
    console.error(err);
  }
};

main();
