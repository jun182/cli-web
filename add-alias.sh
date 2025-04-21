#!/bin/bash

# Define the alias name and the command
ALIAS_NAME="johola-config"
SCRIPT_URL="https://raw.githubusercontent.com/jun182/cli-web/main/install.sh"

# Determine the shell configuration file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "Unsupported shell. Please add the alias manually."
    exit 1
fi

# Add the alias to the shell configuration file
echo "alias $ALIAS_NAME='curl -s $SCRIPT_URL | bash'" >> "$SHELL_RC"
echo "Alias '$ALIAS_NAME' added to $SHELL_RC. Restart your terminal or run 'source $SHELL_RC' to apply."