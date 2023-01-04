#!/usr/bin/echo This script needs to be sourced, not run directly: source

venv_search() {
	current=$PWD
	while [[ -n "$current" ]] ; do
		result=$(find "$current" -maxdepth 1 -type d -name venv)
		if [[ -n $result ]]; then
			return 0;
		fi
		current=$(echo "$current" | rev | cut -f 2- -d '/' | rev)
	done
	return 1
}

if type deactivate > /dev/null 2> /dev/null; then
	echo "Leaving venv"
	deactivate
elif venv_search; then
	echo "Activating existing venv at $result"
	source "$result"/bin/activate
else
	echo -n "Create new venv? (Y/n): "
	read -r ans
	if [[ "$ans" != N* && "$ans" != n* ]]; then
		echo "Creating new venv"
		python3 -m venv venv
		source venv/bin/activate

		if ls requirements.txt > /dev/null 2> /dev/null; then
			echo -n "Install requirements in new venv? (Y/n): "
			read -r ans
			if [[ "$ans" != N* && "$ans" != n* ]]; then
				pip install -r requirements.txt
			fi
		fi
	else
		echo "Doing nothing"
	fi
fi
