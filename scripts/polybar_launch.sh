#!/usr/bin/env bash

#
# Quit other running polybar instances, then start a new one
#

polybar-msg cmd quit

echo "---" | tee -a /tmp/polybar.log
polybar lars -c ~/.config/polybar/polybar.conf 2>&1 | tee -a /tmp/polybar.log & disown
