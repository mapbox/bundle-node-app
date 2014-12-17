#!/usr/bin/env bash

code="0"
cwd=$(pwd)
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

cd $test/testapp

# no args, builds current platform @ master
assertExit0 "$bundle_node_app"
assertOk $test/testapp/testapp-linux-x64-master.zip
unpack_bundle $test/testapp/testapp-linux-x64-master.zip
assertOk $tmp/testapp-linux-x64-master
assertOk $tmp/testapp-linux-x64-master/v2.txt
assertOk $tmp/testapp-linux-x64-master/package.json
assertOk $tmp/testapp-linux-x64-master/index.js
assertNo $tmp/testapp-linux-x64-master/exclude.txt
assertOk $tmp/testapp-linux-x64-master/node_modules
assertOk $tmp/testapp-linux-x64-master/node_modules/sqlite3
assertOk $tmp/testapp-linux-x64-master/node_modules/sqlite3/lib/binding/node-v11-linux-x64
assertOk $tmp/testapp-linux-x64-master/node_modules/underscore
rm -f $test/testapp/testapp-linux-x64-master.zip

# builds current platform @ v1.0.0
assertExit0 "$bundle_node_app v1.0.0"
assertOk $test/testapp/testapp-linux-x64-v1.0.0.zip
unpack_bundle $test/testapp/testapp-linux-x64-v1.0.0.zip
assertOk $tmp/testapp-linux-x64-v1.0.0
assertNo $tmp/testapp-linux-x64-v1.0.0/v2.txt
assertOk $tmp/testapp-linux-x64-v1.0.0/package.json
assertOk $tmp/testapp-linux-x64-v1.0.0/index.js
assertNo $tmp/testapp-linux-x64-v1.0.0/exclude.txt
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/sqlite3
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/sqlite3/lib/binding/node-v11-linux-x64
assertOk $tmp/testapp-linux-x64-v1.0.0/node_modules/underscore
rm -f $test/testapp/testapp-linux-x64-v1.0.0.zip

## target darwin-x64
assertExit0 "$bundle_node_app master darwin-x64"
assertOk $test/testapp/testapp-darwin-x64-master.zip
unpack_bundle $test/testapp/testapp-darwin-x64-master.zip
assertOk $tmp/testapp-darwin-x64-master
assertOk $tmp/testapp-darwin-x64-master/v2.txt
assertOk $tmp/testapp-darwin-x64-master/package.json
assertOk $tmp/testapp-darwin-x64-master/index.js
assertNo $tmp/testapp-darwin-x64-master/exclude.txt
assertOk $tmp/testapp-darwin-x64-master/node_modules
assertOk $tmp/testapp-darwin-x64-master/node_modules/sqlite3
assertOk $tmp/testapp-darwin-x64-master/node_modules/sqlite3/lib/binding/node-v11-darwin-x64
assertOk $tmp/testapp-darwin-x64-master/node_modules/underscore
rm -f $test/testapp/testapp-darwin-x64-master.zip

cd $cwd && exit $code

