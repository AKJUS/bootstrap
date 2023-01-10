#!/usr/bin/env bash

# Run command as no-internet group only if said group does not appear to have internet access
# Causes a slight delay in command execution while testing for internet access

if sg no-internet "ping -W 0.05 -c 1 8.8.8.8" &> /dev/null; then
	echo "${0##*/}: Internet connection detected - ABORT!"
	exit 1
fi

sg no-internet "$(echo $@)"
