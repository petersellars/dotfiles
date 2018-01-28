#!/bin/bash
set -e
set -o pipefail

# install.h
#	This script installs my basic setup for a debian laptop or vm

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
		# If there is only one option just use that user
		if [ "${#options[@]}" -eq "1" ]; then
			readonly TARGET_USER="${options[0]}"
			echo "Using user account: ${TARGET_USER}"
			return
		fi

		# Iterate through the user options and print them
		PS3='Which user account should be used? '

		select opt in "${options[@]}"; do
			readonly TARGET_USER=$opt
			break
		done
	fi
}

check_is_sudo() {
	if [ "$EUID" -ne 0 ]; then
		echo "Please run as root."
		exit
	fi
}

setup_sources_min() {
	apt update
	apt install -y \
		apt-transport-https \
		ca-certificates \
		curl \
		dirmngr \
		lsb-release \
		--no-install-recommends

	# Hack for latest git (don't judge)
	cat <<-EOF > /etc/apt/sources.list.d/git-core.list
	deb http://ppa.launchpad.net/git-core/ppa/ubuntu xenial main
	deb-src http://ppa.launchpad.net/git-core/ppa/ubuntu xenial main
	EOF

	# neovim
	cat <<-EOF > /etc/apt/sources.list.d/neovim.list
	deb http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	deb-src http://ppa.launchpad.net/neovim-ppa/unstable/ubuntu xenial main
	EOF

	# Add the git-core ppa gpg key
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24

	# Add the neovim ppa gpg key
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 9DBB0BE9366964F134855E2255F96FCF8231B6DD
	
	# Turn off translations, speed up apt update
	mkdir -p /etc/apt/apt.conf.d
        echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations
}

# Sets up apt sources
# Assumes you are going to use debian stretch
setup_sources() {
	setup_sources_min;

	cat <<-EOF > /etc/apt/sources.list
	deb http://httpredir.debian.org/debian stretch main contrib non-free
	deb-src http://httpredir.debian.org/debian/ stretch main contrib non-free

	deb http://httpredir.debian.org/debian stretch-updates main contrib non-free
	deb-src http://httpredir.debian.org/debian/ stretch-updates main contrib non-free

	deb http://security.debian.org/ stretch/updates main contrib non-free
	deb-src http://security.debian.org/ stretch/updates main contrib non-free

	#deb http://httpredir.debian.org/debian/ jessie-backports main contrib non-free
	#deb-src http://httpredir.debian.org/debian/ jessie-backports main contrib non-free

	deb http://httpredir.debian.org/debian experimental main contrib non-free
	deb-src http://httpredir.debian.org/debian experimental main contrib non-free

	# yubico - Uncomment this when I have a yubikey
	# https://www.yubico.com/
	#deb http://ppa.launchpad.net/yubico/stable/ubuntu xenial main
	#deb-src http://ppa.launchpad.net/yubico/stable/ubuntu xenial main

	# tlp: Advanced Linux Power Management
	# http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
	deb http://repo.linrunner.de/debian sid main
	EOF

	# Add the yubico ppa gpg key
	#apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 3653E21064B19D134466702E43D5C49532CBA1A9

	# Add the tlp apt-repo gpg key
	apt-key adv --keyserver pool.sks-keyservers.net --recv-keys CD4E8809
}

base_min() {
	apt update
	apt -y upgrade

	apt install -y \
		adduser \
		automake \
		bash-completion \
		bc \
		bzip2 \
		ca-certificates \
		coreutils \
		cowsay \
		curl \
		dnsutils \
		file \
		findutils \
		fortune \
		fortunes-min \
		fortunes-debian-hints \
		gcc \
		git \
		gnupg \
		gnupg2 \
		gnupg-agent \
		grep \
		gzip \
		hostname \
		indent \
		iptables \
		jq \
		less \
		libc6-dev \
		locales \
		lsof \
		make \
		mount \
		net-tools \
		neovim \
		pinentry-curses \
		rxvt-unicode-256color \
		scdaemon \
		silversearcher-ag \
		ssh \
		strace \
		sudo \
		tar \
		tree \
		tzdata \
		unzip \
		xclip \
		xcompmgr \
		xz-utils \
		zip \
		--no-install-recommends

	apt autoremove
	apt autoclean
	apt clean

	install_scripts
}

# Installs base packages
# The ustter bare minimal shit
base() {
	base_min;

	apt update
	apt -y upgrade

	apt install -y \
		apparmor \
		bridge-utils \
		cgroupfs-mount \
		firmware-linux-nonfree \
		libapparmor-dev \
		libltdl-dev \
		libseccomp-dev \
		network-manager \
		--no-install-recommends

	# Install tlp with recommends
	apt install -y tlp tlp-rdw

	setup_sudo

	apt autoremove
	apt autoclean
	apt clean

	install_docker
        install_docker_compose
}

# Setup sudo for a user
# because fuck typing that shit all the time
# just have a decent password
# and lock your computer when you aren't using it
# if they have your password they can sudo anyways
# so its pointless
# I know what the fuck I'm doing ;)
setup_sudo() {
	# Add user to sudoers
	adduser "$TARGET_USER" sudo

	# Add user to systemd groups
	# then you won't need sudo to view logs and shit
	gpasswd -a "$TARGET_USER" systemd-journal
	gpasswd -a "$TARGET_USER" systemd-network

	{ \
		echo -e "${TARGET_USER} ALL=(ALL) NOPASSWD:ALL"; \
	} >> /etc/sudoers

	# Set up Downloads folder as tmpfs
	# that way things are removed on reboot
	# I like things clean but you may not want this
	mkdir -p "/home/$TARGET_USER/Downloads"
	echo -e "\\n# tmpfs for downloads\\ntmpfs\\t/home/${TARGET_USER}/Downloads\\ttmpfs\\tnodev,nosuid,size=2G\\t0\\t0" >> /etc/fstab

}

# Install Docker Master
# And adds necessary items to boot params
install_docker() {
	# Create Docker group
	sudo groupadd -f docker
	sudo gpasswd -a "$TARGET_USER" docker

	# Include contributed completions
	mkdir -p /etc/bash_completion.d
	curl -sSL -o /etc/bash_completion.d/docker https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker

	# Get the binary
	local tmp_tar=/tmp/docker.tgz
	local binary_uri="https://download.docker.com/linux/static/edge/x86_64"
	local docker_version
	docker_version=$(curl -sSL "https://api.github.com/repos/docker/docker-ce/releases/latest" | jq --raw-output .tag_name)
	docker_version=${docker_version#v}
	# local docker_sha256
	# docker_sha256=$(curl -sSL "${binary_uri}/docker-${docker_version}.tgz.sha256" | awk '{print $1}')
	(
	set -x
	curl -fSL "${binary_uri}/docker-${docker_version}.tgz" -o "${tmp_tar}"
	# echo "${docker_sha256} ${tmp_tar}" | sha256sum -c -
	tar -C /usr/local/bin --strip-components 1 -xzvf "${tmp_tar}"
	rm "${tmp_tar}"
	docker -v
	)
	chmod +x /usr/local/bin/docker*

	curl -sSL https://raw.githubusercontent.com/petersellars/dotfiles/master/etc/systemd/system/docker.service > /etc/systemd/system/docker.service
	curl -sSL https://raw.githubusercontent.com/petersellars/dotfiles/master/etc/systemd/system/docker.socket > /etc/systemd/system/docker.socket

	systemctl daemon-reload
	systemctl enable docker

	# Update grub with docker configs and power-saving items
	sed -i.bak 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1 apparmor=1 security=apparmor page_posion=1 slab_nomerge vsyscall=none"/g' /etc/default/grub
	echo "Docker has been installed. If you want memory management & swap"
	echo "run update-grub & reboot as root"
	echo "e.g sudo update-grub/update-grub2 and sudo reboot"

}

# Install Docker Compose as a container
install_docker_compose() {
        # TODO - Update this to use latest as per Docker install above
	sudo curl -L --fail https://github.com/docker/compose/releases/download/1.18.0/run.sh -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
}

# Install Flash
install_flash() {
        # Get the binary
	local tmp_dir=/tmp/flash_player
        local tmp_tar=/tmp/flash_player.tar.gz
	local firefox_plugins_dir=/usr/lib/mozilla/plugins
	local flashplayer_version=28.0.0.137
        local binary_uri="https://fpdownload.adobe.com/get/flashplayer/pdc/${flashplayer_version}/"
        (
        set -x
	mkdir -p ${tmp_dir}
        curl -fSL "${binary_uri}/flash_player_npapi_linux.x86_64.tar.gz" -o "${tmp_tar}"
        tar -C ${tmp_dir} -xzvf "${tmp_tar}"
	
	# Copy libflashplayer.so to the Firefox plugins directory
	sudo cp ${tmp_dir}/libflashplayer.so ${firefox_plugins_dir}

	# Copy the Flash Player Local Settings configurations files to the /usr directory
	sudo cp -r ${tmp_dir}/usr/* /usr
	
	rm -Rf ${tmp_dir}
        rm "${tmp_tar}"
        )
}

# install graphics drivers
install_graphics() {
	local system=$1

	if [[ -z "$system" ]]; then
		echo "You need to specify whether it's intel, geforce or optimus"
		exit 1
	fi

	local pkgs=( xorg xserver-xorg )

	case $system in
		"intel")
			pkgs+=( xserver-xorg-video-intel )
			;;
		"geforce")
			pkgs+=( nvidia-driver )
			;;
		"optimus")
			pkgs+=( nvidia-kernel-dkms bumblebee-nvidia primus )
			;;
		*)
			echo "You need to specify whether it's intel, geforce or optimus"
			exit 1
			;;
	esac

	apt install -y "${pkgs[@]}" --no-install-recommends
}

# Install custom scripts/binaries
install_scripts() {
	# Install speedtest
	curl -sSL https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py > /usr/local/bin/speedtest
	chmod +x /usr/local/bin/speedtest

	# Install icdiff
	curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/icdiff > /usr/local/bin/icdiff
	curl -sSL https://raw.githubusercontent.com/jeffkaufman/icdiff/master/git-icdiff > /usr/local/bin/git-icdiff
	chmod +x /usr/local/bin/icdiff
	chmod +x /usr/local/bin/git-icdiff

	# Jess Frazelle's miscellaneous scripts
	# NB. These are downloaded from Jess' miscellanesous binaries store
	local scripts=( have light )

	for script in "${scripts[@]}"; do
		curl -sSL "https://misc.j3ss.co/binaries/$script" > "/usr/local/bin/${script}"
		chmod +x "/usr/local/bin/${script}"
	done
}

# install stuff for i3 window manager
install_wmapps() {
	local pkgs=( feh i3 i3lock i3status scrot slim suckless-tools )

	apt install -y "${pkgs[@]}" --no-install-recommends

}

usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop or vm\\n"
	echo "Usage:"
	echo "  base                               - setup sources & install base pkgs"
	echo "  basemin                            - setup sources & install base min pkgs"
	echo "  flash                              - install flash player"
        echo "  graphics {intel, geforce, optimus} - install graphics drivers"
	echo "  scripts                            - install scripts"
	echo "  wm                                 - install window manager/desktop pkgs"
}

main() {
	local cmd=$1

	if [[ -z "$cmd" ]]; then
		usage
		exit 1
	fi

	if [[ $cmd == "base" ]]; then
		check_is_sudo
		get_user

		# Set up /etc/apt/sources.list
		setup_sources

		base
	elif [[ $cmd == "basemin" ]]; then
		check_is_sudo
		get_user

		# Set up /etc/apt/sources.list
		setup_sources_min

		base_min
	elif [[ $cmd == "graphics" ]]; then
		check_is_sudo

		install_graphics "$2"
	elif [[ $cmd == "wm" ]]; then
		check_is_sudo

		install_wmapps
        elif [[ $cmd == "flash"   ]]; then
                install_flash
	elif [[ $cmd == "scripts" ]]; then
		install_scripts
	else
		usage
	fi
}

main "$@"
