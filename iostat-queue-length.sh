#!/bin/bash
#
# iostat grapher. Note, in the following line the data
# points will start at field $4 for rrqm/s
#
# 2018-11-20 10:28:35 Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
# 2018-11-20 10:28:35 sdb               0.06    63.16   44.30  102.43     0.71    13.15   193.41     6.41   43.71    9.20   58.64   0.95  13.90

echo "usage: $0 <iostat.log> <disk name> <out.png>"
echo "procesing $1 for device $2, plotting $3"

cat $1 | grep "$2 " > dat.dat

gnuplot <<_EOF_
set terminal png
set output "$3"
set title "$2: Queue Size"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M\n%d/%m"
set xtics nomirror scale 3,2
set ylabel "Requests"
set samples 10
set term png size 1920,1080
plot "dat.dat" using 1:11 title "average queue length (avgqu-sz)" with lines
_EOF_

rm dat.dat
