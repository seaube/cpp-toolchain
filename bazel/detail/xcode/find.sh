#!/bin/sh

if [ -d /Applications/Xcode.app ]; then
    export DEVELOPER_DIR=/Applications/Xcode.app
fi

xcrun -sdk $1 --show-sdk-path
