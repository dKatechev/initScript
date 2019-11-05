function Download-File([String] $source, [String] $target)
{
	try {
		[String] $localFile = $source.SubString($source.LastIndexOf('/'))
		$client = New-Object System.Net.WebClient
		$Global:downloadComplete = $false

		$eventDataComplete = Register-ObjectEvent $client DownloadFileCompleted `
			-SourceIdentifier WebClient.DownloadFileComplete `
			-Action {$Global:downloadComplete = $true}
		$eventDataProgress = Register-ObjectEvent $client DownloadProgressChanged `
			-SourceIdentifier WebClient.DownloadProgressChanged `
			-Action { $Global:DPCEventArgs = $EventArgs }

		Write-Progress -Activity 'Downloading file' -Status $source
		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$target = $target + "/" + $localFile
		$target = $target.Replace("/", "")
		Write-Output "source: $source"
		Write-Output "target: $target"
		$client.DownloadFileAsync($source, $target)

		while (!($Global:downloadComplete)) {
			$pc = $Global:DPCEventArgs.ProgressPercentage
			if ($pc -ne $null) {
				Write-Progress -Activity 'Downloading file' -Status $source -PercentComplete $pc
			}
		}

		Write-Progress -Activity 'Downloading file' -Status $source -Complete
	} catch [System.Net.WebException] {
		if ($_.Exception.InnerException) {
			Write-Error $_.Exception.InnerException.Message
		} else {
			Write-Error $_.Exception.Message
		}
	} finally {
		Unregister-Event -SourceIdentifier WebClient.DownloadProgressChanged
		Unregister-Event -SourceIdentifier WebClient.DownloadFileComplete
		$client.Dispose()
		$Global:downloadComplete = $null
		$Global:DPCEventArgs = $null
		Remove-Variable client
		Remove-Variable eventDataComplete
		Remove-Variable eventDataProgress
		[GC]::Collect()
	}
}