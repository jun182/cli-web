#!/bin/bash

# --- Configuration ---
# Define your menu options and the corresponding raw GitHub URLs for the scripts.
# Format: "Menu Option Description": "Raw GitHub URL"
declare -A scripts=(
    # Corrected URL below - changed /blob/ to /main/ after awdl_disable/
    ["1. Disable AWDL (Example)"]="https://raw.githubusercontent.com/jun182/awdl_disable/main/bin/awdl_disable.sh"
)
# ---------------------

echo "Welcome to the Script Dispatcher!"
echo "Please choose a script to run:"
echo "------------------------------"

# Display menu options
for option_text in "${!scripts[@]}"; do
    echo "$option_text"
done

echo "------------------------------"

# Read user choice
read -p "Enter your choice: " choice

# Find the script URL based on the choice number
script_url=""
for option_text in "${!scripts[@]}"; do
    # Extract the number from the option text (e.g., "1." from "1. Disable AWDL")
    number=$(echo "$option_text" | cut -d'.' -f1)
    # Use == for string comparison in [[ ... ]]
    if [[ "$number" == "$choice" ]]; then
        script_url="${scripts[$option_text]}"
        break
    fi
done

# Execute the chosen script or show error
if [[ -n "$script_url" ]]; then
    # Extract description without number and leading space
    description=$(echo "$option_text" | cut -d'.' -f2- | sed 's/^ //')
    echo "Downloading and running: $description"
    echo "Fetching script from: $script_url"
    echo "--- Script Output Below ---"

    # Use curl to fetch the script content and pipe it directly to bash for execution
    # -f: Fail silently on HTTP errors
    # -s: Silent mode (don't show progress meter or error messages)
    # -S: Show errors even in silent mode (useful combination with -s)
    # -L: Follow redirects
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