. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')

$basePackageName = "TDS"
$versionNo = "5.1.3"
$downloadUrl = "https://az730006.vo.msecnd.net/5-1-0-3/"
$regLicence = "HKLM:\SOFTWARE\Wow6432Node\HedgehogDevelopment\Sitecore Visual Studio Integration 2.0"
$silentArgs = "/quiet"

Function InstallTds ($vsVersionNumber, $vsVersion) {
	CheckIfVsIsInstalled $vsVersionNumber $vsVersion

	InstallTdsMsi $vsVersion
}

Function CheckIfVsIsInstalled ($vsVersionNumber, $vsVersion) {
	AddHKCR

	If (Test-Path "HKCR:\VisualStudio.DTE.$vsVersionNumber") {
		throw "Visual Studio $vsVersion not installed."
	}
}

Function InstallTdsMsi ($vsVersion) {
	$tdsDisplayName = GetTdsDisplayName $vsVersion
	$packageName = GetTdsPackageName $vsVersion
	$setupFile = "$($downloadUrl)HedgehogDevelopmentTDS_$vsVersion.msi"

	InstallMsi $tdsDisplayName $packageName $versionNo $setupFile
	AddLicenceToRegisty
}

Function AddLicenceToRegisty {
	$parameters = GetPackageParameters
	$licenceName = $parameters["LicenceName"]
	$licenceKey = $parameters["LicenceKey"]

	WriteRegValue $regLicence "Owner" $licenceName
	WriteRegValue $regLicence "Key" $licenceKey
}

Function UnintallTds ($vsVersion) {
	$tdsDisplayName = GetTdsDisplayName $vsVersion
	$packageName = GetTdsPackageName $vsVersion
	
	UninstallMsi $tdsDisplayName $packageName
}

Function GetTdsDisplayName ($vsVersion) {
	$tdsDisplayName = "Team Development for Sitecore [(]$vsVersion[)]"

	$tdsDisplayName
}

Function GetTdsPackageName ($vsVersion) {
	$packageName = "$basePackageName - $vsVersion"

	$packageName
}