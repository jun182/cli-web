#!/bin/bash

# --- Configuration ---
# Define your menu options and the corresponding raw GitHub URLs for the scripts.
# Format: "Menu Option Description": "Raw GitHub URL"
declare -A scripts=(
    ["1. Disable AWDL (Example)"]="https://raw.githubusercontent.com/jun182/awdl_disable/blob/main/bin/awdl_disable.sh"
    ["2. Run Another Script (Replace)"]="https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_OTHER_REPO/main/another_script.sh" # <- Replace with your info
# Add more options here following the same pattern
# ["3. Install Docker"]="https://get.docker.com" # <- You could even link to other installers if they support this pattern
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
    if [[ "$number" == "$choice" ]]; then
        script_url="${scripts[$option_text]}"
        break
    fi
done

# Execute the chosen script or show error
if [[ -n "$script_url" ]]; then
    echo "Downloading and running: $(echo "$option_text" | cut -d'.' -f2- | sed 's/^ //')" # Print description without number
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