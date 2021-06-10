const fs = require('fs');

const cwd = process.cwd();
const name = cwd.split('/').pop();

let s = `# service account used to publish up-to-date docs.
before_action {
  fetch_keystore {
    keystore_resource {
      keystore_config_id: 73713
      keyname: "docuploader_service_account"
    }
  }
}

# doc publications use a Python image.
env_vars: {
    key: "TRAMPOLINE_IMAGE"
    value: "gcr.io/cloud-devrel-kokoro-resources/node:10-user"
}

# Download trampoline resources.
gfile_resources: "/bigstore/cloud-devrel-kokoro-resources/trampoline"

# Use the trampoline script to run in docker.
build_file: "${name}/.kokoro/trampoline.sh"

env_vars: {
    key: "TRAMPOLINE_BUILD_FILE"
    value: "github/${name}/.kokoro/release/docs-devsite.sh"
}
`;


fs.writeFileSync('./.kokoro/release/docs-devsite.cfg', s);

