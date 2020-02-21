#!/bin/bash

source .env
nomeprogramma=hardlinks
logfile=$logfolder/$nomeprogramma
mypidfile=$pidfolder/$nomeprogramma.pid

if [ -f $mypidfile ]; then
  echo "$nomeprogramma in esecuzione" > $logfile
  exit 1;
fi

# Could add check for existence of mypidfile here if interlock is
# needed in the shell script itself.

# Ensure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT
echo $fitsheaders
echo $arasite
wget -O $logfolder/$fitsheaders $arasite
while IFS=, read col1 col2; do
  if [ ! -f "$dst/$col1" ] && [ -f "$image/$col2" ]; then
    echo $col1
    echo $col2
    ln -f "$image/$col2" "$dst/$col1"
  fi
done < $logfolder/$fitsheaders
fine=`date +%s`
echo "Operazione eseguita in $(($fine-$inizio)) secondi" >> $logfile
