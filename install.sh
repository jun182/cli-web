#!/bin/bash

# --- Configuration ---
# Define your menu options and the corresponding raw GitHub URLs for the scripts.
menu_options=("1. Disable AWDL (Example)")
script_urls=("https://raw.githubusercontent.com/jun182/awdl_disable/main/bin/awdl_disable.sh")
# ---------------------

echo "Welcome to the Script Dispatcher!"
echo "Please choose a script to run:"
echo "------------------------------"

# Display menu options
for i in "${!menu_options[@]}"; do
    echo "${menu_options[$i]}"
done

echo "------------------------------"

# Read user choice from the terminal
read -p "Enter your choice: " choice < /dev/tty

# Find the script URL based on the choice number
script_url=""
description=""
for i in "${!menu_options[@]}"; do
    # Extract the number from the option text (e.g., "1." from "1. Disable AWDL")
    number=$(echo "${menu_options[$i]}" | cut -d'.' -f1)
    if [[ "$number" == "$choice" ]]; then
        script_url="${script_urls[$i]}"
        # Extract description without number and leading space
        description=$(echo "${menu_options[$i]}" | cut -d'.' -f2- | sed 's/^ //')
        break
    fi
done

# Execute the chosen script or show error
if [[ -n "$script_url" ]]; then
    echo "Downloading and running: $description"
    echo "Fetching script from: $script_url"
    echo "--- Script Output Below ---"

    # Use curl to fetch the script content and pipe it directly to bash for execution
    if curl -fsSL "$script_url" | bash; then
        echo "--- Script Execution Finished Successfully ---"
        exit 0
    else
        echo "--- Script Execution Failed! ---"
        exit 1
    fi
else
    echo "Invalid choice: $choice"
    exit 1
fi