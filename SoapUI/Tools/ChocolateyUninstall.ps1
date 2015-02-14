$packageName = "SoapUI"
$silentArgs = "-q"

$uninstallPath = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -match "soapui" } |
            Select -first 1 -ExpandProperty UninstallString

Uninstall-ChocolateyPackage "$packageName" "exe" "$silentArgs" "$uninstallPath"