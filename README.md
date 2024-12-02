# Dotfiles

[![Keep a Changelog](https://img.shields.io/badge/keepachangelog-1.1.0-blue?logo=Keep%20A%20Changelog&logoColor=white&labelColor=%23E05735)
](https://keepachangelog.com/)

[![Convential CommitLog:1.0.0](https://img.shields.io/badge/convential%20commitlog-1.0.0-blue?logo=Conventional%20Commits&logoColor=white&labelColor=%23FE5196&link=https%3A%2F%2Fwww.conventionalcommits.org%2Fen%2Fv1.0.0%2F)](https://www.conventionalcommits.org/)
[![commitlint/cli:19.5.0](https://img.shields.io/badge/commitlint%2Fcli-19.5.0-blue?logo=commitlint&logoColor=white&labelColor=%23000000)](https://commitlint.js.org/)

![NVM:0.40.1](https://img.shields.io/badge/nvm-0.40.1-blue?labelColor=%23F4DD4B)
![Node:22.11.0](https://img.shields.io/badge/node-22.11.0-blue?logo=Node.js&logoColor=white&labelColor=%235FA04E)
![NPM:10.9.0](https://img.shields.io/badge/npm-10.9.0-blue?logo=npm&logoColor=white&logoSize=auto&labelColor=%23CB3837)

---

## Dotfiles
Dotfiles are configuration files typically used to customize and manage user environments in Unix-like operating systems. They are often hidden (with filenames starting with a .) and are used by various tools and applications, such as Git (`.gitconfig`), shells (`.bashrc`, `.zshrc`), and editors like Vim (`.vimrc`). Including Dotfiles in a project or personal repository is highly beneficial because they allow users to maintain consistent configurations across different systems, streamline setups, and serve as a backup for personalized settings. Sharing Dotfiles in a repository can also help others adopt similar workflows or configurations, promoting productivity and collaboration.

## Installation
After cloing this repo, run `install` to automatically set up the development environment. Note that the install script is idempotent: it can safely be run multiple times.

```
git clone https://github.com/petersellars/dotfiles
cd dotfiles && ./install
```

Dotfiles uses [Dotbot](https://github.com/anishathalye/dotbot) for installation.

## Configuration
Dotfiles configuration resides in the `.install.conf.yaml` file.

## Making Local Customizations
You can make local customizations for some programs by editing these files:

* `bash`: `~/shell_local_before` run first
* `bash`: `~/bashrc_local_before` run before `.bashrc`
* `bash`: `~/bashrc_local_after` run after `.bashrc`
* `bash`: `~/shell_local_after` run last

## Licence
Copyright (c) Peter Sellars. Released under the MIT License. See [LICENSE.md](./LICENSE.md) for details.
