#!/bin/zsh
# Options:
#   --skip-out-of-date
#   --skip a,b,c,...
#   --only a,b,c,...

buildcheck () {
	cd /tmp/aur-buildcheck-$$
	# download tar archive:
	if [[ -f $1.tar.gz ]]; then
		rm -f $1.tar.gz || return 1
	fi
	wget https://aur.archlinux.org/packages/`echo -n $1 | head -c 2`/$1/$1.tar.gz || return 1
	# extract tar archive:
	tar xf $1.tar.gz || return 1
	cd $1
	# check arch:
	. ./PKGBUILD
	if [[ "$arch" != "any" ]]; then
		MATCH=0
		for a in $(echo $arch | tr ' ' '\n'); do
			if [ "$a" = "`uname -m`" ]; then
				MATCH=1
			fi
		done
		if [[ ! $MATCH -eq 1 ]]; then
			return 2
		fi
	fi
	# try to build package:
	makepkg || return 1
	# keep package:
	PKGFILE=`find . -name "$1-*-*.pkg.tar.xz"`
	if [[ -f "$PKGDIR/$PKGFILE" ]]; then
		rm -f "$PKGDIR/$PKGFILE"
	fi
	echo "$PKGFILE" | grep "any.pkg.tar.xz"
	if [[ $? -eq 0 ]]; then
		mv "$PKGFILE" "$PKGDIR"
	else
		mv "$PKGFILE" "$PKGDIR/`uname -m`"
	fi
}

# get package names:
cd "`dirname $0`"
LOGFILE="`pwd`/buildcheck_`uname -n`.log"
PKGDIR="`pwd`/packages"
PACKAGES="`./get-own-packages-raw.rb $@`"
PKGNUM=`echo "$PACKAGES" | wc -l`
# create buildcheck directory:
if [[ -d /tmp/aur-buildcheck-$$ ]]; then
	rm -rf /tmp/aur-buildcheck-$$ || return 1
fi
mkdir /tmp/aur-buildcheck-$$
cd /tmp/aur-buildcheck-$$
# run through the packages:
I=1
for pkg in $(echo $PACKAGES); do
	buildcheck $pkg
	STATUS=$?
	if [[ $STATUS -eq 0 ]]; then
		if [[ `echo -n "$@" | wc -c` -eq 0 ]]; then
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") DONE: "$pkg >> $LOGFILE
		else
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") DONE: "$pkg" ("$@")" >> $LOGFILE
		fi
	elif [[ $STATUS -eq 2 ]]; then
		if [[ `echo -n "$@" | wc -c` -eq 0 ]]; then
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") ARCH: "$pkg >> $LOGFILE
		else
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") ARCH: "$pkg" ("$@")" >> $LOGFILE
		fi
	else
		if [[ `echo -n "$@" | wc -c` -eq 0 ]]; then
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") FAIL: "$pkg >> $LOGFILE
		else
			echo "`date` ("`printf '%03d' $I`"/"`printf '%03d' $PKGNUM`") FAIL: "$pkg" ("$@")" >> $LOGFILE
		fi
	fi
	I=`expr $I + 1`
done
# clean up:
rm -rf /tmp/aur-buildcheck-$$
