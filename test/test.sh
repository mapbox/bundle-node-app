#!/usr/bin/env bash

code="0"
cwd=$(pwd)
app=/tmp/bundle-node-app-testapp
tmp=/tmp/bundle-node-app-test

function assertNo() {
    if [ -e $1 ]; then
        echo "not ok - notfound $1";
        code="1"
    else
        echo "ok - notfound $1"
    fi
}

function assertOk() {
    if [ -e $1 ]; then
        echo "ok - found $1"
    else
        echo "not ok - found $1";
        code="1"
    fi
}

function assertMD5() {
    if [ -e $1 ]; then
        echo "ok - found $1 $(md5sum $1 | grep -oE '[0-f]{32}')"
    else
        echo "not ok - found $1";
        code="1"
    fi
}

function assertExit0() {
    if $1; then
        echo "ok - exit 0 $1";
    else
        echo "not ok - exit 0 $1";
        code="1"
    fi
}

function assertExit1() {
    if $1; then
        echo "not ok - exit 1+ $1";
        code="1"
    else
        echo "ok - exit 1+ $1";
    fi
}

function unpack_bundle() {
    set -e -u
    rm -rf $tmp
    mkdir -p $tmp
    unzip -qq -d $tmp $1
    echo "ok - unpacked $1"
}

cd $(dirname $0)
test=$(pwd)
bundle_node_app=$(dirname $test)/bin/bundle_node_app

# setup
# testapp.tar.gz is a tarball of a git repo (to avoid submodule)
rm -rf $app
mkdir -p $app
tar zxf $test/testapp.tar.gz --directory=$app
cd $app/testapp

# no args, builds current platform @ master
assertExit0 "$bundle_node_app"
assertOk $app/testapp/testapp-linux-x64-master.zip
unpack_bundle $app/testapp/testapp-linux-x64-master.zip
assertOk $tmp/testapp-linux-x64-master
assertOk $tmp/testapp-linux-x64-master/v2.txt
assertOk $tmp/testapp-linux-x64-master/package.json
assertOk $tmp/testapp-linux-x64-master/index.js
assertNo $tmp/testapp-linux-x64-master/exclude.txt
assertOk $tmp/testapp-linux-x64-master/node_modules
assertOk $tmp/testapp-linux-x64-master/node_modules/sqlite3
assertOk $tmp/testapp-linux-x64-master/node_modules/sqlite3/lib/binding/node-v11-linux-x64
assertOk $tmp/testapp-linux-x64-master/node_modules/underscore
rm -f $app/testapp/testapp-linux-x64-master.zip

# builds current platform @ v1.0.0
assertExit0 "$bundle_node_app v1.0.0"
assertOk $app/testapp/testapp-linux-x64-v1.0.0.zip
unpack_bundle $app/testapp/testapp-linux-x64-v1.0.0.zip
assertOk $tmp/testapp-linux-x64-v1.0.0
assertNo $tmp/testapp-linux-x64-v1.0.0/v2.txt
assertOk $tmp/testapp-linux-x64-v1.0.0/package.json
assertOk $tmp/testapp-linux-x64-v1.0.0/index.js
assertNo $tmp/testapp-linux-x64-v1.0.0/exclude.txt
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/sqlite3
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/sqlite3/lib/binding/node-v11-linux-x64
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/underscore
rm -f $app/testapp/testapp-linux-x64-v1.0.0.zip

## target darwin-x64
assertExit0 "$bundle_node_app master darwin-x64"
assertOk $app/testapp/testapp-darwin-x64-master.zip
unpack_bundle $app/testapp/testapp-darwin-x64-master.zip
assertOk $tmp/testapp-darwin-x64-master
assertOk $tmp/testapp-darwin-x64-master/v2.txt
assertOk $tmp/testapp-darwin-x64-master/package.json
assertOk $tmp/testapp-darwin-x64-master/index.js
assertNo $tmp/testapp-darwin-x64-master/exclude.txt
assertOk $tmp/testapp-darwin-x64-master/node_modules
assertOk $tmp/testapp-darwin-x64-master/node_modules/sqlite3
assertOk $tmp/testapp-darwin-x64-master/node_modules/sqlite3/lib/binding/node-v11-darwin-x64
assertOk $tmp/testapp-darwin-x64-master/node_modules/underscore
rm -f $app/testapp/testapp-darwin-x64-master.zip

## universal keyword
assertExit0 "$bundle_node_app master universal"
assertOk $app/testapp/testapp-universal-master.zip
unpack_bundle $app/testapp/testapp-universal-master.zip
assertOk $tmp/testapp-universal-master
assertOk $tmp/testapp-universal-master/v2.txt
assertOk $tmp/testapp-universal-master/package.json
assertOk $tmp/testapp-universal-master/index.js
assertNo $tmp/testapp-universal-master/exclude.txt
assertOk $tmp/testapp-universal-master/node_modules
assertOk $tmp/testapp-universal-master/node_modules/sqlite3
assertOk $tmp/testapp-universal-master/node_modules/sqlite3/lib/binding/node-v11-linux-x64
assertOk $tmp/testapp-universal-master/node_modules/underscore
rm -f $app/testapp/testapp-universal-master.zip

cd $cwd && exit $code

