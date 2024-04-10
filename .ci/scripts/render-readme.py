#!/usr/bin/env python3
import os
import json
import requests
import yaml

from jinja2 import Environment, FileSystemLoader, select_autoescape

# read repository name and repository owner's username from custom env vars, else read from GitHub Actions default env vars
repo_owner = os.environ.get('REPO_OWNER', os.environ.get('GITHUB_REPOSITORY_OWNER'))
repo_name = os.environ.get('REPO_NAME', os.environ.get('GITHUB_REPOSITORY')) # uses format "owner/repo"

env = Environment(
    loader=FileSystemLoader(".ci/templates"),
    autoescape=select_autoescape()
)

def load_metadata_file_yaml(file_path):
    with open(file_path, "r") as f:
        return yaml.safe_load(f)

def load_metadata_file_json(file_path):
    with open(file_path, "r") as f:
        return json.load(f)

def load_metadata_file(file_path):
    if file_path.endswith(".json"):
        return load_metadata_file_json(file_path)
    elif file_path.endswith(".yaml"):
        return load_metadata_file_yaml(file_path)
    return None

if __name__ == "__main__":
    base_images = []
    app_images = []
    for subdir, dirs, files in os.walk("./apps"):
        for file in files:
            if file != "metadata.yaml" and file != "metadata.json":
                continue
            meta = load_metadata_file(os.path.join(subdir, file))
            for channel in meta["channels"]:
                name = ""
                if channel.get("stable", False):
                    name = meta["app"]
                else:
                    name = "-".join([meta["app"], channel["name"]])
                image = {
                    "name": name,
                    "channel": channel["name"],
                    "html_url": f"https://github.com/{repo_name}/pkgs/container/{name}",
                    "owner": repo_owner
                }
                if meta["base"]:
                    base_images.append(image)
                else:
                    app_images.append(image)

    template = env.get_template("README.md.j2")
    with open("./README.md", "w") as f:
        f.write(template.render(repo_name=repo_name, base_images=base_images, app_images=app_images))
