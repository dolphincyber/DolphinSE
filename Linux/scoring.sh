#!/bin/bash
. conf.sh

prevVulns=$(cat assets/previous.txt)
vulns=0
function checks {
    if [ $vuln1 == "true" ]; then
        vulns=$(( $vulns + 1 ))
    fi
    echo $vulns > ./assets/previous.txt
}

# function alert {
#     if [ "$vulns" -gt "$prevVulns" ]; then
#         rhythmbox-client --play ./assets/mp3/gain.mp3
#         notify-send 'DolphinSE' 'You gained points!'
#     elif [ "$vulns" -lt "$prevVulns" ]; then
#         rhythmbox-client --play ./assets/mp3/warn.mp3
#         notify-send 'DolphinSE' 'You lost points!'
#     fi
# }

checks
#alert