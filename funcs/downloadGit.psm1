function Download-Git
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	
	$gitVersion = $appProps.'git.version'
	Write-Output "Git version: $gitVersion"
	$gitDownloadUrl = "https://github.com/git-for-windows/git/releases/download/v" + gitVersion + ".windows.2/Git-" + gitVersion + ".2-64-bit.exe"

	Write-Output "Start git downloading ..."
	$downloadDir = $downloadDir + "\git\"
	New-Item -Path $downloadDir -ItemType "directory" -Force
	Download-File $gitDownloadUrl $downloadDir
}