prefix=/usr
sbindir=$(prefix)/sbin
libexecdir=$(prefix)/libexec
sysconfdir=/etc
localstatedir=/var
unitdir=$(prefix)/lib/systemd/system

VERSION = 1.8.0

_default:
	@echo "Nothing to make. Try make dist"

install:
	#
	# Install executables
	#
	install -d $(DESTDIR)$(sbindir)/
	install -d $(DESTDIR)$(libexecdir)/
	install -d -m 0700 $(DESTDIR)$(libexecdir)/osg-cleanup/
	install -m 0700 sbin/osg-cleanup $(DESTDIR)$(sbindir)/
	install -m 0700 libexec/clean-globus-tmp $(DESTDIR)$(libexecdir)/osg-cleanup/
	install -m 0700 libexec/clean-user-dirs $(DESTDIR)$(libexecdir)/osg-cleanup/
	install -m 0700 libexec/clean-globus-seg $(DESTDIR)$(libexecdir)/osg-cleanup/
	#
	# Install configuration
	#
	install -d $(DESTDIR)$(sysconfdir)/osg/
	install -m 0600 etc/osg-cleanup.conf $(DESTDIR)$(sysconfdir)/osg/
	#
	# Install the init script and cron job or systemd service file and timer
	#
	if which systemctl > /dev/null 2>&1; then \
		install -d $(DESTDIR)$(unitdir); \
		install -m 0644 systemd/osg-cleanup.service $(DESTDIR)$(unitdir)/osg-cleanup.service; \
		install -m 0644 systemd/osg-cleanup.timer $(DESTDIR)$(unitdir)/osg-cleanup.timer; \
	else \
		install -d $(DESTDIR)$(sysconfdir)/rc.d/init.d/; \
		install -d $(DESTDIR)$(sysconfdir)/cron.d/; \
		install -m 755 init.d/osg-cleanup-cron $(DESTDIR)$(sysconfdir)/rc.d/init.d/; \
		install -m 644 cron.d/osg-cleanup $(DESTDIR)$(sysconfdir)/cron.d/; \
	fi
	#
	# Log dir and rotation
	#
	install -d $(DESTDIR)$(localstatedir)/log/osg
	install -d $(DESTDIR)$(sysconfdir)/logrotate.d
	install -m 0644 logrotate/osg-cleanup.logrotate $(DESTDIR)$(sysconfdir)/logrotate.d/osg-cleanup

clean:
	-rm -fr osg-cleanup-*

dist:
	git archive --prefix=osg-cleanup-$(VERSION)/ -o osg-cleanup-$(VERSION).tar.gz HEAD

.PHONY: _default clean dist install
