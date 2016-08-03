#!/bin/bash

set -e

(
# find all executables and run shellcheck
for f in $(find . -type f -executable -not -path "./.git/*"); do
	shellcheck "$f" && echo -e "--\nSuccessfully linted $f\n--"
done
) || true
