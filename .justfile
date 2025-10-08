#!/usr/bin/env -S just --justfile

set quiet := true
set shell := ['bash', '-eu', '-o', 'pipefail', '-c']

bin_dir := justfile_dir() + '/.bin'

[private]
default:
  just --list

[doc('Build and test an app locally')]
[working-directory('.cache')]
local-build app:
    rsync -aqIP {{ justfile_dir() }}/include/ {{ justfile_dir() }}/apps/{{ app }}/ .
    @docker buildx bake --no-cache --metadata-file docker-bake.json --set=*.output=type=docker --load
    TEST_IMAGE="$(jq -r '."image-local"."image.name" | sub("^docker.io/library/"; "")' docker-bake.json)" go test -v {{ justfile_dir() }}/apps/{{ app }}/...

[doc('Trigger a remote build')]
remote-build app release="false":
  gh workflow run release.yaml -f app={{app}} -f release={{release}}
