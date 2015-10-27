#! /bin/bash

#if [ $# -ne 7 ]
#then
#  echo "Usage: `basename $0` {dssat input} {dssat output}"
#  exit -1
#fi

inputfile=$1
pdfoutput=$2

count=0
while read line
do
data=`echo $line|awk '{ print $1 }'`
if [ -n "$data" ]; then
cp $data $PWD/$count.csv
count=$count+1
fi
done < "$inputfile"

command -V R >/dev/null 2>&1 || { echo >&2 " 'R' is required by this tool was not found on past";exit 1;}

INSTALL_DIR=/mnt/galaxyTools/hisCDF/1.0.0
hiscdf=$INSTALL_DIR/hiscdf.r

xvfb-run R --no-save --vanilla --slave --args $PWD $pdfoutput< $hiscdf

exit
