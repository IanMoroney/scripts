#!/bin/bash

# Append/Update a configuration record in a file
#
# Usage example:
# /usr/local/bin/PropUpdate /etc/environment JAVA_HOME "/usr/lib/jvm/java-6-sun"
#
# Author Maxim Veksler <maxim@vekslers.org>
# Version 0.5-2010-07-27


EXPECTED_ARGS=3
E_BADARGS=3
E_BADFILE=4

if [[ $# -ne ${EXPECTED_ARGS} ]]; then
  echo "Usage: `basename $0` /path/to/config.conf ParameterName newValueText" >&2
  exit $E_BADARGS
fi

CONFIGURATION_FILE="$1"
CONFIGURATION_PARAMETER="$2"
CONFIGURATION_VALUE="$3"

if [[ ! -e "${CONFIGURATION_FILE}" ]]; then
        echo "Configuration file ${CONFIGURATION_FILE} does not exist" >&2
        exit $E_BADFILE
fi

if [[ ! -w "${CONFIGURATION_FILE}" ]]; then
        echo "Can't modify ${CONFIGURATION_FILE}" >&2
        exit $E_BADFILE
fi



#########################################
## Decide what parameter we are adding ##
#########################################
__param_found=0

# First check CONFIGURATION_PARAMETER supplied by use that contains "="
if [[ ${CONFIGURATION_PARAMETER} == *=* ]]; then
        # It should exist in the file, plain
        if grep -qE "^${CONFIGURATION_PARAMETER}" "${CONFIGURATION_FILE}"; then
                __param_found=1
                SUFFIX_REGEX='[[:space:]]*'
        fi
else
        # OK, sophisticated user, did not send "=" with the parameter...
        if grep -qE "^${CONFIGURATION_PARAMETER}[[:space:]]*=" "${CONFIGURATION_FILE}"; then
                # Let's check if such configuration with Parameter + "=" exists
                __param_found=1
                SUFFIX_REGEX='[[:space:]]*=[[:space:]]*'
        elif grep -qE "^${CONFIGURATION_PARAMETER}[[:space:]]+" "${CONFIGURATION_FILE}"; then
                # If such parameter exists, at all
                __param_found=1
                SUFFIX_REGEX='[[:space:]]\+'
        fi
fi


if [[ $__param_found == 1 ]]; then
        #echo sed -i "s|^\(${CONFIGURATION_PARAMETER}${SUFFIX_REGEX}\).*$|\1${CONFIGURATION_VALUE}|g" "${CONFIGURATION_FILE}"
        sed -i "s|^\(${CONFIGURATION_PARAMETER}${SUFFIX_REGEX}\).*$|\1${CONFIGURATION_VALUE}|g" "${CONFIGURATION_FILE}"

else
        if [[ ${CONFIGURATION_PARAMETER} == *=* ]]; then
                # Configuration parameter contains "=" in it's name, good just append
                echo "${CONFIGURATION_PARAMETER}${CONFIGURATION_VALUE}" >> "${CONFIGURATION_FILE}"
        else
                # Try to guess if this file is a "param = value" or "param value" type of file.
                if grep -qE "^[[:alnum:]]+[[:space:]]*=" "${CONFIGURATION_FILE}"; then
                        # Seems like a "param = value" type of file
                        echo "${CONFIGURATION_PARAMETER}=${CONFIGURATION_VALUE}" >> "${CONFIGURATION_FILE}"
                else
                        # Seems like a "param  value" type of file
                        echo "${CONFIGURATION_PARAMETER} ${CONFIGURATION_VALUE}" >> "${CONFIGURATION_FILE}"
                fi
        fi
fi

#cat $CONFIGURATION_FILE
