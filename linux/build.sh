#!/bin/bash

set -euo pipefail

builddir=$1/..
config=$2
ct_ng=$PWD/$3

cp $config $builddir/.config
mkdir $builddir/tarballs
(cd $builddir && $ct_ng build.16)
