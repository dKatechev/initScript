function Download-Putty
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	Write-Output "downloadDir: $downloadDir"
	[Double] $puttyVersion = $appProps.'putty.version' -as [Double]
	Write-Output "puttyVersion: $puttyVersion"

	$appToMatch = '*PuTTY*'
	$result = Get-InstalledApps | where {$_.DisplayName -like $appToMatch -and $_.DisplayVersion -as [Double] -lt $puttyVersion}
	If ($result -eq $null) {
#		[Boolean] $is64 = [System.Environment]::Is64BitOperatingSystem
#		[String] $puttyDownloadUrl
#		if($is64) {
			$puttyDownloadUrl = "https://the.earth.li/~sgtatham/putty/" + $puttyVersion + "/w64/putty-64bit-" + $puttyVersion + "-installer.msi"
#		} else {
#			$puttyDownloadUrl = "https://the.earth.li/~sgtatham/putty/" + $puttyVersion + "/w32/putty-" + $puttyVersion + "-installer.msi"
#		}

		Write-Output "Putty $puttyVersion installation in progress..."
		$downloadDir = $downloadDir + "\putty\"
		New-Item -Path $downloadDir -ItemType "directory" -Force
		Download-File $puttyDownloadUrl $downloadDir
	} else {
		Write-Output "PuTTY $puttyVersion is already installed, no need to download"
	}
}