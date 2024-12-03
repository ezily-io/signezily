#!/bin/sh

set -x

# Export the PORT environment variable
export PORT=${PORT:-3001} # Default to 3001 if PORT is not set

echo "PORT is set to $PORT"

npx prisma migrate deploy --schema ./packages/prisma/schema.prisma

node apps/marketing/server.js