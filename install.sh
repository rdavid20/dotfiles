#!/bin/bash 

if [ -f /etc/os-release ]; then
	. /etc/os-release
	DISTRO=$ID
else
	echo "Cannot detect distro"
	exit 1
fi 


REPO_PACKAGES=()
AUR_PACKAGES=()
while IFS= read -r line || [ -n "$line" ]; do
	[[ "$line" =~ ^#.*$ || -z "$line" ]] && continue

	if [[ "$line" == aur:* ]]; then
		AUR_PACKAGES+=("${line#aur:}")
	else
		REPO_PACKAGES+=("$line")
	fi
done < ~/dotfiles/packages.txt

install_arch() {
	sudo pacman -Syu --noconfirm
	for pkg in "${REPO_PACKAGES[@]}"; do
		if pacman -Qi "$pkg" &> /dev/null; then
			echo "$pkg is already installed."
		else
			echo "Installing $pkg..."
			sudo pacman -S --noconfirm "$pkg"
		fi
	done

	for aur_pkg in "${AUR_PACKAGES[@]}"; do
		if yay -Q "$aur_pkg" &> /dev/null; then
			echo "AUR package $aur_pkg already installed."
		else 
			echo "Installing AUR package $aur_pkg..."
			yay -S --noconfirm "$aur_pkg"
		fi
	done
}

case "$DISTRO" in
	arch)
		echo "Arch detected. Installing packages..."
		install_arch
		;;
	*)
		echo "Unsupported distro: $DISTRO"
		exit 1
		;;
esac

export XCURSOR_THEME=Bibata-Modern-Ice
export XCURSOR_SIZE=24

echo "Installation Complete"
