#!/bin/bash

## ----------------------- temp-graph.sh ----------------------- ##
# Plots CPU temperature data (or any simple time-stamped data)    #
# using gnuplot in console-only mode.                             #
# Partially based on:                                             #
# https://github.com/Apache-Labor/labor/blob/master/bin/arbigraph #
#                                                                 #
#   Version 1.0 2019-10-28 (non-interactive)                      #
#   Version 1.1 2020-02-07 (fixed terminal size)                  #
#   Version 1.2 2021-08-13 (auto detect terminal width)           #
#   License: GPLv2                              #
## ------------------------------------------------------------- ##

## Variables and settings
DATA_FILE='/var/log/temp-monitor/temp-data.csv'
GNUPLOT="$(which gnuplot)"

GP_TERM_TYPE="dumb"
TERM_COLUMNS=$(tput cols)
TERM_ROWS=24
GP_TIMEFMT="'%Y-%m-%d %H:%M'"
GP_FMTX="'%H:%M'"
GP_XCOLUMN="1"
GP_YCOLUMN="3"
GP_LINESTYLE="lines"
GP_PLOT_TITLE="''"
GP_GRAPH_TITLE="'CPU Temp (°C)'"

START_DATE=$(date +%F -d "-1 day")
END_DATE=$(date +%F)
START_TIME=$(date +%R)
END_TIME=$START_TIME


function show_usage {
  echo "
    Usage: $(basename $0)
    [-x x column]
    [-y y column]
    [-r term size rows]
    [-c term size columns]
    [-d start date]
    [-t start time]
    [-D end date]
    [-T end time]
    [-f data file]
    [-l graph title]
    "
}

# Get command line options. Those not given on the
# command line retain their default value
while getopts "x:y:r:c:d:t:D:T:f:l:h" opt
do
  case $opt in
    x) GP_XCOLUMN=$OPTARG ;;
    y) GP_YCOLUMN=$OPTARG ;;
    r) TERM_ROWS=$OPTARG ;;
    c) TERM_COLUMNS=$OPTARG ;;
    d) START_DATE=$OPTARG ;;
    t) START_TIME=$OPTARG ;;
    D) END_DATE=$OPTARG ;;
    T) END_TIME=$OPTARG ;;
    f) DATA_FILE=$OPTARG ;;
    l) GP_GRAPH_TITLE=$OPTARG ;;
    h) show_usage ; exit 0 ;;
    *) show_usage ; exit 1 ;;
  esac
done

GP_XRANGE='[''"'"$START_DATE $START_TIME"'"':'"'"$END_DATE $END_TIME"'"'']' # ugly, but works
GP_TERM_SIZE=$TERM_COLUMNS,$TERM_ROWS

# Send commands to gnuplot using a here document
$GNUPLOT <<EOH
  set terminal $GP_TERM_TYPE $GP_TERM_SIZE
  set xdata time
  set timefmt $GP_TIMEFMT
  set format x $GP_FMTX
  set xrange $GP_XRANGE
  set title $GP_GRAPH_TITLE
  plot "$DATA_FILE" using $GP_XCOLUMN:$GP_YCOLUMN with $GP_LINESTYLE title $GP_PLOT_TITLE
EOH
