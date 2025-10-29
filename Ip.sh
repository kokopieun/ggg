#!/bin/bash
TAILSCALE_IP=$(tailscale ip -4)

if [[ -n "$TAILSCALE_IP" ]]; then
    echo "=========================================="
    echo "✅ TAILSCALE CONNECTED SUCCESSFULLY"
    echo ""
    echo "📡 SSH CONNECTION COMMAND:"
    echo "ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)@$TAILSCALE_IP"
    echo ""
    echo "🔐 LOGIN DETAILS:"
    echo "IP Address: $TAILSCALE_IP"
    echo "Username: $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)"
    echo "Password: $(jq -r '.inputs.password' $GITHUB_EVENT_PATH)"
    echo ""
    echo "⚡ QUICK TEST:"
    echo "Run this on your local machine:"
    echo "ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)@$TAILSCALE_IP"
    echo "=========================================="
else
    echo "❌ Error: Tailscale not connected or no IP address assigned"
    exit 4
fi
