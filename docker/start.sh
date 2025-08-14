#!/bin/bash

# Check if a parameter is given
if [ -z "$1" ]; then
  echo "No value provided. Usage: sh ./start.sh <command>"
  exit 1
fi

value=$1

# Use a case statement to handle different values
case $value in
  marketing)
    echo "Running marketing site"
    sh generate_cert_p12.sh
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/marketing/server.js
    ;;
  default)
    echo "Running documenso main website"
    sh generate_cert_p12.sh
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/web/server.js
    ;;
  documentation)
    echo "Running documentation site"
    sh generate_cert_p12.sh
    set -x
    npx prisma migrate deploy --schema ./packages/prisma/schema.prisma
    node apps/documentation/server.js
    ;;
  *)
    echo "No valid argument provided. Exiting."
    exit 1
    ;;
esac
