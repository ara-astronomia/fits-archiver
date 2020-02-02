#!/bin/bash

source .env
nomeprogramma=awsync
logfile=$logfolder/$nomeprogramma
mypidfile=$pidfolder/$nomeprogramma.pid
bandwidth=80
#timeend=1500

if [ -f $mypidfile ]; then
  echo "programma in esecuzione" >> $logfile
  exit 1;
fi

# Could add check for existence of mypidfile here if interlock is
# needed in the shell script itself.

# Ensure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT

# Create a file with current PID to indicate that process is running.
echo $$ > "$mypidfile"
date_now=`date +%s`
#date_end=`date -d${timeend} +%s`
#timeout=$((${date_end}-${date_now}))
echo "Comincia l'upload" >> $logfile
#trickle -su $bandwidth
#timeout -s 1 ${timeout}s
aws s3 sync $dst $bucket --profile $aws_profile
fine=`date +%s`
echo "Operazione eseguita in $(($fine-$inizio)) secondi" >> $logfile
