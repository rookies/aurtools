#!/bin/bash
skip=0
echo "CHECKING IF PACKAGES ARE IN AUR..."
PACKAGES=""
for line in `pacman -Qm`; do
	if [[ $skip -eq 0 ]]; then
		curl -\# "https://aur.archlinux.org/rpc.php?type=info&arg=$line" 2> /dev/null | grep "{\"type\":\"error\",\"results\":\"No results found\"}" > /dev/null
		if [[ $? -eq 1 ]]; then
			echo "[$line] found."
			PACKAGES="$PACKAGES $line"
		else
			echo "[$line] NOT FOUND."
		fi
		skip=1
	else
		skip=0
	fi
done
echo "CHECKING IF PACKAGES ARE VOTED..."
for pkg in $PACKAGES; do
	echo -n "[$pkg]: "
	aurvote --check $pkg
done
