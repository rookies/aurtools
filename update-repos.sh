#!/bin/bash
cd `dirname $0`
echo "Cleaning up 'any' packages..."
./rm-old.sh packages
echo "Removing 'i686' repo..."
rm -f packages/i686/local.db
rm -f packages/i686/local.db.tar.gz
echo "Cleaning up 'i686' packages..."
./rm-old.sh packages/i686
echo "Recreating 'i686' repo..."
repo-add packages/i686/local.db.tar.gz packages/*.pkg.tar.xz
repo-add packages/i686/local.db.tar.gz packages/i686/*.pkg.tar.xz
echo "Removing 'x86_64' repo..."
rm -f packages/x86_64/local.db
rm -f packages/x86_64/local.db.tar.gz
echo "Cleaning up 'x86_64' packages..."
./rm-old.sh packages/x86_64
echo "Recreating 'x86_64' repo..."
repo-add packages/x86_64/local.db.tar.gz packages/*.pkg.tar.xz
repo-add packages/x86_64/local.db.tar.gz packages/x86_64/*.pkg.tar.xz
