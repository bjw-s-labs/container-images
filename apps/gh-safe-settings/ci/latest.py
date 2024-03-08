#!/usr/bin/env python

import requests
import json
import semver

# Get the latest version of radicale

URL = "https://api.github.com/repos/github/safe-settings/releases"

def get_latest(channel):
    r = requests.get(URL)
    data = json.loads(r.text)

    latest_version = ""

    if channel == "stable":
        versions = [ semver.Version.parse(release['tag_name']) for release in data ]
        stable_versions = [ version for version in versions if not version.prerelease]
        latest_version = max(stable_versions)
    else:
        versions = [ semver.Version.parse(release['tag_name']) for release in data ]
        latest_version = max(versions)

    return str(latest_version).removeprefix("v")

if __name__ == "__main__":
    import sys
    channel = sys.argv[1]
    print(get_latest(channel))
