#!/bin/sh
set -e
#set -x

usage () {
    cat <<EOF
Usage: $0 [-v|--verbose] [-h|--help] [-f|--from "dirs on camera"] [-t|--to "backup location"] camera_ip
EOF
}

unset verbose
unset camera
unset backup_dir
#check these dirs for any new files
dirs="evt_rec manual_rec parking_rec"
while [ $# -gt 1 ]; do
    case $1 in
        -v|--verbose)
            verbose=1
            ;;
        -h|--help)
            usage
            ;;
        -f|--from)
            dirs=$2
            shift
            ;;
        -t|--to)
            backup_dir=$2
            shift
            ;;
        -*)
            echo "Unkown opt '$1'"
            usage
            exit 1
            ;;
    esac
    shift
done

if [ $# -ne 1 ]; then
    echo "Missing camera_ip arg"
    usage
    exit 1
fi

#ip address or host name of the camera
camera="$1"

if [ -z "$backup_dir" ]; then
    backup_dir="~/${camera}/"
    echo "Destination dir not specified, backing up to ${backup_dir}"
fi

cd ${backup_dir}

#ftp port to start on the camera
ftp_port=2121

log () {
    if [ -n "$verbose" ]; then
        echo $@
    fi
}

#use fping to see if the camera exists
if ! fping -c1 -q "$camera" 2> /dev/null; then
    log "$camera not found, exiting"
    # for running in cron, just return 0 if the camera isn't on the network
    exit 0
fi

#ok, it's connected, pull some footage then
#there are a bunch of ways to do this, easiest is probably starting an ftp server

if ! nc -z "$camera" $ftp_port; then
    log "Starting ftpd server on $camera..."
    #note the -w flag to ftpd allows you to delete files on the remote end
    set +e
    {
        sleep 1;
        echo "root";
        echo "start-stop-daemon -S --quiet --pidfile /var/run/ftpd.pid --exec /usr/bin/tcpsvd --make-pidfile --background -- -vE 0.0.0.0 ${ftp_port} /usr/sbin/ftpd -w /tmp/SD0";
        sleep 1;
    } | telnet "$camera" > /dev/null 2>&1
    set -e
fi

#now make sure the ftp server is up
if ! nc -z "$camera" $ftp_port; then
    echo "Could not launch ftpd on $camera, exiting"
    exit 1
fi

# common ncftp options
# user: root, no pass, port from above
# -DD delete files after transfer
# -R recursive
# -T do not tar a dir
#ncftpget does some weird stuff, turn some of it off because our busybox ftpd is super basic
# -o useCLNT=0,useMLST=0
ncftp_opts="-u root -p '' -P $ftp_port -o useCLNT=0,useMLST=0"

unset found_files
for dir in $dirs; do
    unset files
    files=`ncftpls $ncftp_opts ftp://${camera}/${dir}`
    if [ -n "$files" ]; then
        log "Found files in $dir:"
        for file in $files; do
            log $files
        done
        found_files=1
    else
        continue
    fi

    mkdir -p "${backup_dir}/${dir}"

    for file in $files; do
        ncftpget $ncftp_opts -V -DD ${camera} "${backup_dir}/${dir}" "${dir}/${file}"
    done
done

if [ -z "${found_files}" ]; then
    log "No files found"
fi