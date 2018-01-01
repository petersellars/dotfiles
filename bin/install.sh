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

	# Add the git-core ppa gpg key
	apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys E1DD270288B4E6030699E45FA1715D88E1DF1F24

	# Turn off translations, speed up apt update
	mkdir -p /etc/apt/apt.conf.d
        echo 'Acquire::Languages "none";' > /etc/apt/apt.conf.d/99translations
}

# Sets up apt sources
# Assumes you are going to use debian stretch
setup_sources() {
	setup_sources_min;
}

base_min() {
	apt update
	apt -y upgrade

	apt install -y \
		git \
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
		git \
		--no-install-recommends

	#setup_sudo

	apt autoremove
	apt autoclean
	apt clean

	#install_docker
}

usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop or vm\\n"
	echo "Usage:"
	echo "  base				    - setup sources & install base pkgs"
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
	else
		usage
	fi
}

main "$@"
