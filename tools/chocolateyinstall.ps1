$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$trustedPublisherCertificate = "$toolsDir\openvpn_trusted_publisher.cer"
$trustedPublisherCertificateHash = '8f53adb36f1c61c50e11b8bdbef8d0ffb9b26665a69d81246551a0b455e72ec0b26a34dc9b65cb3750baf5d8a6d19896c3b4a31b578b15ab7086377955509fad'

$pgpPublicKey = "$toolsDir\MullvadVPN-2020.3.exe.asc"
$pgpPublicKeyHash = '7605462f5aa1b81cfcebdfe2b327d4da13698a11af773c05d46c17f72d7cb29e'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = 'https://mullvad.net/media/app/MullvadVPN-2020.3.exe'

  checksum64    = '7dc66b4b4d3cafc430c91edb01e5efb43dccca69e09dc7d8d2a3bc6718455b52'
  checksumType64= 'sha256'

  silentArgs    = '/S'
}

. "$toolsDir\utils\utils.ps1"

Write-Host "Adding OpenVPN to the Trusted Publishers (needed to have a silent install of the TAP driver)..."
AddTrustedPublisherCertificate -file "$trustedPublisherCertificate"

Install-ChocolateyPackage @packageArgs

Write-Host "Removing OpenVPN from the Trusted Publishers..."
RemoveTrustedPublisherCertificate -file "$trustedPublisherCertificate"
