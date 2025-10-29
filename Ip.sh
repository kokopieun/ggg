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
    
    # Cek status SSH service (tanpa testing koneksi)
    echo "SSH Service Status:"
    sudo systemctl is-active ssh
    echo ""
    echo "Listening ports:"
    sudo netstat -tlnp | grep :22 || echo "Port 22 not listening"
else
    echo "Error: Tailscale not connected or no IP address assigned"
    echo "Checking Tailscale status..."
    tailscale status
    exit 4
fi
