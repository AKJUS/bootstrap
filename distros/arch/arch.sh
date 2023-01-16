# Norwegian mirrors
sudo cp distros/arch/mirrorlist /etc/pacman.d/mirrorlist

# Upgrade system
sudo pacman -Syu --noconfirm

# Install packages
cat packages/arch.txt | while read package; do
	sudo pacman -S --noconfirm "$package"
done

# Install packages for non-VM machines
if ! $vm; then
        cat packages/arch_not_vm.txt | while read package; do
	        sudo pacman -S --noconfirm "$package"
        done
fi

# Fetch AUR packages (but don't build or install them)
mkdir -p /home/"$user"/git/AUR
cat ./packages/arch_aur.txt | while read -r package; do
        git -C  /home/"$user"/git/AUR/ clone "$package"
done

# Turn on stuff
sudo systemctl enable cronie
sudo systemctl start cronie
sudo systemctl enable dhcpcd

systemctl --user enable pipewire
