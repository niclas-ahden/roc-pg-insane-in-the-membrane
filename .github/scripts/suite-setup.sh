#!/usr/bin/env bash
# Put initdb and pg_ctl on the PATH of a bare GitHub runner, for ./tests.roc.
# The required gate gets them from the flake's dev shell, but the per
# operating system legs run ./tests.roc straight on the runner image.
#
# suite.yml hands this to bash, so it cannot be a .roc script.
set -euo pipefail

case "$(uname -s)" in
  Linux)
    # The Ubuntu image ships PostgreSQL, with its server binaries off the PATH.
    bin=$(ls -d /usr/lib/postgresql/*/bin | sort -V | tail -1)
    ;;
  Darwin)
    brew install postgresql@17
    bin="$(brew --prefix postgresql@17)/bin"
    ;;
  *)
    # The Windows image ships PostgreSQL and names its bin directory in PGBIN.
    bin="${PGBIN//\\//}"
    ;;
esac

echo "$bin" >> "$GITHUB_PATH"
PATH="$bin:$PATH"
command -v initdb > /dev/null
command -v pg_ctl > /dev/null
echo "initdb and pg_ctl are available from $bin"
