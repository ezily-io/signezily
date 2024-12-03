#!/bin/bash

# Check if a parameter is given
if [ -z "$1" ]; then
  echo "No value provided. Usage: ./start.sh <command>"
  exit 1
fi

# Assign the first argument to a variable
value=$1

# Commands to put the certificate file, this is required for signing.
signing__file_creation() {
  # Check if environment variable is set
  if [ -z "$DOCUMENSO_SIGNING_CERT_FILE" ]; then
    echo "[WARNING]: Required environment variable for signing cert is not set"
    return 0
  fi

  # Cert File
  cat <<CERT_P12 > cert.p12
$DOCUMENSO_SIGNING_CERT_FILE
CERT_P12

  # Set appropriate permissions
  chmod 755 cert.p12
}

# Use a case statement to handle different values
case $value in
  marketing)
    echo "Running marketing site"
    signing__file_creation
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/marketing/server.js
    ;;
  default)
    echo "Running documenso main website"
    signing__file_creation
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/web/server.js
    ;;
  documentation)
    echo "Running documentation site"
    signing__file_creation
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/documentation/server.js
    ;;
  *)
    echo "No valid argument provided. Exiting."
    exit 1
    ;;
esac