$packageName = "SoapUI"
$varFile = (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) "response.varfile")
$silentArgs = "-q -varfile `"$varFile`""

Function GetSettings {
	gc $varFile | %{$settings = @{}} {if ($_ -match "(.*)=(.*)") {$settings[$matches[1]]=$matches[2];}}
	$settings
}

Function UpdateVarFile ($InstallSettings) {
	$settings = GetSettings

	$stream = [System.IO.StreamWriter] $varFile

	ForEach($key in @($settings.keys)) {
	    $line = $key + "=" + $settings[$key]
	    $stream.WriteLine($line)
	}

	$stream.close()
}

UpdateVarFile

#Install-ChocolateyPackage "$packageName" "exe" "$silentArgs" "http://downloads.sourceforge.net/project/soapui/soapui/5.0.0/SoapUI-x32-5.0.0.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsoapui%2Ffiles%2Fsoapui%2F5.0.0%2F&ts=1423896588&use_mirror=liquidtelecom" "http://downloads.sourceforge.net/project/soapui/soapui/5.0.0/SoapUI-x64-5.0.0.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsoapui%2Ffiles%2Fsoapui%2F5.0.0%2F&ts=1423896554&use_mirror=liquidtelecom"

Install-ChocolateyPackage "$packageName" "exe" "$silentArgs" "C:\temp\SoapUI-x64-5.0.0.exe"

#component.2393$Boolean=false #Tutorial
#component.132$Boolean=true #SoapUI
#component.1263$Boolean=false #HermesJMS
#sys.component.714$Boolean=true #Source