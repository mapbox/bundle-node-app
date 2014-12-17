#!/usr/bin/env bash
set -e -u

gitsha=$(cd $(dirname $0)  && git rev-parse HEAD)
main_file="$(dirname $0)/../bin/bundle_node_app"
apps_dest="s3://mapbox/apps/bundle-node-app"
aws s3 cp --acl public-read "$main_file" $apps_dest/$gitsha/run

if git describe --tags --exact-match 2> /dev/null; then
    tag=$(git describe --tags --exact-match)
    aws s3 cp --acl public-read "$main_file" $apps_dest/$tag/run
fi
