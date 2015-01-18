include Mk/defs.mk
DIRS=`for x in *; \
          do [ -d "$$x" ] && \
          echo "$$x " | sed -e "s/include//" \
                            -e "s/Mk//" \
                            -e "s/template//"; \
          done`

MAKEARGS=-s -C $$proj
RMACROS="PROJ=$$proj"
MAKECMD=${MAKE} ${MAKEARGS} ${RMACROS}
PRECMD=for proj in ${DIRS}; do ${ECHO_CMD}
RMAKE_DOC=${PRECMD} "$$proj: " && ${MAKECMD} ${TARGET}; done;
all:
	@export TARGET=all; ${RMAKE_DOC}
pdf:
	@export TARGET=pdf; ${RMAKE_DOC}
text:
	@export TARGET=text; ${RMAKE_DOC}
html:
	@export TARGET=html; ${RMAKE_DOC}
xml:
	@export TARGET=xml; ${RMAKE_DOC}
docbook:
	@export TARGET=docbook; ${RMAKE_DOC}
clean:
	@${PRECMD} "Cleaning $$proj: " && ${MAKECMD} clean; done;
tidy:
	@${PRECMD} "Tidying $$proj: " && ${MAKECMD} tidy; done;
package:
	@export dest=`echo $$TITLE | tr '[:upper:]' '[:lower:]' | \
						  tr '[:punct:]' '_' | tr -s '[:blank:]' '_'`; \
	[ ! -d $$dest ] && mkdir $$dest; \
	[ -z "$$AUTHOR" ] && export AUTHOR="No Author"; \
	[ -z "$$CATEGORY" ] && export CATEGORY="No Category"; \
	[ -z "$$SUBTITLE" ] && export SUBTITLE="No Subtitle"; \
	${M4_CMD} --define=__TITLE__="$$TITLE" \
			--define=__FILENAME__=$$dest \
			--define=__AUTHOR__="$$AUTHOR" \
			--define=__CATEGORY__="$$CATEGORY" \
			--define=__SUBTITLE__="$$SUBTITLE" \
			template/template.texi > $$dest/$$dest.texi; \
	cp template/splash.texi $$dest/$$dest-splash.texi; \
	${M4_CMD} --define=__FILENAME__=$$dest \
			template/Makefile > $$dest/Makefile
setup:
	${M4_CMD} --define=__ORGANIZATION__="$$ORG" \
			template/headings.texi > include/headings.texi
list:
	@${PRECMD} -n "Document: $$proj" && ${MAKECMD} list; done;
install:
	@${PRECMD} "Install all in $$proj: " && ${MAKECMD} install; done;
install-pdf:
	@${PRECMD} "Install PDF in $$proj: " && ${MAKECMD} install-pdf; done;
install-html:
	@${PRECMD} "Install HTML in $$proj: " && ${MAKECMD} install-html; done;
install-text:
	@${PRECMD} "Install text in $$proj: " && ${MAKECMD} install-text; done;
install-info:
	@${PRECMD} "Install info in $$proj: " && ${MAKECMD} install-info; done;
install-db:
	@${PRECMD} "Install Docbook in $$proj: " && ${MAKECMD} install-db; done;
install-xml:
	@${PRECMD} "Install XML in $$proj: " && ${MAKECMD} install-xml; done;
uninstall:
	@${PRECMD} "Uninstall $$proj: " && ${MAKECMD} uninstall; done; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/pdf; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/html; \
	echo "Removing ${INSTALL_DIR}/info/dir" && ${RM_CMD} ${INSTALL_DIR}/info/dir; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/info; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/text; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/db; \
	echo "Removing ${INSTALL_DIR}/pdf" && ${RMDIR_CMD} ${INSTALL_DIR}/xml; \
	echo "Removing ${INSTALL_DIR}"     && ${RMDIR_CMD} ${INSTALL_DIR};
