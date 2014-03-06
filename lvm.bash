#!/bin/bash
if [ "$(id -u)" != "0" ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

TOP_DIR=$(cd $(dirname "$0") && pwd)
if [[ ! -r $TOP_DIR/fairc ]]; then
log_error $LINENO "missing $TOP_DIR/fairc "
fi
source $TOP_DIR/fairc
DEBUG=0
while getopts "hp:g:H:n:m:L:d:vVD" OPTION; do
case "$OPTION" in
h)
	usage
	exit 0
	;;
p)
	KEY_FILE="$OPTARG"
	;;
g)
	NAME_VGROUP="$OPTARG"
	;;
H)
	HOST="$OPTARG"
        ;;
n)
	NUM_MOUNT_POINTS="$OPTARG"
        ;;
m)
	NAME_MOUNT_POINTS="$OPTARG"
        ;;
L)
	LOG_SIZE="$OPTARG"
	;;
d)
	DEVICE_NAMES="$OPTARG"
	;;
v)
	VERBOSE=1
	;;
V)
	display_version
	;;	
D)
	DEBUG=1
        ;;
\?)
	cho "Invalid option: -"$OPTARG"" >&2
	usage
	exit 1
	;;
:)
        usage
        exit 1
        ;;
esac
done
ECHO=""
# If NUM_MOUNT_POINTS is not set, default to 3
#: ${NUM_MOUNT_POINTS:="3"}
NUM_MOUNT_POINTS=${NUM_MOUNT_POINTS:-"3"}
NAME_MOUNT_POINTS=${NAME_MOUNT_POINTS:-"ora"}
HOST=${HOST:-"localhost"}
VG_GROUP_NAME=${VG_GROUP_NAME:-"vg00"}
ENVIRONMENT=${ENVIRONMENT:-_default}
FS_TYPE=${FS_TYPE:-"ext4"}
DEVICE_NAMES=${DEVICE_NMAES:-"/dev/sdb /dev/sdc"}
PKGS=${PKGS:-"lvm2 lvm2-libs"}
[ $DEBUG -ge 1 ] && ECHO="echo "
for pkgs in ${PKGS}
do
	if ! verify_package_exists ${pkgs};
	then
		echo "Package ${pkgs} was not installed successfully. Trying to reinstall..."
		yum -y install ${pkgs}
	fi
done
[ `vgdisplay | grep ${VG_GROUP_NAME}|wc -l` -gt 0 ] && { log_error $LINENO "$VG_GROUP_NAME exist. Abort!"; exit 1; }
#Create a volume group
[ -f /sbin/vgcreate ] && ${ECHO} /sbin/vgcreate ${VG_GROUP_NAME} ${DEVICE_NAMES}
[ $? -ne 0 ] && { echo "Failed: /sbin/vgcreate ${VG_GROUP_NAME} ${DEVICE_NAMES}"; exit 1; }
STRIPES=`echo ${DEVICE_NAMES}| wc -w`
if  [[ ${NAME_MOUNT_POINTS} =~ .*ora.* || ${NAME_MOUNT_POINTS} =~ .*Ora.* || ${NAME_MOUNT_POINTS} =~ .*database.* || ${NAME_MOUNT_POINTS} =~ .*db.* ]]
then
	if [ $LOG_SIZE ]; then
		[ -f /sbin/lvcreate ] && ${ECHO} /sbin/lvcreate -l ${LOG_SIZE} -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_log ${VG_GROUP_NAME}
		[ $? -ne 0 ] && { log_error $LINENO " /sbin/lvcreate -l ${LOG_SIZE} -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_log ${VG_GROUP_NAME}"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_log; }
	else
		[ -f /sbin/lvcreate ] && ${ECHO} /sbin/lvcreate -l 2%VG -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_log ${VG_GROUP_NAME}
		[ $? -ne 0 ] && { log_error $LINENO " /sbin/lvcreate -l 2%VG -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_log ${VG_GROUP_NAME}"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_log; }
	fi
	[ -f /sbin/mkfs ] && ${ECHO} /sbin/mkfs -t ${FS_TYPE} /dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_log
	[ $? -ne 0 ] && { log_error $LINENO " mkfs -t ${FS_TYPE} /dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_log"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_log; }
	[[ `grep ${NAME_MOUNT_POINTS}_log /etc/fstab | wc -l` -lt 1 && ! ${DEBUG} ]] && echo "/dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_log	/${NAME_MOUNT_POINTS}_log  ext4 noatime,nodiratime 0 2" >> /etc/fstab
	[ -f /bin/mkdir ] && ${ECHO} /bin/mkdir -p /${NAME_MOUNT_POINTS}_log
fi
INDEX=0
while [ ${INDEX} -lt ${NUM_MOUNT_POINTS} ]
do
	let SPACE="100*1/(${NUM_MOUNT_POINTS}-${INDEX})"
	#create lvcreate
	INDEXX=${INDEX}
	[ $INDEX -lt 10 ] && INDEXX=0${INDEX}
	let NN="${NUM_MOUNT_POINTS}-1"
	[ ${INDEX} -eq  ${NN} ] && STRIPES=1
	[ -f /sbin/lvcreate ] && ${ECHO} /sbin/lvcreate -l ${SPACE}%FREE -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_${INDEXX} ${VG_GROUP_NAME}
	[ $? -ne 0 ] && { log_error $LINENO " /sbin/lvcreate -l ${SPACE}%FREE -i ${STRIPES} -n ${NAME_MOUNT_POINTS}_${INDEXX} ${VG_GROUP_NAME}"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_${INDEXX}; }
	#mkfs -t ext4
	[ -f /sbin/mkfs ] && ${ECHO} /sbin/mkfs -t ${FS_TYPE} /dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_${INDEXX}
	[ $? -ne 0 ] && { log_error $LINENO " mkfs -t ${FS_TYPE} /dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_${INDEXX}"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_${INDEXX}; }
	#update /etc/fstab
	[[ `grep ${NAME_MOUNT_POINTS}_${INDEXX} /etc/fstab | wc -l` -lt 1 && ! ${DEBUG} ]] && echo "/dev/${VG_GROUP_NAME}/${NAME_MOUNT_POINTS}_${INDEXX}	/${NAME_MOUNT_POINTS}_${INDEXX}	ext4 noatime,nodiratime 0 2" >> /etc/fstab
	#mount 
	[ -f /bin/mkdir ] && ${ECHO} /bin/mkdir -p /${NAME_MOUNT_POINTS}_${INDEXX}
	#INDEX=$[${INDEX}+1]
	INDEX=$((INDEX+1))
done
[ -f /bin/mount ] && ${ECHO} /bin/mount -all
[ $? -ne 0 ] && { log_error $LINENO " /bin/mount -all"; roll_back ${VG_GROUP_NAME} ${NAME_MOUNT_POINTS}_${INDEXX}; }
