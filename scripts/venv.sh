#!/usr/bin/env bash

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
