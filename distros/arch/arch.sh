# Norwegian mirrors
sudo cp distros/arch/mirrorlist /etc/pacman.d/mirrorlist

# Upgrade system
sudo pacman -Syu --noconfirm

# Install packages
sudo pacman -S --noconfirm - < packages/arch.txt

# Install packages for non-VM machines
if ! $vm; then
        sudo pacman -S --noconfirm - < packages/arch_not_vm.txt
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
