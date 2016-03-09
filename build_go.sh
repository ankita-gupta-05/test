#!/bin/bash

# Build GOLANG from source for Fedora on PPC64[LE]. Run as root. Argument is
# tag to build

tag=$1

# Install gcc-go, which is GO 1.4. This is for bootstrapping only.

dnf install -y gcc-go

# Get/update source code, check out the latest tag, and build

cd /usr/src
if [ -d go ]; then
    cd go
    git checkout master
    git pull
else
    git clone https://go.googlesource.com/go
    cd go
fi
git checkout tags/go$tag

cd src
export GOROOT_BOOTSTRAP=$(go env GOROOT)
./make.bash

# Remove gcc-go

dnf erase -y gcc-go

# Fix permissions and create links in /usr/bin

cd ../
chmod o+rx $(find . -type d)
chmod o+r $(find . -type f)
chmod o+x bin/* pkg/tool/linux_ppc64le/*

ln -sf /usr/src/go/bin/go /usr/bin/go
ln -sf /usr/src/go/bin/gofmt /usr/bin/gofmt



