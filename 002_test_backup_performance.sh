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

	info "==$path=="
	pathinfo_stamp $path
	info ""

	benchmark ${backup_program} -backup $path
	benchmark ${backup_program} -restore $path

	# compare to svn.
	if [ -n "${svn_program}" ]; then
		svn_path="${svn_prefix}/`basename $path`"

		benchmark ${svn_program} import $path ${svn_path} -m 'import'
		benchmark ${svn_program} co ${svn_path} `basename $path`.svn

		assert_ok ${svn_program} rm ${svn_path} -m 'delete'
	fi

	# compare to rsync.
	if [ -n "${rsync_program}" ]; then
		benchmark ${rsync_program} -at $path ${rsync_path}
		benchmark ${rsync_program} -at ${rsync_path} `basename $path`.rsync

		assert_ok ssh ${rsync_ssh_host} rm -rf "${rsync_root}/*"
	fi

	pop_wd clean
done

cpu_stamp
memory_stamp

daemon stop

# vim:ts=8 sts=8 sw=8:
