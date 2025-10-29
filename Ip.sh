#!/bin/bash
TAILSCALE_IP=$(tailscale ip -4)

if [[ -n "$TAILSCALE_IP" ]]; then
    echo "=========================================="
    echo "SSH Connection Command:"
    echo "ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)@$TAILSCALE_IP"
    echo ""
    echo "Tailscale IP: $TAILSCALE_IP"
    echo "Username: $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)"
    echo "Password: $(jq -r '.inputs.password' $GITHUB_EVENT_PATH)"
    echo "=========================================="
    
    # Test koneksi SSH
    echo "Testing SSH connection..."
    sudo netstat -tlnp | grep ssh
else
    echo "Error: Tailscale not connected or no IP address assigned"
    echo "Checking Tailscale status..."
    tailscale status
    exit 4
fi
