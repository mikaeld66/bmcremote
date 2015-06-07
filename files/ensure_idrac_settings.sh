#!/bin/bash

#
# Script to make sure Dell iDRAC is configured as specified
#
# Arguments:
#   1) lockfile to use
#   2) adress of remote (iD)RAC
#   3) object to check/set
#   4) desired value of object
#
# Returns:
#   0:      OK
#   13:     OK but job request must be made
#   <X>:    Return code from racadm
#

# Defines
CMD="/opt/dell/srvadmin/sbin/racadm"
USER=root
PWD=calvin

# Argument "parsing" (FIXME)
lockfile=$1
host=$2
object=$3
setting=$4

#
# normal exit -> remove lock file
cleanup()  {
    rm $lockfile
}
trap cleanup 0

#
# abnormal exit handler
# only for debugging
#error()  {
#    local parent_lineno="$1"
#    local message="$2"
#    local code="${3:-1}"
#
#    if [[ -n "$message" ]]; then
#        echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
#    else
#        echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
#    fi
#    exit "${code}"
#}
#trap 'error ${LINENO}' ERR


# lock the "resource"
touch $lockfile


#
# get current value
#
# Extracts the last non-empty line
# Expects the result either as
#   <key>=<setting>
# or
#   <setting>
#
# Print setting to standard out
# Returns exit code from racadm
#
function get_current() {
    local setting=''
    local output

    mapfile -t output < <( $CMD -r $host -u $USER -p $PWD get $object )

    for ((i=$((${#output[@]}-1)); i >= 0; i--)) {
        local txt
        txt=${output[$i]//[$'\t\r']}
        if [[ -n "${txt}" ]]; then
            setting=${txt#*=}
            break
        fi
    }

    if [[ -z $setting ]]; then
        return 1
    fi
    echo $setting
    return 0
}


#
# set the required value
#
# Checks for indication of necessity job request
#   Prints message to standard out if found
#
# Returns exit status from racadm or '13' if job request has to be made
#
function set_value() {
    local output=$( $CMD -r $host -u $USER -p $PWD set $object $setting )
    if [ $? -gt 0 ]; then
        return $?
    fi
    if [[ $output =~ "To apply modified value, create a configuration job and reboot" ]]; then
        echo "Application necessary"
        return 13
    fi
    return 0
}

# first get current value
current=$(get_current)
exitcode=$?

# ... and if not equal to desired then set it
shopt -s nocasematch
if [[ ( $exitcode -eq 0 ) && ( "$current" != "$setting" ) ]]; then
    msg=$( set_value $host, $object, $setting )
    exitcode=$?

    if [[ -n $msg ]]; then
        echo $msg
    fi
fi

# return exit code from last run racadm command
exit $exitcode

