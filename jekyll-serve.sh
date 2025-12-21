#!/bin/bash
# Wrapper script for Jekyll that handles SSL certificate issues on macOS
# This script sets up the environment to work around CRL checking issues

cd "$(dirname "$0")"

# Initialize rbenv
eval "$(rbenv init - zsh)"

# Set SSL certificate file
export SSL_CERT_FILE=/opt/homebrew/etc/ca-certificates/cert.pem

# Load SSL patch to work around CRL checking issues
export RUBYOPT="-r$PWD/ssl_patch.rb"

# Run Jekyll with the provided arguments
bundle exec jekyll "$@"



