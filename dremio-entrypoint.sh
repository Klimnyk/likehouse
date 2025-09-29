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

# Start Dremio according to official documentation
# Usage: dremio [--config <conf-dir>] (start|start-fg|stop|status|restart|autorestart)
if [ -f /opt/dremio/bin/dremio ]; then
    echo "Starting Dremio server in foreground mode..."
    # Use exec to replace current process (best practice for Docker entrypoints)
    exec /opt/dremio/bin/dremio start-fg
else
    echo "Could not find Dremio startup script at /opt/dremio/bin/dremio"
    exit 1
fi
