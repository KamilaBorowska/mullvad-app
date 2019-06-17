$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$trustedPublisherCertificate = "$toolsDir\openvpn_trusted_publisher.cer"
$trustedPublisherCertificateHash = '8f53adb36f1c61c50e11b8bdbef8d0ffb9b26665a69d81246551a0b455e72ec0b26a34dc9b65cb3750baf5d8a6d19896c3b4a31b578b15ab7086377955509fad'

$pgpPublicKey = "$toolsDir\MullvadVPN-2019.5.exe.asc"
$pgpPublicKeyHash = '8c073c0371f93315de3fea40437e928543a0e71edb4796fde8017968256680a6'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'exe'
  url64bit      = 'https://mullvad.net/media/app/MullvadVPN-2019.5.exe'

  checksum64    = '5ada9945d59b0d2e29242270403491e7657704a07a67eb45419ce9dc7a2a56cc'
  checksumType64= 'sha256'

  silentArgs    = '/S'
}

. "$toolsDir\utils\utils.ps1"

Write-Host "Adding OpenVPN to the Trusted Publishers (needed to have a silent install of the TAP driver)..."
AddTrustedPublisherCertificate -file "$trustedPublisherCertificate"

Install-ChocolateyPackage @packageArgs

Write-Host "Removing OpenVPN from the Trusted Publishers..."
RemoveTrustedPublisherCertificate -file "$trustedPublisherCertificate"
