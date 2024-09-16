#!/bin/bash

set -euo pipefail

builddir=$(mktemp -d)
target=$1
config=$2
ct_ng=$PWD/$3

#cp $config $builddir/.config
#mkdir $builddir/tarballs
#(cd $builddir && $ct_ng build.1)
#mv $builddir $target

mkdir $target
cp $config $target/.config
mkdir $target/tarballs
(cd $target && $ct_ng build.16)
