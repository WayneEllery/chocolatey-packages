Function GetUninstallString ($displayName) {
	$uninstallPathWow6432 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
	
	$uninstallPaths = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
	
	if (Test-Path $uninstallPathWow6432) {
		$uninstallPaths = $uninstallPaths, $uninstallPathWow6432
	}
	
	$uninstallString = Get-ChildItem -Path $uninstallPaths  |
	    Get-ItemProperty |
	        Where-Object {$_.DisplayName -match $displayName } |
	            Select -first 1 -ExpandProperty UninstallString

	 $uninstallString
}

Function UninstallMsi ($displayName, $packageName) {
	$silentArgs = "/quiet"
	$uninstallString = GetUninstallString $displayName

	If ($uninstallString) {
		$msiArgs = $uninstallString -replace "MsiExec.exe /I", "/X"
		Start-ChocolateyProcessAsAdmin "$msiArgs $silentArgs" 'msiexec'
		write-host "$packageName has been uninstalled."
	}
}

Function AddHKCR () {
	New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

Function GetPackageParameters {
	$packageParameters = $env:chocolateyPackageParameters

	if ($packageParameters) {
		$match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
		$option_name = 'option'
		$value_name = 'value'

		if ($packageParameters -match $match_pattern) {
			$results = $packageParameters | Select-String $match_pattern -AllMatches
			$results.matches | % {
			$arguments.Add(
				$_.Groups[$option_name].Value.Trim(),
				$_.Groups[$value_name].Value.Trim())
			}
		}
		else
		{
			Throw "Package Parameters were found but were invalid"
		}
	}

	$packageParameters
}

Function WriteRegValue ($path, $name, $value) {
	If ($value -ne $null) {
		If (-Not (Test-Path $path)) {
			New-Item -Path $path -type Directory -Force | Out-Null
		}

		New-ItemProperty -Path $path -Name $name -PropertyType String -Value $value -Force | Out-Null
	}
}