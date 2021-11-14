#!/bin/bash
# Copy the tidy.conf file from an ebookmaker version into the dist directory
# Note that ebookmaker versions are normally tagged not released
# The tidy.conf file is not expected to change often

set -e

VERSION=$(grep ebookmaker Pipfile | tr -d '"' | sed 's/.*==//')

curl -L -o dist/tidy.conf https://github.com/gutenbergtools/ebookmaker/raw/$VERSION/ebookmaker/parsers/tidy.conf
