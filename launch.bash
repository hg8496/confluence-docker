#!/bin/bash
set -o errexit
sudo own-volume

/usr/local/bin/setup_server_xml.sh

/opt/confluence/bin/start-confluence.sh -fg
