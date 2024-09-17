# 4. Adoption of Commitlint and Husky for Commit Message Linting in Git Repository

Date: 2024-09-17

## Status

Accepted

## Context

Consistent and meaningful commit messages are essential for the maintainability and clarity of a project. Commit messages should follow a defined convention, such as [Conventional Commits](https://www.conventionalcommits.org/), to allow for automated semantic versioning, changelog generation, and easier collaboration among team members.

To enforce this consistency, **Commitlint** is a tool that lints commit messages based on defined rules, ensuring that all commits adhere to a structured format. To automate this linting process at the time of a commit, we can use **Husky**, which enables us to run Git hooks and apply Commitlint in an automated fashion. This ADR outlines the decision to adopt Commitlint with Husky in our Git repository.

## Decision

We will integrate [Commitlint](https://commitlint.js.org/) with [Husky](https://typicode.github.io/husky/) into our Git repository to enforce commit message standards. Instead of using the **pre-commit hook**, we will use the **commit-msg** hook to ensure that only valid commit messages are allowed. This ensures that the commit message can be linted after it is composed, rather than before.

Additionally, this ADR covers the necessary changes to our DevContainer configuration to ensure that developers working within the container can easily use Commitlint, including the integration of nvm (Node Version Manager) in the DevContainer to manage Node.js versions.

### Reasons for Choosing Commitlint

* Ensures consistent commit messages across the entire project.
* Facilitates automated semantic versioning and changelog generation.
* Helps maintain a clean and readable project history.

### Reasons for Choosing the commit-msg Hook

* The `commit-msg` hook allows linting of the actual commit message, as opposed to `pre-commit`, which does not have access to the commit message content.
* This ensures that the message is linted after the developer finishes writing it, preventing invalid commit messages from being recorded.

### Why Husky?

* Husky makes it easy to run Git hooks like commit-msg or other hooks (e.g., pre-push) without having to configure them manually.
* By using Husky, we can automate the commit linting process without burdening the development workflow.

## Changes Required

### 1. Add Commitlint and Husky to the Repository

Steps:

1. Install Commitlint and Husky as dev dependencies:

    ```bash
    npm install --save-dev @commitlint/{config-conventional,cli} husky
    ```
1. Create a Commitlint configuration file (`commitlint.config.js`) in the root of the repository to use the Conventional Commits ruleset:

    ```js
    module.exports = {extends: ['@commitlint/config-conventional']};
    ```
1. Initialize Husky and add a `commit-msg` hook to run Commitlint:

    ```bash
    npx husky install
    npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
    ```
1. Ensure that Husky is automatically set up on new installs by adding the following script to `package.json`:

    ```json
    {
      "scripts": {
        "prepare": "husky install"
      }
    }
    ```
### 2. Configure DevContainer to Support Commitlint
To ensure that developers using the **DevContainer** have access to Commitlint and Husky, the following steps should be taken to configure the DevContainer with **nvm** and Node.js.

#### Steps:

1. Modify the `.devcontainer/devcontainer.json` to include the nvm feature for managing Node.js versions:

    ```json
    {
      "name": "My DevContainer",
      "features": {
        "ghcr.io/devcontainers/features/nvm:1": {
          "version": "lts"
        }
      },
      "customizations": {
        "vscode": {
          "extensions": [
            "dbaeumer.vscode-eslint",
            "esbenp.prettier-vscode"
          ]
        }
      }
    }
    ```
1. Add a `postCreateCommand` to the DevContainer configuration to install dependencies (including Commitlint and Husky) when the container is built:

    ```json
    {
      "postCreateCommand": "npm install"
    }
    ```
1. Ensure the correct Node.js version is used in the DevContainer by adding an `.nvmrc` file in the repository root:

    ```bash
    lts/*
    ```

This will ensure that the DevContainer uses the latest LTS version of Node.js, and developers using the DevContainer will have the correct environment to run Commitlint and Husky without needing to configure their local machines.

### 3. Update Documentation

Add relevant sections to the project's README or developer documentation to describe the Commitlint setup, the commit message conventions, and how the automated checks are run during development. Include instructions on how to bypass the commit linting process in case of emergencies (e.g., `git commit --no-verify`).

## Consequences

### Positive:

* **Consistency**: Developers will be required to follow a defined commit message structure, improving the overall readability and maintainability of the commit history.
* **Automation**: By using Husky, the process of linting commit messages becomes fully automated, reducing manual steps in the development workflow.
* **DevContainer Support**: The addition of nvm in the DevContainer ensures that all developers have a consistent environment, avoiding issues related to Node.js versions or missing dependencies.

### Negative:

* **Initial Overhead**: There may be some friction as developers adjust to the new commit message conventions.
* **Bypassability**: While Husky can enforce rules locally, developers can bypass them using the --no-verify flag. This should be discouraged and reserved for emergencies only.

## Alternatives Considered

* **Manually enforcing commit conventions**: While possible, this approach would rely on team discipline, which can be inconsistent and error-prone. Automation ensures that conventions are followed every time.
* **Pre-commit Hook**: Using the pre-commit hook would not allow us to lint the commit message itself, as this hook runs before the commit message is composed.

## Decision Outcome

This ADR proposes the adoption of Commitlint with Husky using the `commit-msg hook`. The changes to the DevContainer and overall repository configuration will ensure that the tool is integrated seamlessly into the development workflow.