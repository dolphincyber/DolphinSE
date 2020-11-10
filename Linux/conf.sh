#!/bin/bash
. checks.sh

function scoredVulns {
    vuln1=$(packageInstalled "chkrootkit", "Package chkrootkit has been installed")
}

function checkVulns {
    echo "$vuln1"
}

scoredVulns