$packageName = "TDS"

New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null

$regVs2010 = "HKCR:\VisualStudio.DTE.10.0"
$regVs2012 = "HKCR:\VisualStudio.DTE.11.0"
$regVs2013 = "HKCR:\VisualStudio.DTE.12.0"

if (Test-Path $regVs2010) {
	Write-Host "Vs2010"
}

if (Test-Path $regVs2012) {
	Write-Host "Vs2012"
}

if (Test-Path $regVs2013) {
	Write-Host "Vs2013"
}