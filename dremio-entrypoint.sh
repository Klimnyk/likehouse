#!/bin/bash

# Navigate to Dremio's bin directory
cd /opt/dremio/bin/

# Check if upgrade is needed and run it if necessary
# The upgrade command should be idempotent, but it's good practice
# to check if the server version is newer than the KVStore version
# A simple check might not be robust enough for all scenarios,
# but running upgrade unconditionally is also an option if it's idempotent.
# Let's just run upgrade as the error suggests it's needed.

echo "Running Dremio KVStore upgrade..."
./dremio-admin upgrade

if [ $? -ne 0 ]; then
    echo "Dremio upgrade failed. Exiting."
    exit 1
fi

echo "Dremio KVStore upgrade completed. Starting Dremio server..."

# Execute the original Dremio server startup command
# This assumes the default command in the Dremio image starts the server.
# You might need to find the exact command if the default entrypoint is used.
# A common way is to use 'exec' to replace the current process,
# which is good practice for entrypoints.
# The default command for dremio/dremio-oss usually involves starting the server.
# Let's try executing the standard entrypoint script if it exists, or the server command directly.

# Check if there's a standard entrypoint script to use
if [ -f /opt/dremio/bin/dremio ]; then
    exec /opt/dremio/bin/dremio server
elif [ -f /opt/dremio/dremio ]; then
     exec /opt/dremio/dremio server
else
    echo "Could not find Dremio server startup script/command."
    exit 1
fi

# Fallback if the above didn't work (less likely for standard images)
# exec java ... (the actual Java command to start Dremio)
