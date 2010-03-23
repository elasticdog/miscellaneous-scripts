#!/bin/bash

#
#            _                                 _
#   _ __ ___| |_ _ __ ___   __ _ _ __ __ _  __| | ___
#  | '__/ _ \ __| '__/ _ \ / _` | '__/ _` |/ _` |/ _ \
#  | | |  __/ |_| | | (_) | (_| | | | (_| | (_| |  __/
#  |_|  \___|\__|_|  \___/ \__, |_|  \__,_|\__,_|\___|
#                          |___/
#
# Removes all identities stored by the current user's ssh-agent. This will work
# regardless of whether or not $SSH_AUTH_SOCK is set in the environment prior
# to running.
#

##### Constants

E_NOTFOUND=69  # process not found exit code
E_OK=0         # successful termination exit code

BASENAME="${0##*/}"  # name of this script for error output


##### Functions

# exit with the given code and display a message if one was supplied
error_exit () {
	if [ $# -gt 1 ]; then
		echo "$BASENAME (ERROR ${1}) - $2" 1>&2
		exit $1
	else
		echo "$BASENAME (ERROR) - $1" 1>&2
		exit 1
	fi
}


##### Main

# if the ssh-agent socket location is not known, find it and store it appropriately
if [[ -z $SSH_AUTH_SOCK ]]; then
	agent_socket=$(lsof -Uac ssh-agent | grep /tmp/ | awk '{ print $NF }')
	[[ -z $agent_socket ]] && error_exit $E_NOTFOUND 'unable to find running ssh-agent'

	export SSH_AUTH_SOCK="$agent_socket"
fi

# delete all identities from the agent
ssh-add -D

exit $E_OK
