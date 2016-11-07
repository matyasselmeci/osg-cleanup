VERSION = 1.8.0

_default:
	@echo "Nothing to make. Try make dist"

clean:
	-rm -fr osg-cleanup-*

dist:
	git archive --prefix=osg-cleanup-$(VERSION)/ -o osg-cleanup-$(VERSION).tar.gz HEAD

.PHONY: _default clean dist
