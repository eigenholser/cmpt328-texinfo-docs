include ../Mk/defs.mk
DATE=`date "+%A %B %d, %Y %T %Z"`
UPDATED= -echo "@set UPDATED `git log --pretty=format:"%ad" -1 $< || echo "No Timestamp Available"`" > $<.updated
makeinfo=  /usr/bin/makeinfo -P ../include
texi2pdf=  /usr/bin/texi2pdf -I ../include --quiet --pdf
cleanlist= for x in ${DOCS}; do ${ECHO_CMD} $$x.* | sed s/$$x.texi//; done
tidylist=  for x in ${DOCS}; do ${ECHO_CMD} $$x.* | sed -e s/$$x.texi// \
	                             -e s/$$x.css//   \
	                             -e s/$$x.html//  \
	                             -e s/$$x.txt//   \
	                             -e s/$$x.pdf//   \
	                             -e s/$$x.info//  \
	                             -e s/$$x.xml//   \
	                             -e s/$$x.db//;   \
								 done;
INSTALLCOMMAND=PREFIX=`pwd`; export PREFIX=$${PREFIX\#\#*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Copying $$x.$${DOCTYPE} to ${INSTALL_DIR}/$${DOCTYPE}/$${PREFIX}_$$x.$${DOCTYPE}"; \
		${INSTALL_CMD} -D $$x.$${DOCTYPE} ${INSTALL_DIR}/$${DOCTYPE}/$${PREFIX}_$$x.$${DOCTYPE}; \
	done;
UNINSTALLCOMMAND=PREFIX=`pwd`; export PREFIX=$${PREFIX\#\#*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Removing ${INSTALL_DIR}/$${DOCTYPE}/$${PREFIX}_$$x.$${DOCTYPE}"; \
		${RM_CMD} ${INSTALL_DIR}/$${DOCTYPE}/$${PREFIX}_$$x.$${DOCTYPE}; \
	done;
.SUFFIXES : .texi .info .pdf .html .txt .db .xml
.texi.pdf :
	@${UPDATED}; ${ECHO_CMD} "    Making PDF: $@" && ${texi2pdf} --batch $< > /dev/null && ${texi2pdf} --batch $< > /dev/null
.texi.html :
	@${UPDATED}; ${ECHO_CMD} "    Making HTML: $@" && \
	${makeinfo} --html --no-split --no-headers    \
	                   --css-include=../include/htmldoc.css \
	                   --output=$*.tmp $<; \
	cat $*.tmp | \
	sed -e 's/<body>/\<body>\<div class=\"page\">/' \
	-e 's/<\/body>/\<\/div>\<\/body>/' > $@; \
	rm $*.tmp
.texi.txt :
	@${UPDATED}; ${ECHO_CMD} "    Making Text: $@" && ${makeinfo} --plaintext --output $@ $<
.texi.info :
	@${UPDATED}; ${ECHO_CMD} "    Making info: $@" && ${makeinfo} $<
.texi.db :
	@${UPDATED}; ${ECHO_CMD} "    Making Docbook: $@" && ${makeinfo} --docbook --output $@ $<
.texi.xml :
	@${UPDATED}; ${ECHO_CMD} "    Making XML: $@" && ${makeinfo} --xml --output $@ $<
clean:
	@for item in `${cleanlist}`; do\
	  ${ECHO_CMD} "    Removing $$item"; \
	  rm -f $$item; \
	done;
list:
	@echo " [${DOCS}]";
tidy:
	@for item in `${tidylist}`; do\
	  ${ECHO_CMD} "    Removing $$item"; \
	  ${RM_CMD} $$item; \
	done
install: all install-pdf install-html install-text install-info install-db install-xml
install-pdf:
	@export DOCTYPE=pdf; ${INSTALLCOMMAND}
install-html:
	@export DOCTYPE=html; ${INSTALLCOMMAND}
install-text:
	@PREFIX=`pwd`; export PREFIX=$${PREFIX##*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Copying $$x.txt to ${INSTALL_DIR}/text/$${PREFIX}_$$x.txt"; \
		${INSTALL_CMD} -D $$x.txt ${INSTALL_DIR}/text/$${PREFIX}_$$x.txt; \
	done;
install-info:
	@PREFIX=`pwd`; export PREFIX=$${PREFIX##*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Copying $$x.info to ${INSTALL_DIR}/info/$${PREFIX}_$$x.info"; \
		${INSTALL_CMD} -D $$x.info ${INSTALL_DIR}/info/$${PREFIX}_$$x.info; \
		echo "    Installing $$x.info dir entry to ${INSTALL_DIR}/info/dir"; \
        ${INSTALLINFO_CMD} --info-dir=${INSTALL_DIR}/info --info-file=${INSTALL_DIR}/info/$${PREFIX}_$$x.info; \
	done;
install-db:
	@export DOCTYPE=db; ${INSTALLCOMMAND}
install-xml:
	@export DOCTYPE=xml; ${INSTALLCOMMAND}
uninstall: uninstall-pdf uninstall-html uninstall-text uninstall-info uninstall-db uninstall-xml
uninstall-pdf:
	@export DOCTYPE=pdf; ${UNINSTALLCOMMAND}
uninstall-html:
	@export DOCTYPE=html; ${UNINSTALLCOMMAND}
uninstall-text:
	@PREFIX=`pwd`; export PREFIX=$${PREFIX##*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Removing ${INSTALL_DIR}/text/$${PREFIX}_$$x.txt"; \
		${RM_CMD} ${INSTALL_DIR}/text/$${PREFIX}_$$x.txt; \
	done;
uninstall-info:
	@PREFIX=`pwd`; export PREFIX=$${PREFIX##*/}; for x in ${DOCS}; do \
        ${ECHO_CMD} "    Removing ${INSTALL_DIR}/info/$${PREFIX}_$$x.info"; \
		echo "    Removing $$x.info dir entry from info file ${INSTALL_DIR}/info/dir"; \
        ${INSTALLINFO_CMD} --delete --info-dir=${INSTALL_DIR}/info --info-file=${INSTALL_DIR}/info/$${PREFIX}_$$x.info; \
		${RM_CMD} ${INSTALL_DIR}/info/$${PREFIX}_$$x.info; \
	done;
uninstall-db:
	@export DOCTYPE=db; ${UNINSTALLCOMMAND}
uninstall-xml:
	@export DOCTYPE=xml; ${UNINSTALLCOMMAND}
