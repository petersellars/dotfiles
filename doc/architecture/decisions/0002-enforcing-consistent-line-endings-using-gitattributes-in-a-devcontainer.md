# 2. Enforcing Consistent Line Endings Using `.gitattributes` in a DevContainer

Date: 2024-09-13

## Status

Accepted

## Context

In our development environment, we are using DevContainers to provide a consistent and reproducible environment for development. One issue that can arise in such environments is the inconsistency of line endings across different operating systems. For instance, Unix-based systems use LF (Line Feed) while Windows systems use CRLF (Carriage Return Line Feed). These differences can lead to issues in version control, code reviews, and overall code quality.

## Decision

To address the issue of inconsistent line endings, we will use a `.gitattributes` file in our DevContainer. This file will enforce consistent line endings across all platforms by configuring Git to handle line endings appropriately.

The `.gitattributes` file will contain the following settings:
```
* text=auto eol=lf
*.{cmd,[cC][mM][dD]} text eol=crlf
*.{bat,[bB][aA][tT]} text eol=crlf
```
* `text=auto eol=lf`: Ensures that all text files are normalized to LF (`\n`) in the repository, but are checked out with the appropriate line endings for the operating system being used.
* `.{cmd,[cC][mM][dD]} text eol=crlf`: Ensures that `.cmd` files use CRLF (`\r\n`) line endings.
* `.{bat,[bB][aA][tT]} text eol=crlf`: Ensures that `.bat` files use CRLF (`\r\n`) line endings.

This configuration helps maintain consistency in line endings for different types of files and across different environments.

## Consequences

1. **Consistency**: Line endings will be consistent across all platforms, reducing merge conflicts and ensuring that files appear the same regardless of the operating system used.
1. **Code Quality**: Enforcing consistent line endings helps in maintaining code quality and readability, which is crucial for collaborative development and code reviews.
1. **Compatibility**: This setup ensures that files are correctly formatted for tools and editors that may be sensitive to line endings.
1. **Reduced Errors**: Minimizes issues related to line endings, such as unexpected behavior or errors in scripts due to inconsistent line endings.

## Alternatives Considered

1. **Manual Line Ending Management**: Relying on developers to manually configure their editors to handle line endings was considered but rejected due to the high risk of inconsistency and human error.
1. **Pre-commit Hooks**: Using pre-commit hooks to automatically normalize line endings was considered but rejected due to the complexity and additional overhead in managing hooks.

## Conclusion

Using a `.gitattributes` file in our DevContainer to enforce consistent line endings is a straightforward and effective solution. It ensures that all team members work with the same line endings, thus reducing potential issues and maintaining code quality across different environments.