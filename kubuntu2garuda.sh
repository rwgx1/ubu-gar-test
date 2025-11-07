#!/bin/bash
# kubuntu-garudaize.sh
# Make Kubuntu behave like Garuda Linux: btrfs, zram, snapper, grub-btrfs, aggressive swap

set -e

echo ">>> Updating system..."
sudo apt update && sudo apt -y upgrade

echo ">>> Installing packages..."
sudo apt install -y \
  snapper \
  grub-btrfs \
  inotify-tools \
  snapper-apt-daily \
  zram-tools \
  preload \
  earlyoom \
  linux-lowlatency

# --- ZRAM setup ---
echo ">>> Configuring zram..."
sudo tee /etc/default/zramswap >/dev/null <<'EOF'
PERCENT=100
PRIORITY=100
ALGO=zstd
EOF

sudo systemctl enable --now zramswap

# --- Swappiness tuning ---
echo ">>> Setting swappiness/aggressive swap..."
sudo tee /etc/sysctl.d/99-swappiness.conf >/dev/null <<'EOF'
vm.swappiness=180
vm.vfs_cache_pressure=100
EOF
sudo sysctl --system

# --- Snapper setup ---
echo ">>> Setting up snapper for root filesystem..."
if ! sudo snapper list-configs | grep -q root; then
  sudo snapper -c root create-config /
fi

# Ensure /.snapshots exists
if [ ! -d /.snapshots ]; then
  sudo mkdir /.snapshots
  sudo chmod 750 /.snapshots
fi

# Add to fstab if missing
if ! grep -q "subvol=@snapshots" /etc/fstab; then
  BTRFS_UUID=$(findmnt -no UUID /)
  echo "UUID=${BTRFS_UUID} /.snapshots btrfs subvol=@snapshots,compress=zstd:3,noatime,space_cache=v2,ssd,discard=async 0 2" | sudo tee -a /etc/fstab
fi

# --- Enable grub-btrfs service ---
echo ">>> Enabling grub-btrfs integration..."
sudo systemctl enable --now grub-btrfs.path

# --- Earlyoom & preload ---
echo ">>> Enabling earlyoom & preload..."
sudo systemctl enable --now earlyoom
sudo systemctl enable --now preload

echo ">>> Done!"
echo "Reboot to apply kernel + zram + grub snapshot integration."

