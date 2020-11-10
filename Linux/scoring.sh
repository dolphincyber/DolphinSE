#!/bin/bash
. conf.sh

vulns=0
function checks {
    if [ $vuln1 == "false" ]; then
        vulns=$(( $vulns + 5 ))
    fi
    echo $vulns > ./assets/previous.txt
}

checks
exit