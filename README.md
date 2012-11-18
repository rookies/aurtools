aurtools
========

## aur-local-check.sh
Checks for all packages which are in no repository if they are in AUR and if you voted for them.

## buildcheck.sh
Builds all packages for a maintainer and writes a logfile.

### Needs
 * get-own-packages-raw.rb

### Needs Directories
 * ./packages/
 * ./packages/{i686,x86_64}

### Writes
 * buildcheck_$HOSTNAME.log
 * packages/$file-any.pkg.tar.$ext
 * packages/i686/$file-i686.pkg.tar.$ext
 * packages/x86_64/$file-x86_64.pkg.tar.$ext

### Arguments
 * see get-own-packages-raw.rb
Change:
 * see get-own-packages-raw.rb

## get-own-packages.rb
Lists all packages of a maintainer.

### Change
 * $maintainer

## get-own-packages-raw.rb
Lists all packages in raw format for buildcheck.sh.

### Change
 * $maintainer

### Arguments
 * --skip-out-of-date
  * Skip packages marked out of date.
 * --skip <comma-seperated-list>
  * Skip these packages. (e.g. --skip package1,package2,package3)
 * --only <comma-seperated-list>
  * Only search for these packages (e.g. --only package1,package2,package3)

## buildcheck-log-analyser.rb
Analyses the logfiles written by buildcheck.sh.

### Argument
 * path to the logfile

## localclean.sh
Cleanup an AUR directory. (deletes */src, */pkg, */*.src.tar.gz and */*.pkg.tar.xz)

### Change
  * AURDIR

## rm-old.sh
Deletes old packages in a directory. (if there is a newer one of the same name)

### Arguments
 * path to the directory with the packages (gets searched non-recursive)

### Needs
 * get-old.py

## get-old.py
Lists old packages in a directory.

### Arguments
 * path to the directory with the packages (gets searched non-recursive)

## update-repos.sh
Updates / creates repos for the files created by buildcheck.sh.

### Needs
 * rm-old.sh (-> get-old.py)

### Needs Directories
 * ./packages/
 * ./packages/{i686,x86_64}
