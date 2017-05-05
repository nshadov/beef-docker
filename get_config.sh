#!/bin/bash

# Die on any error
# set -e

if [[ -z "${URI_CONFIG}" ]]; then
    echo "WARNING: Environment variable 'URI_CONFIG' not set - using existing configuration."
else
    echo "Downloading credentials from: '${URI_CONFIG}' ..."
    aws configure set default.s3.signature_version s3v4
    aws s3 cp "${URI_CONFIG}" config.yaml && echo "OK"
fi
