function Install-Maven
{
#	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$installDir = [System.IO.Path]::GetFullPath($appProps.'install.dir')
	$mavenVersion = $appProps.'maven.version'
	$downloadDir = $downloadDir + "\maven\"
	if(-not(Test-Path -LiteralPath $downloadDir)) {
		Write-Output "Maven directory is not found: $downloadDir"
		exit
	}

	$downloadedArchive = $downloadDir + "\apache-maven-" + $mavenVersion + "-bin.zip"
	if(-not(Test-Path -LiteralPath $downloadedArchive)) {
		Write-Output "Maven archive is not found: $downloadedArchive"
		exit
	}

	$installDir = $installDir + "\maven\"
	New-Item -Path $installDir -ItemType "directory" -Force
	Write-Output "downloadedArchive: $downloadedArchive"
	Write-Output "installDir: $installDir"
#	Expand-Archive -Force -path $downloadedArchive -destinationpath $installDir
	Unzip $downloadedArchive $installDir

	$mavenHome = Get-ChildItem -Path $installDir -Filter apache-maven*
	$mavenHome = $installDir + $mavenHome
	SetEnvVarIfAbsent "MAVEN_HOME" $mavenHome
	SetEnvVarIfAbsent "M2_HOME" $mavenHome

	AddJavaHomeToPathIfAbsent
	AddMavenHomeToPathIfAbsent
}
