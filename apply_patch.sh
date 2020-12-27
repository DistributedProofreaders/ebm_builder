#!/bin/bash

set -x

EBM_DIR=$(python -c 'import ebookmaker; import os.path; print(os.path.dirname(ebookmaker.__file__))')

PATCH_FILE=$(pwd)/ebookmaker-pyinstaller.patch

cd "$EBM_DIR"
patch -p1 < "$PATCH_FILE"
