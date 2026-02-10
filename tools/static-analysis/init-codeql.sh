#!/usr/bin/env bash
CODEQL_VERSION="v2.17.6"
wget -q "https://github.com/github/codeql-action/releases/download/codeql-bundle-${CODEQL_VERSION}/codeql-bundle-linux64.tar.gz" -O /tmp/codeql.tar.gz
cd /opt && tar -xzf /tmp/codeql.tar.gz
ln -s /opt/codeql/codeql /usr/local/bin/codeql
rm /tmp/codeql.tar.gz
