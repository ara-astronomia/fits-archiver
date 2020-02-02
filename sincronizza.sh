#!/bin/bash

pwd
source .env
nomeprogramma=sincronizza
logfile=$logfolder/$nomeprogramma
mypidfile=$pidfolder/$nomeprogramma.pid

#echo $HOME >> logfile
if [ -f $mypidfile ]; then
  echo "$nomeprogramma è già in esecuzione" >> $logfile
  exit 1;
fi

# Could add check for existence of mypidfile here if interlock is
# needed in the shell script itself.

# Ensure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT

ping -c 3 $serverip > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "macchina windows spenta il $datan" >> $logfile
  exit 1;
fi
# Create a file with current PID to indicate that process is running.
echo $$ > "$mypidfile"

if [ ! -d $sambayear ]; then
echo "mount della  cartella condivisa in corso" >> $logfile
mount $sambashare >> $logfile
else
echo "cartella remota $sambashare già montata" >> $logfile
fi
if [ -d $sambayear ]; then
#echo $sambayear >> $logfile
#echo $image >> $logfile
rsync -avz --chmod=ugo=rwX $sambayear $image
echo "Effettuata copia file" >> $logfile
else
echo "cartella $sambayear non trovata" >> $logfile
fi
fine=`date +%s`
echo "Operazione eseguita in $(($fine-$inizio)) secondi il $datan" >> $logfile
