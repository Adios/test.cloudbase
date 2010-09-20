#!/bin/sh
# This software is licensed under the CC-GNU GPL.
# (http://creativecommons.org/licenses/GPL/2.0/)
#             Tzu-Hao Tsai (Adios)

. etc/test.conf
. etc/test.subr

daemon_required='acpt webdb'

daemon clean
daemon start `reverse ${daemon_required}`

# in case that serivces are not prepared yet.
sleep 5

for path in ${backup_subject}; do
	push_wd

	assert_ok ${backup_program} -backup ${path}
	assert_ok ${backup_program} -restore ${path}

	diff -r `realpath \`basename ${path}\`` ${path} || exit 1

	pop_wd clean
done

daemon stop

# vim:ts=8 sts=8 sw=8:
