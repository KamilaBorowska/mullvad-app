$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$trustedPublisherCertificate = "$toolsDir\openvpn_trusted_publisher.cer"
$trustedPublisherCertificateHash = '8f53adb36f1c61c50e11b8bdbef8d0ffb9b26665a69d81246551a0b455e72ec0b26a34dc9b65cb3750baf5d8a6d19896c3b4a31b578b15ab7086377955509fad'

$pgpPublicKey = "$toolsDir\MullvadVPN-2021.1.exe.asc"
$pgpPublicKeyHash = '03fedf10b55d10ca03a3c0e7d8139a17b19255a869de8f40a70ea70b21fab8ea'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = 'https://mullvad.net/media/app/MullvadVPN-2021.1.exe'

  checksum64    = 'bed42a7cb009ebd027194f20940b2b9856037a0e581a9bdfaf9b325b8d2f6af3'
  checksumType64= 'sha256'

  silentArgs    = '/S'
}

. "$toolsDir\utils\utils.ps1"

Write-Host "Adding OpenVPN to the Trusted Publishers (needed to have a silent install of the TAP driver)..."
AddTrustedPublisherCertificate -file "$trustedPublisherCertificate"

Install-ChocolateyPackage @packageArgs

Write-Host "Removing OpenVPN from the Trusted Publishers..."
RemoveTrustedPublisherCertificate -file "$trustedPublisherCertificate"
