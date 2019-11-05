function Remove-Downloads
{
	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = $appProps.'download.dir'
	$removeDownloadsRaw = $appProps.'downloads.remove'
	$removeDownloads
	try {
		$removeDownloads = [System.Convert]::ToBoolean($removeDownloadsRaw)
	} catch [FormatException] {
		$removeDownloads = $false
	}
	Write-Output "removeDownloads: $removeDownloads"
	if($removeDownloads) {
		Write-Output "downloadDir: $downloadDir"
		Remove-Item -Path $downloadDir -Recurse
#		Get-ChildItem -Path $downloadDir -Include * File -Recurse | foreach { $_.Delete()}
	}
}
