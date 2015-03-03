. (Join-Path $(Split-Path -parent $MyInvocation.MyCommand.Definition) 'common.ps1')
$packageName = "Microsoft Baseline Security Analyzer"

UninstallMsi $packageName $packageName