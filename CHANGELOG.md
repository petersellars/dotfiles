# Changelog

All notable changes to this project will be documented in this file.

The format is based on  [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- A [DevContainer](https://containers.dev/) has been provided to ensure a consistent development experience.
- This `CHANGELOG` file that follows [keep a changelog](https://keepachangelog.com/) guidelines to list notable changes.
- A `.gitattributes` file to ensure consistent line endings.
- Added support for writing and managing [ADRs](https://adr.github.io/) using [adr-tools](https://github.com/npryce/adr-tools) within the DevContainer.
- Initialised [ADR](doc/architecture/decisions/0001-record-architecture-decisions.md) documentation
- Added an [ADR](doc/architecture/decisions/0002-enforcing-consistent-line-endings-using-gitattributes-in-a-devcontainer.md) detailing the decision regarding the `.gitarributes`.
- Added [ADR](doc/architecture/decisions/0003-use-of-devcontainers.md) documenting the decision to use DevContainers for consistent and reproducible development environments.

### Changed

- Updated the LICENSE copyright date to 2024.

### Removed

- All old dotfiles and tools.

[unreleased]: https://github.com/petersellars/dotfiles/compare/master