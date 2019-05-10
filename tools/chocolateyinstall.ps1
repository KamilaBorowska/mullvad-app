$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$trustedPublisherCertificate = "$toolsDir\openvpn_trusted_publisher.cer"
$trustedPublisherCertificateHash = '8f53adb36f1c61c50e11b8bdbef8d0ffb9b26665a69d81246551a0b455e72ec0b26a34dc9b65cb3750baf5d8a6d19896c3b4a31b578b15ab7086377955509fad'

$pgpPublicKey = "$toolsDir\MullvadVPN-2019.4.exe.asc"
$pgpPublicKeyHash = '7f35555161c35fb83c82a7ec6d468fb7a5b1a61a18027ff14333782fe53b1285'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = 'https://mullvad.net/media/app/MullvadVPN-2019.4.exe'

  checksum64    = 'ce6992ec4acb3cb1e053d19390348a9ee301bf53b162f1c314a3ee96d01ffad3'
  checksumType64= 'sha256'

  silentArgs    = '/S'
}

. "$toolsDir\utils\utils.ps1"

Write-Host "Adding OpenVPN to the Trusted Publishers (needed to have a silent install of the TAP driver)..."
AddTrustedPublisherCertificate -file "$trustedPublisherCertificate"

Install-ChocolateyPackage @packageArgs

Write-Host "Removing OpenVPN from the Trusted Publishers..."
RemoveTrustedPublisherCertificate -file "$trustedPublisherCertificate"
