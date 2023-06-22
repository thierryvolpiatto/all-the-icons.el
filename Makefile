# makefile for all_the_icons package.

# Author: Thierry Volpiatto.
# Copyright (C) 2011~2022, Thierry Volpiatto, all rights reserved.

## This file is NOT part of GNU Emacs
##
## License
##
## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3, or (at your option)
## any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program; see the file COPYING.  If not, see
## <https://www.gnu.org/licenses/>.

# Emacs invocation
EMACS_COMMAND   := emacs

EMACS		:= $(EMACS_COMMAND) -Q -batch

EVAL := $(EMACS) --eval

PKGDIR := .

# Additional emacs loadpath
LOADPATH	:= -L .

# Files to compile
EL			:= $(sort $(wildcard all-the-icons*.el))

# Compiled files
ELC			:= $(EL:.el=.elc)


.PHONY: clean autoloads batch-compile install uninstall

all: clean autoloads batch-compile

$(ELC): %.elc: %.el
	$(EMACS) $(LOADPATH) -f batch-byte-compile $<

# Compile needed files
compile: $(ELC)

# Compile all files at once
batch-compile:
	$(EMACS) $(LOADPATH) -f batch-byte-compile $(EL)

# Remove all generated files
clean:
	rm -f $(ELC)

# Make autoloads file
autoloads:
	$(EVAL) "(progn (setq generated-autoload-file (expand-file-name \"all-the-icons-autoloads.el\" \"$(PKGDIR)\")) \
(setq backup-inhibited t) (update-directory-autoloads \"$(PKGDIR)\"))"

PREFIX=${HOME}/elisp/
DESTDIR=${PREFIX}all-the-icons/
DATADIR=${HOME}/share/all-the-icons/
install:
	test -d ${DESTDIR} || mkdir -p ${DESTDIR}
	rm -vf ${DESTDIR}*.elc
	rm -vf ${DESTDIR}*.el
	cp -vf *.el $(DESTDIR)
	cp -vf *.elc $(DESTDIR)
	cp -vf all-the-icons-autoloads.el $(DESTDIR)

install_svg:
	test -d ${DATADIR} || mkdir -p ${DATADIR}
	cp -vfr svg/ $(DATADIR)

install_all: install install_svg

uninstall:
	rm -vf ${DESTDIR}*.elc
	rm -vf ${DESTDIR}*.el
