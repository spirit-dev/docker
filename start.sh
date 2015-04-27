#!/bin/sh

set -e
usermod --uid $UID minecraft
#chown -R minecraft /data /start-minecraft.sh
chown -R minecraft /data /start-minecraft
chmod 755 /start-minecraft

#exec sudo -E -u minecraft /start-minecraft.sh
exec su -s /bin/bash -c /start-minecraft minecraft