function Download-Git
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$gitDownloadUrl = "https://git-scm.com/download/win"
	Write-Output "Start git downloading ..."
	$downloadDir = $downloadDir + "\git\"
	New-Item -Path $downloadDir -ItemType "directory" -Force
	Download-File $gitDownloadUrl $downloadDir
}