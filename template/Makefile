DOCS=__FILENAME__

TYPES=pdf html txt info db xml
all :
	@for x in ${DOCS}; \
    do \
        export TARGET=$$x; \
        PREREQ=''; \
        for y in ${TYPES}; \
        do \
            PREREQ="$${PREREQ} $${x}.$${y}"; \
        done; \
        export PREREQ; \
        ${MAKE} -s $$x; \
    done

${TARGET} : ${PREREQ}

include ../Mk/doc.mk
