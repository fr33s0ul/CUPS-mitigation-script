#!/bin/bash

# Function to apply mitigations
apply_mitigation() {
    echo "Applying CUPS vulnerability mitigations..."

    # 1. Disable and stop cups-browsed service
    if systemctl is-active --quiet cups-browsed; then
        sudo systemctl stop cups-browsed
        sudo systemctl disable cups-browsed
        echo "Disabled cups-browsed service."
    else
        echo "cups-browsed service is already disabled."
    fi

    # 2. Block UDP port 631 using UFW
    sudo ufw deny 631
    echo "Blocked UDP port 631."

    # 3. Restrict CUPS to listen only on localhost
    cups_conf="/etc/cups/cupsd.conf"
    if grep -q "Listen localhost:631" "$cups_conf"; then
        echo "CUPS already restricted to localhost."
    else
        sudo sed -i '/^Listen /d' "$cups_conf"  # Remove any existing Listen directives
        echo "Listen localhost:631" | sudo tee -a "$cups_conf"
        sudo systemctl restart cups
        echo "Restricted CUPS to listen on localhost."
    fi

    echo "Mitigations applied successfully."
}

# Function to revert the mitigations
revert_mitigation() {
    echo "Reverting CUPS vulnerability mitigations..."

    # 1. Enable and start cups-browsed service
    sudo systemctl enable cups-browsed
    sudo systemctl start cups-browsed
    echo "Re-enabled cups-browsed service."

    # 2. Unblock UDP port 631 using UFW
    sudo ufw delete deny 631
    echo "Unblocked UDP port 631."

    # 3. Remove restriction of CUPS to localhost
    cups_conf="/etc/cups/cupsd.conf"
    sudo sed -i '/Listen localhost:631/d' "$cups_conf"
    sudo systemctl restart cups
    echo "Removed localhost restriction on CUPS."

    echo "Mitigations reverted successfully."
}

# Check the script argument
if [ "$1" == "apply" ]; then
    apply_mitigation
elif [ "$1" == "revert" ]; then
    revert_mitigation
else
    echo "Usage: $0 {apply|revert}"
    exit 1
fi
