$packageName = "TDS"
$silentArgs = "/quiet"
$tdsDisplayName = "Team Development for Sitecore"

$installedVersions = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
    Get-ItemProperty |
        Where-Object {$_.DisplayName -match $tdsDisplayName } |
            Select $_

ForEach ($installedVersion in $installedVersions) {
	$chocolateyPackageName = $installedVersion.DisplayName
    $uninstallPath = $installedVersion.UninstallString.replace("/I", "/x ")
	#Uninstall-ChocolateyPackage "$chocolateyPackageName" "msi" "$silentArgs" "$uninstallPath"
	#MsiExec.exe /x HedgehogDevelopmentTDS_VS2013.msi /quiet
}
