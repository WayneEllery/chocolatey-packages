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

	If ($uninstallString) {
		$msiArgs = $uninstallString -replace "MsiExec.exe /I", "/X"
		Start-ChocolateyProcessAsAdmin "$msiArgs $silentArgs" 'msiexec'
		write-host "$packageName has been uninstalled."
	}
}

Function AddHKCR () {
	New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT | Out-Null
}

Function GetParameters {
	$arguments = $env:chocolateyInstallArguments
	$env:chocolateyInstallArguments=""
	$MATCH_PATTERN = "/([a-zA-Z]+):([`"'])?([a-zA-Z0-9- _]+)([`"'])?"
	$PARAMATER_NAME_INDEX = 1
	$PARAMATER_VALUE_INDEX = 3

    $results = $arguments | Select-String $MATCH_PATTERN -AllMatches  
    
    $parameters = @{ }
    
    If ($results) {
	    $results.matches | % { 
		    $parameters.Add(
		    	$_.Groups[$PARAMATER_NAME_INDEX].Value.Trim(),
		    	$_.Groups[$PARAMATER_VALUE_INDEX].Value.Trim()) 
		}
	}

	$parameters
}

Function WriteRegValue ($path, $name, $value) {
	If ($value -ne $null) {
		If (-Not (Test-Path $path)) {
			New-Item -Path $path -type Directory -Force | Out-Null
		}

		New-ItemProperty -Path $path -Name $name -PropertyType String -Value $value -Force | Out-Null
	}
}