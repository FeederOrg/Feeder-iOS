#!/bin/sh

#  ci_post_xcodebuild.sh
#  Feeder-iOS
#
#  Created by Joe Diragi on 9/10/22.
#
test_logs=$CI_DERIVED_DATA_PATH/Logs/Test
echo $(ls test_logs)

echo "=============START================"
for f in "$test_logs"/*
do
    echo $(basename $f)
    echo "-------------------------"
    echo $(cat $f)
done
echo "==============END==============="
