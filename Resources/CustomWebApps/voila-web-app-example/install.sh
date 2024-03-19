#!/bin/bash

# Get the directory of the script
script_dir=$(dirname "$(realpath "$0")")
script_dir_name=$(basename "$script_dir")
impact_customizations_dir="$IMPACT_BASEDIR/customizations"

# Define paths
source_dir="$script_dir"
target_dir="$impact_customizations_dir/$script_dir_name"

# Copy /dist into customizations/$current_dir_name
rm -rf "$target_dir"
cp -rf "$script_dir" "$target_dir"

echo "Deployed $source_dir to $target_dir"
