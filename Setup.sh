#!/bin/bash
sudo useradd -m $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)
sudo adduser $(jq -r '.inputs.username' $GITHUB_EVENT_PATH) sudo
echo $(jq -r '.inputs.username' $GITHUB_EVENT_PATH):$(jq -r '.inputs.password' $GITHUB_EVENT_PATH) | sudo chpasswd
sudo sed -i 's/\/bin\/sh/\/bin\/bash/g' /etc/passwd
sudo hostname $(jq -r '.inputs.computername' $GITHUB_EVENT_PATH)

# Install dan setup SSH server
sudo apt-get install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Konfigurasi SSH untuk menerima koneksi
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config

# Izinkan user untuk SSH
sudo usermod -aG ssh $(jq -r '.inputs.username' $GITHUB_EVENT_PATH)

# Restart SSH service
sudo systemctl restart ssh

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Setup Tailscale
echo -e "$(jq -r '.inputs.password' $GITHUB_EVENT_PATH)\n$(jq -r '.inputs.password' $GITHUB_EVENT_PATH)" | sudo passwd "$USER"

# Authenticate Tailscale dengan opsi --ssh
sudo tailscale up --authkey $(jq -r '.inputs.tailscale_authkey' $GITHUB_EVENT_PATH) --hostname $(jq -r '.inputs.computername' $GITHUB_EVENT_PATH) --ssh

# Tunggu dan cek status
sleep 10
echo "=== Tailscale Status ==="
tailscale status --json
echo "=== SSH Service Status ==="
sudo systemctl status ssh --no-pager
echo "=== Network Status ==="
sudo netstat -tlnp | grep :22
