VERSION = 1.7.2

_default:
	@echo "Nothing to make. Try make dist"

clean:
	rm -fr osg-cleanup-*

dist:
	mkdir -p osg-cleanup-$(VERSION)
	cp -pr etc/ libexec/ sbin/ init.d/ cron.d/ logrotate/ systemd/ osg-cleanup-$(VERSION)/
	tar zcf osg-cleanup-$(VERSION).tar.gz `find osg-cleanup-$(VERSION) ! -name *~ ! -name .#* ! -type d | grep -v '\.svn'`
	rm -fr osg-cleanup-$(VERSION)
