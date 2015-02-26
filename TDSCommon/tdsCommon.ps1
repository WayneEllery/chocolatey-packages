. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$basePackageName = "TDS"
$version = "5.1.0.3"

Function InstallTds ($vsVersionNumber, $vsVersion) {
	$zipDownloadDirectory = "$($env:TEMP)\$basePackageName"
	$tdsSetupDirectory = "$zipDownloadDirectory\$version\"

	CheckIfVsIsInstalled $vsVersionNumber $vsVersion

	DownloadAndExtractTdsZipFile $zipDownloadDirectory
	InstallTdsMsi $vsVersion $tdsSetupDirectory
}

Function CheckIfVsIsInstalled ($vsVersionNumber, $vsVersion) {
	AddHKCR

	if (Test-Path "HKCR:\VisualStudio.DTE.$vsVersionNumber") {
		throw "Visual Studio $vsVersion not installed."
	}
}

Function DownloadAndExtractTdsZipFile () {
	
	$downloadUrl = "http://www.hhogdev.com/~/media/Files/Products/Team_Development/HedgehogDevelopmentTDS.zip"

	Install-ChocolateyZipPackage "$basePackageName" "$downloadUrl" "$zipDownloadDirectory"
}

Function InstallTdsMsi ($vsVersion, $tdsSetupDirectory) {
	$silentArgs = "/quiet"
	$packageName = GetTdsPackageName
	$setupFile = "$($tdsSetupDirectory)HedgehogDevelopmentTDS_$vsVersion.msi"

	Install-ChocolateyInstallPackage "$packageName" 'msi' "$silentArgs" "$setupFile"
}

Function UnintallTds ($vsVersion) {
	$tdsDisplayName = "Team Development for Sitecore [(]$vsVersion[)]"
	$packageName = GetTdsPackageName
	
	UninstallMsi $tdsDisplayName $packageName
}

Function GetTdsPackageName () {
	$packageName = "$basePackageName - $vsVersion"

	$packageName
}