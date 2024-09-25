# 5. Managing Dotfiles with Dotbot

Date: 2024-09-24

## Status

Accepted

## Context

Dotfiles are essential configuration files that customize a development environment. To efficiently manage and synchronize dotfiles across different environments, we need a tool that can automate the setup, is easy to configure, and supports various platforms, including WSL (Windows Subsystem for Linux), DevContainers, and Devbox. Manual management of dotfiles across multiple systems can lead to inconsistencies and time-consuming setup.

**Decision:** Use [DotBot](https://github.com/anishathalye/dotbot) to automate the management of dotfiles across development environments.

## Decision

- **Consistency**: Dotfiles should be consistently applied across all environments without manual intervention.
- **Automation**: The dotfile setup should be automated to minimize time and errors.
- **Cross-Platform Support**: The solution should support a variety of environments such as WSL, DevContainers, and Devbox.
- **Ease of Use**: Simple configuration and setup for both new and experienced developers.
- **Extensibility**: The solution should allow future extensions and modifications with minimal effort.

## Considered Options

- **Manual dotfile management with symlinks**
- **Using DotBot**
- **Using alternative tools like GNU Stow or Homeshick**

## Decision Outcome

The decision is to use DotBot due to its simplicity, cross-platform capabilities, and ease of configuration.

### Benefits of DotBot:
1. **Declarative Configuration**: DotBot uses a YAML configuration file that is simple and easy to read.
2. **Cross-platform**: Works well on Linux, macOS, and can be adapted to work in WSL, DevContainers, and Devbox.
3. **Minimal Dependencies**: DotBot is a single Python script with no external dependencies.
4. **Modular**: DotBot configurations are flexible and can be easily extended as the project grows.
5. **Idempotent**: Re-running DotBot ensures that the configuration is always consistent without unintended side effects.

### Drawbacks:
- **Limited Functionality**: DotBot is focused on symlink management and script execution, so more complex tasks may require additional tooling.
- **No built-in versioning**: While DotBot can apply configurations, it doesn't version control them, so this will need to be handled separately (e.g., using Git).

## How to Implement

### Step 1: Install DotBot

1. Add DotBot as a submodule (this allows you to easily update DotBot later):
    ```bash
    git submodule add https://github.com/anishathalye/dotbot
    ````
1. Ignore dirty changes in the dotbot submodule:
    ```bash
    git config -f .gitmodules submodule.dotbot.ignore dirty
    ```
1. Copy the install script to the current directory:
    ```bash
    cp dotbot/tools/git-submodule/install .
    ```

### Step 2: Create a Basic Configuration File
Create an install.conf.yaml file in the root of your dotfiles directory:
```yaml
- clean: ['~']

# - link:
#     ~/.bashrc: bashrc
#     ~/.gitconfig: gitconfig

- shell:
    - echo "Dotfiles installation complete!"
```

This configuration will:

1. Clean up any broken symlinks.
2. Disabled symlink `bashrc` and `gitconfig` from the dotfiles directory to the user's home directory.
3. Run a simple shell command to indicate successful setup.

### Step 3: Install Dotfiles
Run DotBot using the `install` command:
```bash
./install
```
This command will create the necessary symlinks and ensure your dotfiles are correctly installed.

### Step 4: Integrating with WSL, DevContainers, and Devbox
**WSL**

DotBot can be used in WSL environments with minimal configuration. Follow the standard installation steps, and ensure that the symlinks and shell scripts are compatible with the WSL environment.

You can also create environment-specific configurations, for example:
```yaml
- link:
    ~/.bashrc: bashrc_wsl
```

This allows you to manage WSL-specific dotfiles separately from other environments.

**DevContainers**

To use DotBot inside a DevContainer, add DotBot to your Dockerfile or use a post-create command to set up dotfiles automatically. Example Dockerfile snippet:
```Dockerfile
# Install DotBot dependencies
RUN apt-get update && apt-get install -y git python3

# Clone DotBot and run the installation
RUN git clone https://github.com/anishathalye/dotbot /home/vscode/dotbot && \
    cd /home/vscode/dotbot && \
    /home/vscode/dotbot/bin/dotbot -c /home/vscode/dotfiles/install.conf.yaml
```
This ensures that when the DevContainer is built, the dotfiles are automatically applied.

**Devbox**

For [Devbox](https://github.com/jetify-com/devbox), include DotBot as part of your development environment setup by specifying it in your Devbox configuration (`devbox.json`):
```json
{
  "packages": ["git", "python3"],
  "shell": {
    "init_hook": [
      "git clone https://github.com/anishathalye/dotbot",
      "cd dotbot && ./bin/dotbot -c ../install.conf.yaml"
    ]
  }
}
```

This ensures DotBot is installed and executed whenever the Devbox environment is initialized.

### Related Decisions
Version control for dotfiles should be managed using Git or a similar version control system. DotBot only handles configuration application, not versioning.
### Conclusion
DotBot provides a simple, reliable, and cross-platform way to manage dotfiles across environments like WSL, DevContainers, and Devbox. Its declarative approach and minimal dependencies make it an ideal solution for ensuring consistent dotfile setups across multiple development environments.