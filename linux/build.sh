#!/bin/bash

set -euo pipefail

builddir=$1/..
config=$2
ct_ng=$PWD/$3

if [[ $PWD == /Volumes/* ]]; then
    mkdir .tar
    ln -s /usr/bin/bsdtar .tar/tar
    PATH=$PWD/.tar:$PATH
fi

cp $config $builddir/.config
mkdir $builddir/tarballs
(cd $builddir && $ct_ng build.16)
