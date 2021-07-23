#!/bin/sh
set -e
# Set the install command to be used by mk-build-deps (use --yes for non-interactive)
install_tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes"
# Install build dependencies automatically
mk-build-deps --install --tool="${install_tool}" debian/control
# Build the package
dpkg-buildpackage $@
# Output the filename
cd ..

filename=`ls ./*.deb | grep -v -- -dbgsym`
echo "::set-output name=filename::$filename"
mv "$filename" workspace/

if dbgsym=`ls ./*.deb | grep -- -dbgsym`; then
    echo "::set-output name=filename-dbgsym::$dbgsym"
    mv "$dbgsym" workspace/
fi
