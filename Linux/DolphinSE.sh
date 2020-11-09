#!/bin/bash

. conf.sh
function checks {
    if [ "$vuln1" == "true" ]; then
        echo ("check.passed")
        echo $message
    else
        echo ("check.failed")
    fi
}

checks
exit