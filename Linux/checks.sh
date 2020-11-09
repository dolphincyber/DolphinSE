function packageInstalled {
	local pkg="$1"
	local ret=$false
    if dpkg -s "$pkg" > /dev/null 2>&1; then
		ret=$true
	fi
    echo $ret
}

function packageInstalledNot {
	local pkg="$1"
	local ret=$true
    if dpkg -s "$pkg" > /dev/null 2>&1; then
		ret=$false
	fi
    echo $ret
}

function serviceUp {
	local svc="$1"
	local ret=$false
	status=$(systemctl is-active "$svc") 
	if [ "$status" == "active" ]; then
		ret=$true
	elif [ "$status" == "inactive" ]; then
		ret=$false
	else 
		status=$(service "$svc" status)
		if [[ "$status" =~ "is running" ]]; then
			ret=$true
		else 
			status=$(service --status-all 2>/dev/null | grep "$svc")
			if [[ "$status" =~ " [ + ] " ]]; then
				ret=$true
			fi
		fi
	fi
	echo $ret
}

function serviceUpNot {
	local svc="$1"
	local ret=$true
	status=$(systemctl is-active "$svc") 
	if [ "$status" == "active" ]; then
		ret=$false
	elif [ "$status" == "inactive" ]; then
		ret=$true
	else 
		status=$(service "$svc" status)
		if [[ "$status" =~ "is running" ]]; then
			ret=$false
		else 
			# check with --status-all
			status=$(service --status-all 2>/dev/null | grep "$svc")
			if [[ "$status" =~ " [ + ] " ]]; then
				ret=$false
			fi
		fi
	fi
	echo $ret
}

function userExists {
    local user=$1
    local ret=$false
    exists=$(grep "$user:x:" /etc/passwd)
    if $exists; then
        ret $true
    fi
    echo=$ret
}

function userExistsNot {
    local user=$1
    local ret=$true
    exists=$(grep "$user:x:" /etc/passwd)
    if $exists; then
        ret=$false
    fi
    echo $ret
}

function userInGroup {
    local user=$1
    local group=$2
    local ret=$false
    exists=$(grep -E "$group:x:[0-9]+:?+$user?+" /etc/passwd)
    if $exists; then
        ret=$true
    fi
    echo $ret
}

function userInGroupNot {
    local user=$1
    local group=$2
    local ret=$true
    exists=$(grep -E "$group:x:[0-9]+:?+$user?+" /etc/passwd)
    if $exists; then
        ret=$false
    fi
    echo $ret
}

function firewallUp {
    local ret=$false
    ufw status | while read line; do
        if [ "$line" == "Status: active" ]; then
            ret=$true
        fi
    done
    echo $ret
}

function firewallUpNot {
    local ret=$true
    ufw status | while read line; do
        if [ "$line" == "Status: active" ]; then
            ret=$false
        fi
    done
    echo $ret
}

function passwordChanged {
    local user=$1
    local time=$2
    local ret=$false
    chage -l $user | while read line; do
        if [ "$line" =~ "Last password change : $time" ]; then
            ret=$true
        fi
    done
    echo $ret
}

function passwordChangedNot {
    local user=$1
    local time=$2
    local ret=$true
    chage -l $user | while read line; do
        if [ "$line" =~ "Last password change : $time" ]; then
            ret=$false
        fi
    done
    echo $ret
}

function guestDisabledLDM {
    local ret=$false
    disabled=$(grep -iE "allow-guest.?+=.?+false" /etc/lightdm/lightdm.conf)
    if $disabled; then
        ret=$true
    fi
    echo $ret
}

function guestDisabledLDMNot {
    local ret=$true
    disabled=$(grep -iE "allow-guest.?+=.?+false" /etc/lightdm/lightdm.conf)
    if $disabled; then
        ret=$false
    fi
    echo $ret
}

function kernelVersion {
    local wantVer=$1
    local ret=$false
    curVer=$(uname -r)
    if [ "$curVer" == "$wantVer" ]; then
        ret=$true
    fi
    echo $ret
}

function autoCheckUpdatesEnabled {
    local ret=$false
    check=$(grep -E '.*?APT::Periodic::Update-Package-Lists.*"1"' /etc/apt/apt.conf.d/20auto-upgrades)
    if $check; then
        ret=$true
    fi
    echo $ret
}

function permissionIs {
    local package=$1
    local permission=$2
    local ret=$false
    octal=$(stat -c "%a %n" | grep -E "[0-9]+")
    if [ "$octal" == "$permission" ]; then
        ret=$true
    fi
    echo $ret
}

function permissionIsNot {
    local package=$1
    local permission=$2
    local ret=$true
    octal=$(stat -c "%a %n" | grep -E "[0-9]+")
    if [ "$octal" == "$permission" ]; then
        ret=$false
    fi
    echo $ret
}

function firefoxSetting {
    local method=$1 # user_pref or lockPref
    local key=$2 
    local value=$3
    local ret=$false
    find /home -type f -name prefs.js | while read file; do
        valueSet=$(grep -E ".*?$method.*?\(.*?$key.*?,.*?$value.*?\).*?;" $file)
        if valueSet; then 
            ret=$true
            return
        fi
    done
    echo $ret
}

function firefoxSettingNot {
    local method=$1 # user_pref or lockPref
    local key=$2 
    local value=$3
    local ret=$true
    find /home -type f -name prefs.js | while read file; do
        valueSet=$(grep -E ".*?$method.*?\(.*?$key.*?,.*?$value.*?\).*?;" $file)
        if valueSet; then 
            ret=$false
            return
        fi
    done
    echo $ret
}

function pathExists {
    local path=$1
    local ret=$false
    exists=$(find $path)
    if exists; then
        ret=$true
    fi
    echo $ret
}

function pathExistsNot {
    local path=$1
    local ret=$true
    exists=$(find $path)
    if exists; then
        ret=$false
    fi
    echo $ret
}

function fileContains {
    local contains=$1
    local file=$2
    local ret=$false
    exists=$(grep -E "$contains" $file)
    if $exists; then
        ret=$true
    fi
    echo $ret
}

function fileContainsNot {
    local contains=$1
    local file=$2
    local ret=$ftrue
    exists=$(grep -E "$contains" $file)
    if $exists; then
        ret=$false
    fi
    echo $ret
}

function fileEquals {
    local ogHash=$1
    local file=$2
    local ret=$false
    hash=$(md5sum $file | grep -E "[0-9]+")
    if [ "$hash" == "$ogHash" ]; then
        ret=$true
    fi
    echo $ret
}