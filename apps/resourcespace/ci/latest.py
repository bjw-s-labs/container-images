#!/usr/bin/env python

import svn.remote

# Get the latest version of resourcespace

repoURL = "https://svn.resourcespace.com/svn/rs/releases"

def get_latest(channel):
    releases = []
    r = svn.remote.RemoteClient(repoURL)
    releasesRemote = r.list(extended=True)

    for entry in releasesRemote:
        if entry["kind"] == "dir":
            releases.append(float(entry["name"]))

    return str(sorted(releases)[-1])

if __name__ == "__main__":
    import sys
    channel = sys.argv[1]
    print(get_latest(channel))
