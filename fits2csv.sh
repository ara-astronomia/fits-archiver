#!/bin/bash

pwd
source .env
nomeprogramma=fits2csv
logfile=$logfolder/$nomeprogramma
mypidfile=$pidfolder/$nomeprogramma.pid
# Could add check for existence of mypidfile here if interlock is
# needed in the shell script itself.
if [ -f $mypidfile ]; then
  echo "$nomeprogramma in esecuzione" > $logfile
  exit 1;
fi

# Ensure PID file is removed on program exit.
trap "rm -f -- '$mypidfile'" EXIT

for year in ${years[@]}; do
  csvname=$image/$year-fits.csv

  rm -f $csvname*
  python2 $db_fit_path/dbFits/src/fits.py -i $src/$year -o $csvname > $logfile
  gzip $csvname
done

fine=`date +%s`
echo "Operazione eseguita in $(($fine-$inizio)) secondi" >> $logfile
