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
	relpath=$(realpath --relative-to='.' "$result")
	dir_name="\e[1m$(echo -n "$result" | rev | cut -f 2 -d '/' | rev)\e[0m"
	string="Activating existing venv for $dir_name"
	if [[ $relpath != "venv" ]]; then
		string="$string ( $relpath )"
	fi
	echo -e "$string"
	source "$result"/bin/activate
else
	echo -n "Create new venv? (Y/n): "
	read -r ans
	if [[ "$ans" != N* && "$ans" != n* ]]; then
		echo "Creating new venv"
		prompt=$(realpath . | rev | cut -f 1 -d '/' | rev)
		python3 -m venv venv --prompt "\e[96m$prompt\e[0m"
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
