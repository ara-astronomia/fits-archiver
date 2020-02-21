#!/bin/bash

pwd
source .env
nomeprogramma=sincronizza
logfile=$logfolder/$nomeprogramma
mypidfile=$pidfolder/$nomeprogramma.pid

#echo $HOME >> logfile
if [ -f $mypidfile ]; then
  echo "$nomeprogramma in esecuzione" >> $logfile
  exit 1;
fi

# Could add check for existence of mypidfile here if interlock is
# needed in the shell script itself.

# Ensure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT

ping -c 3 $ssh_ip > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "macchina windows spenta il $datan" >> $logfile
  exit 1;
fi
# Create a file with current PID to indicate that process is running.
echo $$ > "$mypidfile"

if [ -d $src ]; then
  sshpass -p "$ssh_pwd" rsync -avzs "$ssh_user@$ssh_ip:$ssh_path/$year" $src

  if [ $? -ne 0 ]; then
    echo "Errore rsync il $datan" >> $logfile
    exit 1;
  else
    echo "Effettuata copia file" >> $logfile
  fi
else
  echo "cartella $src non trovata" >> $logfile
fi
fine=`date +%s`
echo "Operazione eseguita in $(($fine-$inizio)) secondi il $datan" >> $logfile
