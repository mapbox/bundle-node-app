bundle-node-app
---------------

A bash script to bundle a node.js app for a platform of your choosing
so it can be installed and run without npm/node being present.

## Requirements

- Your app must be a git repo.
- Your app must have a package.json `preinstall` installing a vendor node binary (e.g. use [install-node](https://github.com/mapbox/install-node)).
- Your app must have a start script that runs your app using your vendor node binary.

## Usage

```
$ bundle_node_app <gitsha> <platform+arch> [node_version]
```

The command should be run from the root of your project's git repo. Example:

```
cd my-project
bundle_node_app master darwin-x64 0.10.26
```

## Run from S3

Alternately you can pull the script from S3 with `curl` and run it, specifying
parameters as environment variables:

```
cd my-project
curl https://s3.amazonaws.com/mapbox/apps/bundle-node-app/v0.0.0/run | GS=master NP=linux-x64 NV=0.10.26 sh
```

