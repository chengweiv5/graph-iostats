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
set title "$2: Read/Write thoughput"
set xdata time
set timefmt "%Y-%m-%d %H:%M:%S"
set format x "%H:%M\n%d/%m"
set xtics nomirror scale 3,2
set ylabel "MBs"
set samples 10
plot "dat.dat" using 1:8 title "reads MB per sec (rMB/s)" with lines, \
"dat.dat" using 1:9 title "writes MB per sec (wMB/s)" with lines
_EOF_

rm dat.dat
