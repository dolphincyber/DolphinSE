#!/bin/bash

function packageInstalled {
	local pkg="$1"
	local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    if dpkg -s "$pkg" > /dev/null 2>&1; then
		ret="true"
	fi
    echo "$ret"
    echo "$message"
}

function packageInstalledNot {
	local pkg="$1"
	local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    if dpkg -s "$pkg" > /dev/null 2>&1; then
		ret="false"
	fi
    echo "$ret"
    echo "$message"
}

function serviceUp {
	local svc="$1"
	local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
	status=$(systemctl is-active "$svc") 
	if [ "$status" == "active" ]; then
		ret="true"
	elif [ "$status" == "inactive" ]; then
		ret="false"
	else 
		status=$(service "$svc" status)
		if [[ "$status" =~ "is running" ]]; then
			ret="true"
		else 
			status=$(service --status-all 2>/dev/null | grep "$svc")
			if [[ "$status" =~ " [ + ] " ]]; then
				ret="true"
			fi
		fi
	fi
	echo "$ret"
    echo "$message"
}

function serviceUpNot {
	local svc="$1"
	local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
	status=$(systemctl is-active "$svc") 
	if [ "$status" == "active" ]; then
		ret="false"
	elif [ "$status" == "inactive" ]; then
		ret="true"
	else 
		status=$(service "$svc" status)
		if [[ "$status" =~ "is running" ]]; then
			ret="false"
		else 
			# check with --status-all
			status=$(service --status-all 2>/dev/null | grep "$svc")
			if [[ "$status" =~ " [ + ] " ]]; then
				ret="false"
			fi
		fi
	fi
	echo "$ret"
    echo "$message"
}

function userExists {
    local user=$1
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(grep "$user:x:" /etc/passwd)
    if $exists; then
        ret "true"
    fi
    echo "$ret"
    echo "$message"
}

function userExistsNot {
    local user=$1
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(grep "$user:x:" /etc/passwd)
    if $exists; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function userInGroup {
    local user=$1
    local group=$2
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(grep -E "$group:x:[0-9]+:?+$user?+" /etc/passwd)
    if $exists; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function userInGroupNot {
    local user=$1
    local group=$2
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(grep -E "$group:x:[0-9]+:?+$user?+" /etc/passwd)
    if $exists; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function firewallUp {
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    ufw status | while read line; do
        if [ "$line" == "Status: active" ]; then
            ret="true"
        fi
    done
    echo "$ret"
    echo "$message"
}

function firewallUpNot {
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    ufw status | while read line; do
        if [ "$line" == "Status: active" ]; then
            ret="false"
        fi
    done
    echo "$ret"
    echo "$message"
}

function passwordChanged {
    local user=$1
    local time=$2
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    chage -l $user | while read line; do
        if [ "$line" =~ "Last password change : $time" ]; then
            ret="true"
        fi
    done
    echo "$ret"
    echo "$message"
}

function passwordChangedNot {
    local user=$1
    local time=$2
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    chage -l $user | while read line; do
        if [ "$line" =~ "Last password change : $time" ]; then
            ret="false"
        fi
    done
    echo "$ret"
    echo "$message"
}

function guestDisabledLDM {
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    disabled=$(grep -iE "allow-guest.?+=.?+false" /etc/lightdm/lightdm.conf)
    if $disabled; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function guestDisabledLDMNot {
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    disabled=$(grep -iE "allow-guest.?+=.?+false" /etc/lightdm/lightdm.conf)
    if $disabled; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function kernelVersion {
    local wantVer=$1
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    curVer=$(uname -r)
    if [ "$curVer" == "$wantVer" ]; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function autoCheckUpdatesEnabled {
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    check=$(grep -E '.*?APT::Periodic::Update-Package-Lists.*"1"' /etc/apt/apt.conf.d/20auto-upgrades)
    if $check; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function permissionIs {
    local package=$1
    local permission=$2
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    octal=$(stat -c "%a %n" | grep -E "[0-9]+")
    if [ "$octal" == "$permission" ]; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function permissionIsNot {
    local file=$1
    local permission=$2
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    octal=$(stat -c "%a %n" $file | grep -E "[0-9]+")
    if [ "$octal" == "$permission" ]; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function firefoxSetting {
    local method=$1 # user_pref or lockPref
    local key=$2 
    local value=$3
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    find /home -type f -name prefs.js | while read file; do
        valueSet=$(grep -E ".*?$method.*?\(.*?$key.*?,.*?$value.*?\).*?;" $file)
        if valueSet; then 
            ret="true"
            return
        fi
    done
    echo "$ret"
    echo "$message"
}

function firefoxSettingNot {
    local method=$1 # user_pref or lockPref
    local key=$2 
    local value=$3
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    find /home -type f -name prefs.js | while read file; do
        valueSet=$(grep -E ".*?$method.*?\(.*?$key.*?,.*?$value.*?\).*?;" $file)
        if valueSet; then 
            ret="false"
            return
        fi
    done
    echo "$ret"
    echo "$message"
}

function pathExists {
    local path=$1
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(find $path)
    if exists; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function pathExistsNot {
    local path=$1
    local ret="true"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(find $path)
    if exists; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function fileContains {
    local contains=$1
    local file=$2
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    exists=$(grep -E "$contains" $file)
    if $exists; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}

function fileContainsNot {
    local contains=$1
    local file=$2
    local ret=$ftrue
    exists=$(grep -E "$contains" $file)
    if $exists; then
        ret="false"
    fi
    echo "$ret"
    echo "$message"
}

function fileEquals {
    local ogHash=$1
    local file=$2
    local ret="false"
    local message=$4
    if [ "$message" == "" ]; then
        message="Vulnerablilty check passed"
    fi
    hash=$(md5sum $file | grep -E "[0-9]+")
    if [ "$hash" == "$ogHash" ]; then
        ret="true"
    fi
    echo "$ret"
    echo "$message"
}