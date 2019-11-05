function Download-Maven
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$mavenVersion = $appProps.'maven.version'
	Write-Output "Maven version: $mavenVersion"
	$mavenMirror = $appProps.'maven.mirror'
	Write-Output "Maven mirror: $mavenMirror"

	$mavenDownloadUrl = $mavenMirror + "maven/maven-3/" + $mavenVersion + "/binaries/apache-maven-" + $mavenVersion + "-bin.zip"
	Write-Output "mavenDownloadUrl: $mavenDownloadUrl"
	Write-Output "Start Maven $mavenVersion downloading ..."
	$downloadDir = $downloadDir + "\maven\"
	New-Item -Path $downloadDir -ItemType "directory" -Force
	Download-File $mavenDownloadUrl $downloadDir
}