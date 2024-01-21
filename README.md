
# bash scripts

Some random utility bash scripts.

### temp-graph.sh

Plots CPU temperature data (or any simple time-stamped data)
using `gnuplot` in console-only mode.<br>
Partially based on:<br>
https://github.com/Apache-Labor/labor/blob/master/bin/arbigraph

#### Usage

    temp-graph.sh
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
