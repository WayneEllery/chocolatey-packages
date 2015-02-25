$packageName = "TDS"
$silentArgs = "/quiet"
$tdsDisplayName = "Team Development for Sitecore"

$installedVersions = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -match $tdsDisplayName } |
            Select -first 1 -ExpandProperty UninstallString

$installedVersions = $installedVersions.replace("/I", "/X")            
cmd /c "$installedVersions $silentArgs"
write-host "$packageName has been uninstalled."