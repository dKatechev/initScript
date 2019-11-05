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
	if($removeDownloads) {
		Write-Output "downloadDir to remove: $downloadDir"
		Remove-Item -Path $downloadDir -Recurse
	}
}
