#!/bin/bash
echo "Checking Tailscale status..."
tailscale status

TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)

if [[ -n "$TAILSCALE_IP" ]]; then
    echo "=========================================="
    echo "✅ TAILSCALE CONNECTED"
    echo "SSH Connection Command:"
    echo "ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)@$TAILSCALE_IP"
    echo ""
    echo "Tailscale IP: $TAILSCALE_IP"
    echo "Username: $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)"
    echo "Password: $(jq -r '.inputs.password' $GITHUB_EVENT_PATH)"
    echo "=========================================="
    
    echo "SSH Service Status:"
    sudo systemctl is-active ssh
else
    echo "=========================================="
    echo "❌ TAILSCALE DISCONNECTED"
    echo "Possible issues:"
    echo "1. Invalid auth key"
    echo "2. Auth key expired" 
    echo "3. Network issues"
    echo "4. Tailscale service not running"
    echo ""
    echo "Checking Tailscale service..."
    sudo systemctl status tailscaled --no-pager
    echo ""
    echo "Please check your Tailscale auth key and try again"
    echo "=========================================="
    exit 4
fi
