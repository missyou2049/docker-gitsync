#!/bin/bash

pushd /data >/dev/null

ls | while read dir; do
    pushd $dir >/dev/null

    ls | while read d; do
        /scripts/gitsync.sh sync $d
    done

    popd >/dev/null
done

popd >/dev/null
