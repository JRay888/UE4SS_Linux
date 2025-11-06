#!/bin/bash

# UE4SS Linux Build Script
# This script builds UE4SS for Linux

set -e  # Exit on error

echo "=== UE4SS Linux Build Script ==="
echo

# Check for required tools
command -v cmake >/dev/null 2>&1 || { echo "ERROR: cmake is required but not installed. Aborting." >&2; exit 1; }
command -v g++ >/dev/null 2>&1 || { echo "ERROR: g++ is required but not installed. Aborting." >&2; exit 1; }
command -v rustc >/dev/null 2>&1 || { echo "ERROR: rustc is required but not installed. Aborting." >&2; exit 1; }

# Parse arguments
BUILD_MODE=${1:-Release}
BUILD_CONFIG="Game__${BUILD_MODE}__Linux"

echo "Build Configuration: ${BUILD_CONFIG}"
echo

# Create build directory
BUILD_DIR="build_linux"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Run CMake configuration
echo "Running CMake configuration..."
cmake .. \
    -DCMAKE_BUILD_TYPE="${BUILD_CONFIG}" \
    -DCMAKE_CXX_COMPILER=g++ \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_STANDARD=23 \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON

echo
echo "Building UE4SS..."
cmake --build . --config "${BUILD_CONFIG}" --parallel $(nproc)

echo
echo "=== Build Complete ==="
echo "Output directory: ${BUILD_DIR}/Output/${BUILD_CONFIG}/UE4SS/bin"
echo
echo "To install:"
echo "1. Copy libUE4SS.so to your Palworld server directory"
echo "2. Set LD_PRELOAD=./libUE4SS.so when launching the server"
echo
