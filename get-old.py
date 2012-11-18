#!/usr/bin/python2
import sys, glob, os, string
from distutils.version import LooseVersion

pkgs_all = glob.glob(sys.argv[1] + "/*.pkg.tar.xz")
pkgs_new = []
pkgs_remove = []

for pkg in pkgs_all:
	pkg_ = list(os.path.basename(pkg))
	pkg_.reverse()
	pkg__ = "".join(pkg_)
	pkg_ = pkg__.split("-", 3)
	i = 0
	for tmp in pkg_:
		tmp = list(tmp)
		tmp.reverse()
		pkg_[i] = "".join(tmp)
		i += 1
	pkg_.reverse()
	found = False
	for pkg_new in pkgs_new:
		if pkg_new[0] == pkg_[0]:
			# package is already in pkg_new
			if LooseVersion(pkg_[1]) > LooseVersion(pkg_new[1]):
				# package is newer
				pkgs_new.remove(pkg_new)
				pkgs_remove.append(pkg_new)
				pkgs_new.append(pkg_)
			elif LooseVersion(pkg_[1]) < LooseVersion(pkg_new[1]):
				# package is older
				pkgs_remove.append(pkg_)
			elif LooseVersion(pkg_[1]) == LooseVersion(pkg_new[1]):
				# version is the same, compare revision
				if LooseVersion(pkg_[2]) > LooseVersion(pkg_new[2]):
					# package is newer
					pkgs_new.remove(pkg_new)
					pkgs_remove.append(pkg_new)
					pkgs_new.append(pkg_)
				else:
					# package is older
					pkgs_remove.append(pkg_)
			found = True
			break
	if not found:
		# package is not in pkg_new
		pkgs_new.append(pkg_)
for pkg in pkgs_remove:
	s = ""
	for p in pkg:
		if len(s) is 0:
			s += p
		else:
			s += "-" + p
	print (sys.argv[1] + "/" + s).replace("//", "/")
