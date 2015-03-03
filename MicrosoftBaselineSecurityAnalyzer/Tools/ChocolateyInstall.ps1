$packageName = "Microsoft Baseline Security Analyzer"
$silentArgs = "/quiet"

$downloadUrlx86 = "http://download.microsoft.com/download/8/E/1/8E16A4C7-DD28-4368-A83A-282C82FC212A/MBSASetup-x86-EN.msi"
$downloadUrlx64 = "http://download.microsoft.com/download/8/E/1/8E16A4C7-DD28-4368-A83A-282C82FC212A/MBSASetup-x64-EN.msi"

Install-ChocolateyPackage "$packageName" 'msi' "$silentArgs" "$downloadUrlx86" $downloadUrlx64