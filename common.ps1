Function GetUninstallString ($displayName) {
	$uninstallString = Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall  |
	    Get-ItemProperty |
	        Where-Object {$_.DisplayName -match $displayName } |
	            Select -first 1 -ExpandProperty UninstallString

	 $uninstallString
}

Function UninstallMsi ($displayName, $packageName) {
	$silentArgs = "/quiet"
	$uninstallString = GetUninstallString $displayName

	if ($uninstallString) {
		$msiArgs = $uninstallString -replace "MsiExec.exe /I", "/X"
		Start-ChocolateyProcessAsAdmin "$msiArgs $silentArgs" 'msiexec'
		write-host "$packageName has been uninstalled."
	}
}

Function AddHKCR () {
	New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}