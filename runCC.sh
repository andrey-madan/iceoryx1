#!/bin/bash

cmake -Bbuild -Hiceoryx_meta -DCPPTEST_COVERAGE=ON -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DBUILD_TEST=ON -DCMAKE_PREFIX_PATH=$(pwd)/build/dependencies/

#run unit tests and generate coverage report
./build/hoofs/test/hoofs_moduletests --gtest_filter="*vector_test*" --gtest_output=xml:build/gtest_results.xml

cd build
cpptestct coverage compute -map cpptest-coverage/iceoryx_meta/.cpptest -clog cpptest-coverage/iceoryx_meta/iceoryx_meta.clog -out .coverage
cpptestcov report html .coverage -code -out .coverage/coverage.html

#overriding those properties to publish to the VM
#dtp.url=https://34.219.86.86:8443
#dtp.user=demo
#dtp.password=d3mo-user
cpptestcov report dtp -property dtp.url=https://34.219.86.86:8443 -property dtp.user=demo -property dtp.password=d3mo-user -property build.id=baseline -property dtp.project=iceoryx .coverage gtest_results.xml
