#!/bin/bash
set -e
set -o pipefail

# install.h
#	This script installs my basic setup for a debian laptop or vm

export DEBIAN_FRONTEND=noninteractive

# Choose a user account to use for this installation
get_user() {
	if [ -z "${TARGET_USER-}" ]; then
		PS3='Which user account should be used? '
		mapfile -t options < <(find /home/* -maxdepth 0 -printf "%f\\n" -type d)
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
		curl \
		dnsutils \
		file \
		findutils \
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

	#install_scripts
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

	#install_docker
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
}

usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop or vm\\n"
	echo "Usage:"
	echo "  base                           - setup sources & install base pkgs"
	echo "  basemin                        - setup sources & install base min pkgs"
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
	else
		usage
	fi
}

main "$@"
