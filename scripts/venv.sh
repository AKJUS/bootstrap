#!/usr/bin/echo This script needs to be sourced, not run directly: source

if type deactivate > /dev/null 2> /dev/null; then
	echo "Leaving venv"
	deactivate
elif ls venv > /dev/null 2> /dev/null; then
	echo "Activating existing venv"
	source venv/bin/activate
else
	echo -n "Create new venv? (Y/n): "
	read -r ans
	if [[ "$ans" != N* && "$ans" != n* ]]; then
		echo "Creating new venv"
		python3 -m venv venv
		source venv/bin/activate

		echo -n "Install requirements in new venv? (Y/n): "
		read -r ans
		if [[ "$ans" != N* && "$ans" != n* ]]; then
			pip install -r requirements.txt
		fi
	else
		echo "Doing nothing"
	fi
fi
