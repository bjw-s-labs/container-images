#!/usr/bin/env python3
import importlib.util
import sys
import os

import json
import yaml
import requests

from os.path import isfile

TESTABLE_PLATFORMS = ["linux/amd64"]

def load_metadata_file(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def get_published_version(image_name):
    r = requests.get(
        f"https://api.github.com/users/bjw-s/packages/container/{image_name}/versions",
        headers={
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token " + os.environ["TOKEN"]
        },
    )

    if r.status_code != 200:
        return None

    data = json.loads(r.text)
    for image in data:
        tags = image["metadata"]["container"]["tags"]
        if "latest" in tags:
            tags.remove("latest")
            # Assume the longest string is the complete version number
            return max(tags, key=len)

def get_image_metadata(subdir, file, forRelease=False, force=False, channels=None):
    imagesToBuild = {
        "images": [],
        "imagePlatforms": []
    }

    meta = load_metadata_file(os.path.join(subdir, file))

    if not os.path.exists(os.path.join(subdir, "ci")):
        return None
    if not os.path.exists(os.path.join(subdir, "ci", "latest.py")):
        return None

    if channels is None:
        channels = meta["channels"]
    else:
        channels = [channel for channel in meta["channels"] if channel["name"] in channels]

    for channel in channels:
        # Get Latest Upstream Version
        spec = importlib.util.spec_from_file_location("latest", os.path.join(subdir, "ci", "latest.py"))
        latest = importlib.util.module_from_spec(spec)
        sys.modules["latest"] = latest
        spec.loader.exec_module(latest)

        version = latest.get_latest(channel["name"])
        if version is None:
            continue

        # Image Name
        toBuild = {}
        if channel.get("stable", False):
            toBuild["name"] = meta["app"]
        else:
            toBuild["name"] = "-".join([meta["app"], channel["name"]])

        # Skip if latest version already published
        if not force:
            published = get_published_version(meta["app"])
            if published is not None and published == version:
                continue
            toBuild["published_version"] = published

        toBuild["version"] = version

        # Image Tags
        toBuild["tags"] = ["latest", version]
        if meta.get("semantic_versioning", False):
            parts = version.split(".")[:-1]
            while len(parts) > 0:
                toBuild["tags"].append(".".join(parts))
                parts = parts[:-1]

        imagesToBuild["images"].append(toBuild)

        # Platform Metadata
        for platform in channel["platforms"]:
            if platform not in TESTABLE_PLATFORMS and not forRelease:
                continue
            platformToBuild = {}
            platformToBuild["name"] = toBuild["name"]
            platformToBuild["platform"] = platform
            platformToBuild["version"] = version
            if meta.get("base", False):
                platformToBuild["label_type"] ="org.opencontainers.image.base"
            else:
                platformToBuild["label_type"]="org.opencontainers.image"

            if isfile(os.path.join(subdir, channel["name"], "Dockerfile")):
                platformToBuild["dockerfile"] = os.path.join(subdir, channel, "Dockerfile")
                platformToBuild["context"] = os.path.join(subdir, channel)
                platformToBuild["goss_config"] = os.path.join(subdir, channel, "goss.yaml")
            else:
                platformToBuild["dockerfile"] = os.path.join(subdir, "Dockerfile")
                platformToBuild["context"] = subdir
                platformToBuild["goss_config"] = os.path.join(subdir, "ci", "goss.yaml")

            platformToBuild["goss_args"] = "tail -f /dev/null" if channel["tests"].get("type", "web") == "cli" else ""

            platformToBuild["tests_enabled"] = channel["tests"]["enabled"] and platform in TESTABLE_PLATFORMS

            imagesToBuild["imagePlatforms"].append(platformToBuild)
    return imagesToBuild

if __name__ == "__main__":
    apps = sys.argv[1]
    forRelease = sys.argv[2] == "true"
    force = sys.argv[3] == "true"
    imagesToBuild = {
        "images": [],
        "imagePlatforms": []
    }

    if apps != "all":
        channels=None
        apps = apps.split(",")
        if len(sys.argv) == 5:
            channels = sys.argv[4].split(",")

        for app in apps:
            if not os.path.exists(os.path.join("./apps", app)):
                print(f"App \"{app}\" not found")
                exit(1)
            imageToBuild = get_image_metadata(os.path.join("./apps", app), "metadata.yaml", forRelease, force=force, channels=channels)
            if imageToBuild is not None:
                imagesToBuild["images"].extend(imageToBuild["images"])
                imagesToBuild["imagePlatforms"].extend(imageToBuild["imagePlatforms"])
    else:
        for subdir, dirs, files in os.walk("./apps"):
            for file in files:
                if file == "metadata.yaml":
                    imageToBuild = get_image_metadata(subdir, file, forRelease, force=force)
                    if imageToBuild is not None:
                        imagesToBuild["images"].extend(imageToBuild["images"])
                        imagesToBuild["imagePlatforms"].extend(imageToBuild["imagePlatforms"])
    print(json.dumps(imagesToBuild))
