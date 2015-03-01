. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$basePackageName = "TDS"
$downloadUrl = "https://az730006.vo.msecnd.net/5-1-0-3/"
$silentArgs = "/quiet"

Function InstallTds ($vsVersionNumber, $vsVersion) {
	CheckIfVsIsInstalled $vsVersionNumber $vsVersion

	InstallTdsMsi $vsVersion
}

Function CheckIfVsIsInstalled ($vsVersionNumber, $vsVersion) {
	AddHKCR

	if (Test-Path "HKCR:\VisualStudio.DTE.$vsVersionNumber") {
		throw "Visual Studio $vsVersion not installed."
	}
}

Function InstallTdsMsi ($vsVersion) {
	$packageName = GetTdsPackageName $vsVersion
	$setupFile = "$($downloadUrl)HedgehogDevelopmentTDS_$vsVersion.msi"

	Install-ChocolateyPackage "$packageName" 'msi' "$silentArgs" "$setupFile" -WarningPreference SilentlyContinue
}

Function UnintallTds ($vsVersion) {
	$tdsDisplayName = "Team Development for Sitecore [(]$vsVersion[)]"
	$packageName = GetTdsPackageName $vsVersion
	
	UninstallMsi $tdsDisplayName $packageName
}

Function GetTdsPackageName ($vsVersion) {
	$packageName = "$basePackageName - $vsVersion"

	$packageName
}