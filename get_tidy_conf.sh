#!/bin/bash
# Copy the tidy.conf file from an ebookmaker version into the dist directory
# Note that ebookmaker versions are normally tagged not released
# The tidy.conf file is not expected to change often

set -e

VERSION=0.11.26

rm -rf ebookmaker.zip ebmtemp
curl -L -o ebookmaker.zip https://github.com/gutenbergtools/ebookmaker/archive/refs/tags/$VERSION.zip
unzip -q ebookmaker.zip -d ebmtemp
cp ebmtemp/ebookmaker-$VERSION/ebookmaker/parsers/tidy.conf dist
rm -rf ebookmaker.zip ebmtemp
