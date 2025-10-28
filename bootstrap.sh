#!/usr/bin/env bash

if [ "$EUID" -eq 0 ]; then
	echo -n "You probably don't want to run this as sudo/root. Continue anyway? (y/N): "
	read -r ans
	if [[ "$ans" != Y* && "$ans" != y* ]]; then
		exit 1
	fi
fi

user=$(logname)
vm=false

sudo --validate

# Bootstrap configuration

echo -n "Is this a VM? (y/N): "
read -r ans

if [[ "$ans" == Y* || "$ans" == y* ]]; then
	vm=true
fi
echo "VM: $vm"

# Distro detection and package installation

if grep -E ^ID=arch /etc/os-release; then
	source distros/arch/arch.sh
else
	echo -n "Could not detect a compatible distro. Try to continue without installing packages? (y/N): "
	read -r ans
	if [[ "$ans" != Y* && "$ans" != y* ]]; then
		exit 1
	fi
fi

# i3 config
mkdir -p /home/"$user"/.config/i3
cp ./conf_files/i3.conf /home/"$user"/.config/i3/config

# i3status config
sudo cp ./conf_files/i3status.conf /etc/i3status.conf
# Set interface name in i3status conf (assume first UP interface is correct - fallback to _first_)
iface=$(ip link | cut -f 2- -d ' ' | grep -E "^e" | grep -m 1 "state UP" | cut -f 1 -d ':')
if [[ ! -z "$iface" ]]; then
	sudo sed -i "s/ethernet _first_ {/ethernet $iface {/" /etc/i3status.conf
	sudo sed -i "s/ethernet _first_\"/ethernet $iface\"/" /etc/i3status.conf
fi

# vim config
mkdir -p /home/"$user"/.vim/colors
cp ./conf_files/afterglow.vim /home/"$user"/.vim/colors/
cp ./conf_files/vimrc /home/"$user"/.vimrc

# rofi config
mkdir -p /home/"$user"/.config/rofi
cp ./conf_files/rofi.config /home/"$user"/.config/rofi/config

# stterm
mkdir -p /home/"$user"/git
git -C /home/"$user"/git/ clone https://github.com/Lars-Saetaberget/stterm.git
make -C /home/"$user"/git/stterm/ clean
sudo -E make -C /home/"$user"/git/stterm/ install

# scripts
sudo cp ./scripts/* /usr/local/bin/

# iptables + no-internet script
sudo modprobe ip_tables
sudo systemctl enable iptables
sudo systemctl start iptables
if sudo iptables -S; then
	# Block incoming except icmp and localhost
	sudo iptables -C INPUT -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED 2> /dev/null || sudo iptables -A INPUT -j ACCEPT -m conntrack --ctstate ESTABLISHED,RELATED
	sudo iptables -C INPUT -j ACCEPT --src localhost 2> /dev/null || sudo iptables -A INPUT -j ACCEPT --src localhost
	sudo iptables -C INPUT -j ACCEPT --proto icmp 2> /dev/null || sudo iptables -A INPUT -j ACCEPT --proto icmp
	sudo iptables -P INPUT DROP

	# Deny all traffic for no-internet group
	sudo groupadd no-internet
	sudo usermod -aG no-internet "$user"
	sudo iptables -C OUTPUT -m owner --gid-owner no-internet -j DROP 2> /dev/null || sudo iptables -I OUTPUT 1 -m owner --gid-owner no-internet -j DROP
	sudo cp ./scripts/no-internet.sh /usr/local/bin/

	# Persist iptables rules
	sudo iptables-save -f /etc/iptables/iptables.rules
else
	echo "iptables might not be loaded, you need to reboot before iptables rules can be applied"
fi

# bashrc
cp ./conf_files/bashrc /home/"$user"/.bashrc
cp ./conf_files/bash_codes /home/"$user"/.bash_codes
cp ./conf_files/bash_ps1 /home/"$user"/.bash_ps1
cp ./conf_files/bash_alias /home/"$user"/.bash_alias

# git
cp ./conf_files/git.conf /home/"$user"/.gitconfig
cp ./conf_files/gitignore_global.conf /home/"$user"/.gitignore_global

# ssh
mkdir -p /home/"$user"/.ssh
cp ./conf_files/ssh.conf /home/"$user"/.ssh/config

# sysctl
sudo sysctl -w vm.swappiness=1

# Xresources
cp ./conf_files/xresources.conf /home/"$user"/.Xresources

# xinitrc
cp ./conf_files/xinitrc /home/"$user"/.xinitrc

# Spotify
sudo cp ./scripts/spotify /usr/local/bin
mkdir -p /home/"$user"/.config/ncspot
cp ./conf_files/ncspot.conf /home/"$user"/.config/ncspot/config.toml

# Polybar
mkdir -p /home/"$user"/.config/polybar
cp ./conf_files/polybar.conf /home/"$user"/.config/polybar/polybar.conf

# VPN script nopasswd
sudo cp ./conf_files/99_wheel /etc/sudoers.d/

# Timezone
sudo timedatectl set-timezone Europe/Oslo
