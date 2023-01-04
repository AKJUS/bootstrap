#!/usr/bin/echo This script needs to be sourced, not run directly: source

if type deactivate > /dev/null 2> /dev/null; then
	echo "Leaving venv"
	deactivate
elif ls python_venv > /dev/null 2> /dev/null; then
	echo "Activating existing venv"
	source python_venv/bin/activate
else
	echo "Creating new venv"
	python3 -m venv python_venv
	source python_venv/bin/activate
fi
