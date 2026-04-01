#!/bin/bash

set -e

MANUAL_URL="https://raw.githubusercontent.com/KARAN-D05/Computing_Machinery_from_Scratch/main/stack-manual/stack-manual.c"
BINARY="./stack-manual"
SOURCE="stack-manual.c"

if [ ! -f "$BINARY" ]; then
    echo "Fetching stack-manual..."
    curl -fsSL "$MANUAL_URL" -o "$SOURCE"

    echo "Compiling..."
    gcc "$SOURCE" -o "$BINARY"

    echo "Done. Launching manual..."
    echo ""
fi

$BINARY "$@"
