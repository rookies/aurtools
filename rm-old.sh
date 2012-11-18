#!/bin/bash
if [[ -z $1 ]]; then
	echo "Usage: $0 <directory>"
	exit
fi
PACKAGES=`./get-old.py $1`
if [[ -z $PACKAGES ]]; then
	echo "No old packages, skipping."
	exit
fi
echo "==> Old packages:"
for pkg in $PACKAGES; do
	echo "   $pkg"
done
echo -n "==> Remove? (y/N) "
read x
if [[ $x = "y" ]]; then
	rm -f $PACKAGES
fi
