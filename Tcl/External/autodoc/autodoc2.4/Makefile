# Makefile for AutoDOC
# ----------------------------------
#
# AutoDOC 2.4, as of September 07, 2000
#
# (C) 1997 Andreas Kupries <a.kupries@westend.cm>
#
# ----------------------------------
# Some versions of make, like SGI's, use the following variable to
# determine which shell to use for executing commands:
SHELL =		/bin/sh

prefix		=	/usr/local
exec_prefix	=	/usr/local

# Directory to install the packages into
LIBDIR=${exec_prefix}/lib

# Directory to install the application into
BINDIR=${exec_prefix}/bin

# use this command to install the files
INSTALL=cp

# ----------------------------------
# below this line nothing should be modified

Applications	=	autodoc tkautodoc
Packages	=	lib
PKGDIR		=	$(LIBDIR)/AutoDoc2.4

# ----------------------------------

install:	install-lib install-bin

install-bin:
	for i in ${Applications};		\
	do 					\
		$(INSTALL) $$i ${BINDIR};	\
		chmod 755 ${BINDIR}/$$i;	\
	done

install-lib:
	echo "installing autodoc library..."
	-@mkdir           $(PKGDIR)
	@cd lib ; cp -r * $(PKGDIR)
	@cd               $(PKGDIR); rm *.cls ; chmod -R 644 * ; chmod 755 `find . -type d`

# ----------------------------------
# internal targets to aid development

refresh:
	cd lib ; gen_cls

full-refresh:
	cd lib ; gen_cls ; gen_idx ; gen_pkg AutoDoc 2.0 tclIndex

clean:
	cd lib ; clean_cls ; rm -f tclIndex clsIndex pkgIndex.tcl

