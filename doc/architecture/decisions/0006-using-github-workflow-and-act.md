# 6. Using GitHub Workflow and ACT for Dotfiles Testing

Date: 2024-12-06

## Status

Accepted

## Context

The Dotfiles GitHub project is a critical repository for managing personal configurations and setup scripts. Ensuring the reliability and correctness of changes is paramount, especially as updates can impact multiple environments. To streamline testing and improve feedback loops, automated workflows are essential.

## Decision

The project adopts a GitHub Workflow for automated testing of the Dotfiles project and utilizes ACT to run workflows locally during development.

### Rationale

1. **GitHub Workflow for CI/CD**

   - **Consistency**: Using GitHub Workflows ensures that tests are executed in the same environment where the repository is hosted, maintaining consistency.
   - **Integration**: GitHub Workflows provide seamless integration with the repository, making it easy to trigger tests on pull requests, pushes, or scheduled events.
   - **Scalability**: Workflows can run on various environments, including different operating systems and configurations, allowing comprehensive testing.

2. **ACT for Local Testing**

   - **Faster Feedback Loop**: ACT allows testing GitHub Workflows locally without committing changes or pushing to the remote repository, significantly reducing iteration time.
   - **Resource Efficiency**: Running tests locally avoids using GitHub Actions minutes and reduces dependency on external resources.
   - **Debugging**: ACT facilitates easier debugging of workflow scripts by providing immediate feedback in the local development environment.

## Constraints

1. **Lack of Support for Ubuntu 24.04 in ACT**

   - The ACT tool does not currently support Ubuntu 24.04 as a runtime environment, a feature critical for testing newer configurations and setups.
   - This limitation requires fallback to supported environments (e.g., Ubuntu 20.04 or 22.04), which may not fully align with production scenarios.

2. **Issue Tracking**

   - An open issue exists in the ACT repository to address the lack of support for Ubuntu 24.04.
   - Issue: Add Ubuntu 24.04 - https://github.com/nektos/act/issues/2329
   - Progress on this issue is monitored to adopt newer environments once supported.

## Alternatives Considered

1. **Running Workflows Exclusively on GitHub Actions**

   - **Pros**: Provides complete access to GitHub-hosted environments.
   - **Cons**: Slower feedback loop, reliance on external resources, and potential costs associated with GitHub Actions minutes.

2. **Manual Testing**

   - **Pros**: Does not depend on ACT or GitHub Workflows.
   - **Cons**: Time-consuming, error-prone, and lacks reproducibility.

## Consequences

- **Positive**: The decision enhances the developer experience by enabling quick feedback loops, reducing costs, and ensuring robust testing.
- **Negative**: Limited support for the latest Ubuntu releases may delay adoption of cutting-edge configurations.

## Follow-Up

- Monitor progress on ACT’s Ubuntu 24.04 support and integrate it once available.
- Continuously evaluate alternatives to ACT as tools evolve.
- Periodically review GitHub Workflow configurations to align with project needs and technological advancements.
