$packageName = 'jenkins-x'
$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$version = $env:ChocolateyPackageVersion
$fileZip = "jx-windows-amd64.zip"
$fileChecksums = "jx-checksums.txt"
$url = "https://github.com/jenkins-x/jx/releases/download/v$version/$fileZip"
$urlSHA = "https://github.com/jenkins-x/jx/releases/download/v$version/$fileChecksums"
$fileSHA = "$toolsPath\$fileChecksums"
Get-WebFile -Url $urlSHA -FileName $fileSHA
$matchChecksum = Select-String -Path $fileSHA -Pattern $fileZip -SimpleMatch
$checksum = $matchChecksum.Line.Split(" ")[0]
$checksumtype = "sha256" 

if (Test-Path "$toolsPath\jx.exe") {
  Remove-Item "$toolsPath\jx.exe"
  Uninstall-BinFile -Name "jx" -Path "$toolsPath"
}
$packageArgs = @{
  packageName    = $packageName
  url            = $url
  unzipLocation  = $toolsPath
  checksum       = $checksum
  checksumtype   = $checksumtype
}
Install-ChocolateyZipPackage @packageArgs
Remove-Item "$toolsPath\jx-windows*.zip"
Rename-Item -Path "$toolsPath\jx-windows-amd64.exe" -NewName "jx.exe"
Install-BinFile -Name "jx" -Path "$toolsPath"
