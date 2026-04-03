#!/bin/bash

# Check if Tailscale is running
if tailscale status &>/dev/null; then
    # Tailscale is up, get the Tailscale IP
    ip=$(tailscale ip -4)
    echo "Tailscale Up - $ip"
else
    echo "Tailscale Down"
fi
