$packageName = "TDS"
$downloadUrl = "http://www.hhogdev.com/~/media/Files/Products/Team_Development/HedgehogDevelopmentTDS.zip"
$silentArgs = "/quiet"
$toolsDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$regVs2010 = "HKCR:\VisualStudio.DTE.10.0"
$regVs2012 = "HKCR:\VisualStudio.DTE.11.0"
$regVs2013 = "HKCR:\VisualStudio.DTE.12.0"
$tdsSetupDirectory = "$toolsDir/5.1.0.3/"

$tdsVs2010SetupFile = "$($tdsSetupFileBasePath)VS2010.msi"
$tdsVs2012SetupFile = "$($tdsSetupFileBasePath)HedgehogDevelopmentTDS_VS2012.msi"
$tdsVs2013SetupFile = "$($tdsSetupFileBasePath)HedgehogDevelopmentTDS_VS2013.msi"

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

$vs2010Installed = Test-Path $regVs2010
$vs2012Installed = Test-Path $regVs2012
$vs2013Installed = Test-Path $regVs2013

if (-Not $vs2010Installed -Or -Not $vs2012Installed -Or -Not $vs2012Installed) {
	throw "No compatible Visual studio installed. Checked for Visual Studio 2010, 2012 and 2013."
}

Install-ChocolateyZipPackage "$packageName" "$downloadUrl" "$toolsDir"

Function InstallMsi ($tdsSetupDirectory, $vsVersion, $packageName, $silentArgs) {
	$setupFile = "$($tdsSetupDirectory)HedgehogDevelopmentTDS$vsVersion.msi"
	Install-ChocolateyInstallPackage "$packageName ($vsVersion)" 'msi' "$silentArgs" "$setupFile"
}

if ($vs2010Installed) {
	InstallMsi $tdsSetupDirectory, "VS2010", $packageName, $silentArgs
}

if ($vs2012Installed) {
	InstallMsi $tdsSetupDirectory, "VS2012", $packageName, $silentArgs
}

if ($vs2013Installed) {
	InstallMsi $tdsSetupDirectory, "VS2013", $packageName, $silentArgs
}