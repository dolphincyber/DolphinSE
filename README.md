# DolphinSE
Vulnerability scoring system for cybersecurity training.

> written in powershell and shell script by DolphinCyber

# Configuration
### Put configurations for linux in ./Linux/conf.sh and configurations for windows in ./Windows/scoring.conf
### Linux configurations

**packageInstalled** - packageInstalled _package_

**packageInstalledNot** - packageInstalledNot _package_

**serviceUp** - serviceUp _service_

**serviceUpNot** - serviceUpNot _service_

**userExists** - userExists _user_

**userExistsNot** - userExistsNot _user_

**userInGroup** - userInGroup _user_ _group_

**userInGroupNot** - userInGroupNot _user_ _group_

**firewallUp** - firewallUp

**firewallUpNot** - firewallUpNot

**passwordChanged** - passwordChanged _user_ _time_

**passwordChangedNot** - passwordChangedNot _user_ _time_

**guestDisabledLDM** - guestDisabledLDM

**guestDisabledLDMNot** - guestDisabledLDMNot

**kernelVersion** - kernelVersion _version_

**autoCheckUpdatesEnabled** - autoCheckUpdatesEnabled

**permissionIs** - permissionIs _file_ _permission_

**permissionIsNot** - permissionIsNot _file_ _permission_

**firefoxSetting** - firefoxSetting _method_ _key_ _value_ **THIS NEEDS TO BE IN REGEX**

**firefoxSettingNot** - firefoxSettingNot _method_ _key_ _value_ **THIS NEEDS TO BE IN REGEX**

**pathExists** - pathExists _path_

**pathExistsNot** - pathExistsNot _path_

**fileContains** - fileContains _contains_ _file_ **THIS NEEDS TO BE IN REGEX**

**fileContainsNot** - fileContainsNot _contains_ _file_ **THIS NEEDS TO BE IN REGEX**

**fileEquals** - fileEquals _hash_ _file_
________________________________________

**make sure you wrap all your configurations with**
```
#!/bin/bash
. checks.sh
function scoredVulns {

}
```
________________________________________
**example**
```
#!/bin/bash
. checks.sh
function scoredVulns {
    packageInstalled "chkrootkit"
    packageInstalledNot "tor"
    serviceUp "ssh"
    serviceUpNot "mysql-server"
    userExists "User"
    userExistsNot "Unauthorized"
    userInGroup "Admin" "sudo"
    userInGroupNot "User" "sudo"
    firewallUp
    passwordChanged "Admin" "Nov 9, 2020"
    passwordChangedNot "User" "Nov 9, 2020"
    guestDisabledLDM
    autoCheckUpdatesEnabled
    permissionIs "/file1" "644"
    permissionIsNot "/file1" "777"
    firefoxSetting "lockPref" "browser\.download\.dir" "\~\/Downloads"
    firefoxSettingNot "lockPref" "browser\.shell\.checkDefaultBrowser" "true"
    pathExists "/file1"
    pathExistsNot "/file2"
    fileContains "this\.is\.an\.example.*?=.*?config" "/file1"
    fileContainsNot "this.+?should\.not\\be.*?=.*?here" "/file1"
    fileEquals "85e07e80be1ed41f1b96babb01d1f97e" "/file1"
}
```