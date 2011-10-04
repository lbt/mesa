#!/bin/sh

DIRNAME=mesa
PACKAGENAME=${DIRNAME}-7.11

echo REF ${REF:+--reference $REF}
echo DIRNAME $DIRNAME
echo HEAD ${1:-HEAD}

if [ -d $DIRNAME ]
then
    pushd $DIRNAME
    git checkout master
    git pull
    popd
else
    git clone ${REF:+--reference $REF} \
	git://proxy01.pd.intel.com:9419/git/mesa/mesa $DIRNAME
fi

pushd $DIRNAME
commitid=$(expr match $(git describe) '.*-\([0-9]*-g[a-z0-9]*\)$' | tr - .)
popd

GIT_DIR=$DIRNAME/.git git archive --format=tar --prefix=$PACKAGENAME~git$commitid/ ${1:-HEAD} \
	| bzip2 > $PACKAGENAME~git$commitid.tar.bz2

# rm -rf $DIRNAME
