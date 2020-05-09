#!/bin/ksh

# Configuration

SCRIPT_HOME=/update/this/path # No trailing /
SSHKEY=/update/this/path/id_rsa
REMOTEUSER=user
REMOTEHOST=w.x.y.z # ip or hostname
REMOTEPATH=/update/this/path # No trailing /

# Error Checking

if [[ ! -d ${SCRIPT_HOME} ]]; then
        echo "The path you've specified as the script home doesn't exist."
        exit 1
fi

if [[ ! -d ${SCRIPT_HOME}/work ]]; then
        mkdir ${SCRIPT_HOME}/work
        exit 1
fi

if [[ ! -e ${SSHKEY} ]]; then
        echo "The ssh key you specified doesn't exist."
        exit 1
fi

# Main

HASH0=$( cat $SCRIPT_HOME/hash )
HASH1=$( sha256 /var/log/pflog.0.gz | awk '{ print $4 }' )

if [ "$HASH0" != "$HASH1" ]; then
        cp /var/log/pflog.0.gz ${SCRIPT_HOME}/work/
        gzip -d ${SCRIPT_HOME}/work/pflog.0.gz
        tcpdump -s 160  -n -e -ttt -r $SCRIPT_HOME/work/pflog.0 > $SCRIPT_HOME/work/pflog.log
	scp -q -i $SSHKEY ${SCRIPT_HOME}/work/pflog.log ${REMOTEUSER}@${REMOTEHOST}:${REMOTEPATH}/$( date +%F-%H-%M-%S )-$( hostname -s ).pf.log
        rm -f ${SCRIPT_HOME}/work/*
        sha256 /var/log/pflog.0.gz | awk '{ print $4 }' > ${SCRIPT_HOME}/hash 
fi
