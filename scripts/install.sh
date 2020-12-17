#!/bin/sh
##-- valid sample /etc/exports (todo: maproot to uid per cluster)
# V4: /k8s/pv
#
#/k8s/pv/nfs1 10.0.0.61 -maproot=root
#/k8s/pv/nfs2 10.0.0.62 -maproot=root
##--
[ "${1}" != "up" ] && exit 1
. /etc/rc.conf
if [ ! -r ${cbsd_workdir}/etc/k8s.conf ]; then
	echo "no such ${cbsd_workdir}/etc/k8s.conf"
	exit 1
fi
. ${cbsd_workdir}/etc/k8s.conf
#set -o xtrace

if ! zpool list ${ZPOOL} > /dev/null 2>&1; then
	echo "no such zpool? ${ZPOOL}"
	exit 1
fi

if ! zfs list ${ZFS_K8S} > /dev/null 2>&1; then
	printf "create ${ZFS_K8S}..."
	if ! zfs create ${ZFS_K8S}; then
		echo "failed"
		exit 1
	else
		echo "ok"
	fi
fi

TMP_MNT=$( zfs get -Hp -o value mountpoint ${ZFS_K8S} 2>/dev/null )
if [ "${TMP_MNT}" != "${ZFS_K8S_MNT}" ]; then
	printf "set mountpoint for ${ZFS_K8S}: ${TMP_MNT} -> ${ZFS_K8S_MNT}"
	if ! zfs set mountpoint=${ZFS_K8S_MNT} ${ZFS_K8S}; then
		echo "failed"
		exit 1
	else
		zfs mount ${ZFS_K8S} > /dev/null 2>&1 || true
		echo "ok"
	fi
fi

if ! zfs list ${ZFS_K8S} > /dev/null 2>&1; then
	echo "no zfs: ${ZFS_K8S}"
	exit 1
fi

# PV
if ! zfs list ${ZFS_K8S_PV_ROOT} > /dev/null 2>&1; then
	printf "create ${ZFS_K8S_PV_ROOT}..."
	if ! zfs create ${ZFS_K8S_PV_ROOT}; then
		echo "failed"
		exit 1
	else
		echo "ok"
	fi
fi

TMP_MNT=$( zfs get -Hp -o value mountpoint ${ZFS_K8S_PV_ROOT} 2>/dev/null )
if [ "${TMP_MNT}" != "${ZFS_K8S_PV_ROOT_MNT}" ]; then
	printf "set mountpoint for ${ZFS_K8S_PV_ROOT}: ${TMP_MNT} -> ${ZFS_K8S_PV_ROOT_MNT}"
	if ! zfs set mountpoint=${ZFS_K8S_PV_ROOT_MNT} ${ZFS_K8S_PV_ROOT}; then
		echo "failed"
		exit 1
	else
		zfs mount ${ZFS_K8S_PV_ROOT} > /dev/null 2>&1 || true
		echo "ok"
	fi
fi

exit 0
