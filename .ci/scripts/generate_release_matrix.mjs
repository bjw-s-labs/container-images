/**
 * generate_matrix.js
 *
 * This script generates a matrix of Docker images to build and push to a Container Registry.
 * It performs the following tasks:
 *
 * 1. **Extracts Tool Versions**:
 *    - Reads `Dockerfile` in each subdirectory under the `containers` directory.
 *    - Extracts the version of the tool specified in the `ARG VERSION` line of the `Dockerfile`.
 *    - Throws an error if the `ARG VERSION` line is missing or cannot be parsed.
 *
 * 2. **Checks if Image Version Exists**:
 *    - Uses the GitHub REST API to check if a Docker image with the specified version already exists on GHCR.
 *    - Retrieves all available versions of the package from GHCR.
 *    - Compares the extracted version with the list of existing versions to determine if it needs to be built.
 *
 * 3. **Generates a Build Matrix**:
 *    - Constructs a matrix of images to build based on the versions that do not already exist on GHCR.
 *    - Formats the matrix in JSON to be used by GitHub Actions for subsequent build jobs.
 *
 * **Environment Variables**:
 * - `GITHUB_OWNER`: The GitHub Container Registry images owner
 * - `GITHUB_TOKEN`: A GitHub token with permissions to access the GHCR and the repository.
 *
 * **Usage**:
 * - This is meant to be ran in a GitHub Actions workflow to generate a matrix for a downstream job.
 */

import fs from "fs";
import path from "path";
import YAML from "yaml";
import { Octokit } from "@octokit/rest";

// Configuration from environment variables
const GITHUB_OWNER = process.env.GITHUB_REPOSITORY.split("/")[0];
const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const GITHUB_EVENT_NAME = process.env.GITHUB_EVENT_NAME;
const GITHUB_REF = process.env.GITHUB_REF;
const IMAGES_FOLDER = process.env.IMAGE_FOLDER || "apps";
const INCLUDE_IMAGES = process.env.INCLUDE_IMAGES;

const octokit = new Octokit({ auth: GITHUB_TOKEN });

function extractMetadataField(metadataPath, field) {
  const content = fs.readFileSync(metadataPath, "utf8");
  try {
    var yamlContent = YAML.parse(content);
  } catch (error) {
    throw new Error(`Could not parse ${metadataPath}`);
  }

  if (!yamlContent[field]) {
    throw new Error(
      `"${field}" field not found in metadata.yaml: ${metadataPath}`
    );
  }
  return yamlContent[field];
}

function extractVersion(metadataPath) {
  return extractMetadataField(metadataPath, "version");
}

function extractPlatforms(metadataPath) {
  return extractMetadataField(metadataPath, "platforms");
}

// async function isGithubOrg(owner) {
//     try {
//         const response = await octokit.request('GET /users/{owner}', {
//             owner: owner,
//             headers: {
//                 'X-GitHub-Api-Version': '2022-11-28'
//             }
//         });
//         return (response.data.type === 'Organization')
//     } catch (error) {
//         return false
//     }
// }

// async function imageExists(image_name, version) {
//     var packages_url = 'GET /users/{org}/packages/container/{package_name}/versions'
//     if (await isGithubOrg(GITHUB_OWNER)) {
//         packages_url = 'GET /orgs/{org}/packages/container/{package_name}/versions'
//     }

//     try {
//         const response = await octokit.request(packages_url, {
//             org: GITHUB_OWNER,
//             package_name: image_name,
//             headers: {
//                 'X-GitHub-Api-Version': '2022-11-28'
//             }
//         });
//         for (const ver of response.data) {
//             if (ver.metadata.container.tags.includes(version)) {
//                 return true
//             }
//         }
//         return false
//     } catch (error) {
//         return false
//     }
// }

function getPullRequestNumber(ref) {
  const match = ref.match(/^refs\/pull\/(\d+)\/merge$/);
  return match ? match[1] : null;
}

async function generateMatrix() {
  const basePath = IMAGES_FOLDER;
  const matrix = [];

  const isPullRequest = GITHUB_EVENT_NAME === "pull_request";
  const prNumber = isPullRequest ? getPullRequestNumber(GITHUB_REF) : null;

  var foldersToInclude = [];
  if (INCLUDE_IMAGES) {
    foldersToInclude = INCLUDE_IMAGES.split(",");
  }

  for (const folder of fs.readdirSync(basePath)) {
    if (foldersToInclude.length > 0 && !foldersToInclude.includes(folder)) {
      continue;
    }

    const image_name = folder;
    const folderPath = path.join(basePath, folder);
    const dockerfilePath = path.join(folderPath, "Dockerfile");
    const metadatafilePath = path.join(folderPath, "metadata.yaml");

    if (
      fs.statSync(folderPath).isDirectory() &&
      fs.existsSync(dockerfilePath) &&
      fs.existsSync(metadatafilePath)
    ) {
      try {
        let version = extractVersion(metadatafilePath);
        const platforms = extractPlatforms(metadatafilePath);
        if (isPullRequest) {
          version = `pr-${prNumber}-${version}`;
        }
        console.info(
          `Adding image ${image_name}:${version} to the job matrix.`
        );
        matrix.push({
          job_name: image_name,
          context: folderPath,
          dockerfile: dockerfilePath,
          version: version,
          platforms: platforms,
        });
      } catch (error) {
        console.error(
          `Error processing Dockerfile in ${folderPath}: ${error.message}`
        );
        process.exit(1);
      }
    }
  }
  console.log(`Job matrix: ${JSON.stringify({ include: matrix }, null, 2)}`);

  fs.writeFile(
    "matrix.json",
    JSON.stringify({ include: matrix }, null, 0),
    (err) => {
      if (err) {
        console.log("Failed to write matrix to file.");
        console.error(err);
      } else {
        console.log("Matrix dumped to file successfully.");
      }
    }
  );
}

generateMatrix().catch((error) => {
  console.error("Error generating matrix:", error);
  process.exit(1);
});
