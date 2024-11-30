#!/bin/bash

# List of required tools and libraries
REQUIRED_TOOLS=("gcc" "make" "automake" "autoconf" "flex" "bison" "perl" "pkg-config")
REQUIRED_LIBS=("libicu-dev" "libreadline-dev")
MISSING_TOOLS=()
MISSING_LIBS=()

# Check for tools
for tool in "${REQUIRED_TOOLS[@]}"; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        MISSING_TOOLS+=("$tool")
    fi
done

# Check for libraries
for lib in "${REQUIRED_LIBS[@]}"; do
    if ! dpkg -s "$lib" >/dev/null 2>&1; then
        MISSING_LIBS+=("$lib")
    fi
done

# Report missing dependencies
if [ ${#MISSING_TOOLS[@]} -eq 0 ] && [ ${#MISSING_LIBS[@]} -eq 0 ]; then
    echo "All required tools and libraries are already installed."
    exit 0
fi

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo "The following tools are missing:"
    for tool in "${MISSING_TOOLS[@]}"; do
        echo "  - $tool"
    done
fi

if [ ${#MISSING_LIBS[@]} -gt 0 ]; then
    echo "The following libraries are missing:"
    for lib in "${MISSING_LIBS[@]}"; do
        echo "  - $lib"
    done
fi

# Ask for user confirmation before installing
echo ""
read -p "Do you want to install the missing tools and libraries? (Y/n): " confirm
confirm=${confirm:-Y}

if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Installation aborted."
    exit 1
fi

# Install missing dependencies
echo "Installing missing tools and libraries..."
sudo apt-get update
if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    sudo apt-get install -y "${MISSING_TOOLS[@]}"
fi
if [ ${#MISSING_LIBS[@]} -gt 0 ]; then
    sudo apt-get install -y "${MISSING_LIBS[@]}"
fi

echo "All tools and libraries have been installed successfully!"
