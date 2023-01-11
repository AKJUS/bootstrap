# Bootstrap new Linux installations

Only arch support for now

## Note to self - What it do

- Installs packages I care about
- Various configs:
	- i3
	- i3status
	- rofi
	- vim
	- bash (alias, PS1, bashrc)
	- git
	- Xresources
- Build and install stterm with my collection of patches
- Scripts
- vm.swappiness = 1
- iptables setup

## Scripts

### lockscript

Provides a "frosted glass" look for when computer is locked

### mkln

Used as a shortcut to make symlinks in /usr/local/bin

``` bash
[/opt/ghidra]
$ mkln ghidraRun  # Will make a symlink at /usr/local/bin/ghidraRun

[/opt/ghidra]
$ mkln ghidraRun ghidra  # Will make a symlink at /usr/local/bin/ghidra
```

### no-internet

Run commands without granting them internet access.
Will also warn you if it detects that it actually has internet access, and refuse to run the program.

Implementation simply runs command as the ``no-internet`` group, and relies on iptables rules defined in ``bootstrap.sh`` to do the actual blocking.

``` bash
$ no-internet.sh ping 8.8.8.8 -c 1
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.

--- 8.8.8.8 ping statistics ---
1 packets transmitted, 0 received, 100% packet loss, time 0ms
```

### venv

Helper for managing python virtual environments.

Simply running ``venv`` with no arguments will read your mind and do what you want it to, since 99,999999% of the time you want to either:
1. Exit an active venv
2. Activate an existing venv
3. Create a new venv

This can be easily accomplished, since if you just check in this order then there is no risk of doing the wrong thing. Will also ask you before creating a venv and optionally installing requirements.

The script is smart enough to look upwards in the directory structure for venvs, but will only try to create a venv in your CWD. Checking for git and asking if you want to create venv at git root instead might be a thing some day.

``` bash
[~/git/cool_project]
$ venv
Create new venv? (Y/n):
Creating new venv
Install requirements in new venv? (Y/n):
Collecting pycryptodome
  Downloading pycryptodome-3.16.0-cp35-abi3-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (2.3 MB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.3/2.3 MB 2.2 MB/s eta 0:00:00
Installing collected packages: pycryptodome
Successfully installed pycryptodome-3.16.0
(cool_project) [~/git/cool_project]
$ venv
Leaving venv
[~/git/cool_project]
$ cd test/test/
[~/git/cool_project/test/test]
$ venv
Activating existing venv for cool_project ( ../../.venv )
(cool_project) [~/git/cool_project/test/test]
$ 
```
