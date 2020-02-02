** HOW TO **

Scripts should be run in this order:

1 - sincronizza.sh

  Synchronizes the FITS archive on the Windows machine where we manage the telescope with the RaspberryPI making a copy of the missing files

2 - fits2csv.sh

  Extracts the FITS HEADERS from the images and collect them on csv files divided per year.

2a - The ARA website downloads daily these csv files and save into its DB the values.

3 - hardlinks.sh

  Reads the csv files produced by ARA website and create hard links for each FIT naming it as the id where its header is stored in the ARA website.
  CSV files are generated on the fly by calling a special url via wget

  e.g. 2019-02-30-52Cign.fit --> header is saved with progressive id 3267 in the ara website --> 3267.fit

4 - awsync.sh

  Finally, this script upload the files on an S3 bucket
