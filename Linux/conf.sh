#!/bin/bash
. checks.sh

function scoredVulns {
    vuln1=$(packageInstalled "chkrootkit", "Package chkrootkit has been installed")
}
exit