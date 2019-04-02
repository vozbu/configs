#!/bin/bash

cd

virtualenv conan
source conan/bin/activate
cd programming/target/external/conan
./make_deps.sh default ~/programming/target-deps
find ~/programming/target-deps-default/ -name *.a -exec strip -g '{}' \;
deactivate
