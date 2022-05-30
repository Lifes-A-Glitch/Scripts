#!/usr/bin/env bash

CWD=$(dirname "$0")

# This file should contain: IDRAC_PASSWORD="YOUR_PASSWORD"
. ${CWD}/fancontrol.env

IDRAC_HOST="idrac.yourdomain.com"
IDRAC_USER="root"
IPMI_CMD="ipmitool -I lanplus -H ${IDRAC_HOST} -U ${IDRAC_USER} -P ${IDRAC_PASSWORD}"
TEMP_THRESHOLD="55"
TMP_FILE="${CWD}/fancontrol.lock"
TMP_FILE_THRESHOLD="7200"
AVG_TEMP=$(${IPMI_CMD} sdr type temperature | awk '/0[E|F]h/ { total +=$9; count++ } END { print int(total/count) }' 2>/dev/null)
AVG_TEMP=${AVG_TEMP:-0}

function log() {
    echo "[$(date +'%Y-%m-%d %T')] $1"
}

function rm_lock() {
    rm -f ${TMP_FILE} # Remove the lock, we might lower the fans next invocation
}

function set_fan_speed() {
    # PERCENT:RPM 10:3300 20:4500 30:6500 40:8000 50:9500 60:10000 70:13000 80:15000 90:16000
    log "Setting fan speed to ${1}%"
    ${IPMI_CMD} raw 0x30 0x30 0x02 0xff $(printf '0x%x' ${1}) > /dev/null 2>&1
}

log "Current temperature ${AVG_TEMP}C"

# Remove the lockfile if the system just booted or the lockfile is "old".
# This prevents getting stuck in dynamic fan control mode after an reboot or iDRAC resets
if [[ ( $(awk '{print int($1)}' /proc/uptime) -lt 600 ) || ( -f ${TMP_FILE} && $(($(date +%s) - $(date +%s -r ${TMP_FILE}))) -gt ${TMP_FILE_THRESHOLD} ) ]]; then
    log "Removing stale lock file"
    rm_lock

    # "3rd Party" PCIe cards like my LSI flashed H310 Mini make for loud fans
    log "Disabling Third-Party PCIe Cooling Response"
    ${IPMI_CMD} raw 0x30 0xce 0x00 0x16 0x05 0x00 0x00 0x00 0x05 0x00 0x01 0x00 0x00 > /dev/null 2>&1
fi

if [[ $AVG_TEMP -gt $(($TEMP_THRESHOLD + 15)) ]]; then
    rm_lock
    log "Enabling dynamic fan control"
    ${IPMI_CMD} raw 0x30 0x30 0x01 0x01 > /dev/null 2>&1
elif [[ $AVG_TEMP -gt $TEMP_THRESHOLD ]]; then
    rm_lock
    set_fan_speed 30
elif [[ ! -f "${TMP_FILE}" ]]; then
    log "Disabling dynamic fan control"
    ${IPMI_CMD} raw 0x30 0x30 0x01 0x00 > /dev/null 2>&1
    set_fan_speed 20
    touch ${TMP_FILE} # Create a temp file to prevent unecessary operations
fi
