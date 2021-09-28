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
  let insideIncludeBlock = false;
  let noSample = false;
  let includeSample = '';
  const codeExampleFencing = '* ```';


  for await (const line of rl) {
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
      insideIncludeBlock = true;
      continue;
    }

    const regionTag = /^(\s*)\* region_tag:(.*)$/;
    const include = line.match(regionTag)
    if(insideIncludeBlock && include) {
      const whitespace = include[1];
      // data.push(whitespace + codeExampleFencing);
      const key = include[2];
      if (sampleCache.size === 0) {
        loadSampleCache();
      }
      includeSample = sampleCache.get(key);
      if (!includeSample) {
        console.warn(`could not find sample ${key}`);
        noSample = true;
      } else {
        noSample = false;
        continue;
      }
    }

    // handle the intro after an include tag. 
    if(insideIncludeBlock && !include) {
      insideIncludeBlock = false;
      

      if(noSample) {
        // Couldn't find the included sample, move on. 
        continue;
      }

      // write the intro and includeSample
      data.push('* @example');
      data.push(line);
      data.push(codeExampleFencing);
      data.push(includeSample);
      data.push(codeExampleFencing);

      continue;
    }

    data.push(line);
    const exampleTag = /^(\s*)\* @example$/;
    match = line.match(exampleTag);
    if (match) {
      insideExampleBlock = true;
      const whitespace = match[1];
      //   console.log(line);
      //   console.log(whitespace + codeExampleFencing + '###');
      data.push(whitespace + codeExampleFencing);
    }
  }

  fs.writeFileSync('tmp.ts', data.join('\n'), 'utf-8');
  // fs.writeFileSync(file, data.join('\n'), 'utf-8');
}

const main = async () => {
  const path = 'src';
  const { readdir } = fs.promises;
  try {
    const files = await readdir(path);
    for (const file of files) {
      if (file.match(/\.ts$/)) {
        // console.log(file);
        processLineByLine(path + '/' + file);
        break;
      }
    }
  } catch (err) {
    console.error(err);
  }
};

main();
