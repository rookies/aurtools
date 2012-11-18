#!/bin/bash

size ()
{
	echo -n "Size of AUR directory: "
	du -s -h "$AURDIR" | cut -f1
}

AURDIR="/home/robert/SOFTWARE/AUR/OWN"
size
echo -n "Remove src directories? [y/n] "
read X
if [[ "$X" = "y" ]]; then
	echo -n "  Removing src directories... "
	rm -rf "$AURDIR/"*"/src"
	echo "[DONE]"
fi
size
echo -n "Remove pkg directories? [y/n] "
read X
if [[ "$X" = "y" ]]; then
	echo -n "  Removing pkg directories... "
	rm -rf "$AURDIR/"*"/pkg"
	echo "[DONE]"
fi
size
echo -n "Remove src archives? [y/n] "
read X
if [[ "$X" = "y" ]]; then
	echo -n "  Removing src archives... "
	rm -f "$AURDIR/"*"/"*".src.tar.gz"
	echo "[DONE]"
fi
size
echo -n "Remove pkg archives? [y/n] "
read X
if [[ "$X" = "y" ]]; then
	echo -n "  Removing pkg archives... "
	rm -f "$AURDIR/"*"/"*".pkg.tar.xz"
	echo "[DONE]"
fi
size
