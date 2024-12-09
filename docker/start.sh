#!/bin/bash

# Check if a parameter is given
if [ -z "$1" ]; then
  echo "No value provided. Usage: sh ./start.sh <command>"
  exit 1
fi

npx prisma migrate deploy --schema ../../packages/prisma/schema.prisma

HOSTNAME=0.0.0.0 node build/server/main.js
