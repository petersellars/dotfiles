#!/bin/bash
set -e
set -o pipefail

# install.sh
#	This script installs my basic setup for a debian laptop

export DEBIAN_FRONTEND=noninteractive


usage() {
	echo -e "install.sh\\n\\tThis script installs my basic setup for a debian laptop\\n"
	echo "Usage:"
	echo "  base                                - setup sources & install base pkgs"
	echo "  basemin                             - setup sources & install base min pkgs"
	echo "  wifi {broadcom, intel}              - install wifi drivers"
	echo "  graphics {intel, geforce, optimus}  - install graphics drivers"
	echo "  wm                                  - install window manager/desktop pkgs"
	echo "  dotfiles                            - get dotfiles"
	echo "  vim                                 - install vim specific dotfiles"
	echo "  golang                              - install golang and packages"
	echo "  scripts                             - install scripts"
	echo "  syncthing                           - install syncthing"
	echo "  vagrant                             - install vagrant and virtualbox"
}

main() {
	usage
}

main "$@"


