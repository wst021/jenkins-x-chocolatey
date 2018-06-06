$packageName = 'jenkins-x'
$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$version = $env:ChocolateyPackageVersion
$url = "https://github.com/jenkins-x/jx/releases/download/v$version/jx-windows-amd64.zip"
$urlSHA = "https://github.com/jenkins-x/jx/releases/download/v$version/jx-windows-amd64.zip.sha256"
$fileSHA = "$toolsPath\jenkins-x.sha256"
Get-WebFile -Url $urlSHA -FileName $fileSHA
$checksum = Get-Content -Path $fileSHA
$checksumtype = "sha256" 

$packageArgs = @{
  packageName    = $packageName
  url            = $url
  unzipLocation  = $toolsPath
  checksum       = $checksum
  checksumtype   = $checksumtype
}
Install-ChocolateyZipPackage @packageArgs

if (Test-Path "$toolsPath\jx-windows*.zip") {
  $packageArgs2 = @{
    packageName    = $packageName
    url            = $url
    unzipLocation  = $toolsPath
    checksum       = $checksum
    checksumtype   = $checksumtype
  }
  Install-ChocolateyZipPackage @packageArgs2

  Remove-Item "$toolsPath\jx-windows*.zip"
}

Rename-Item -Path "$toolsPath\jx-windows-amd64.exe" -NewName "jx.exe"

Install-BinFile -Name "jx" -Path "$toolsPath"
