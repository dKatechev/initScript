function Install-Java
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$installDir = [System.IO.Path]::GetFullPath($appProps.'install.dir')
	$jdkVersion = $appProps.'jdk.version'
	$downloadDir = $downloadDir + "\jdk\"
	if(-not(Test-Path -LiteralPath $downloadDir)) {
		Write-Output "JDK directory is not found: $downloadDir"
		exit
	}

	$downloadedArchive = $downloadDir + "\jdk-" + $jdkVersion + "_windows-x64_bin.zip"
	if(-not(Test-Path -LiteralPath $downloadedArchive)) {
		Write-Output "JDK archive is not found: $downloadedArchive"
		exit
	}

	$installDir = $installDir + "\jdk\"
	New-Item -Path $installDir -ItemType "directory" -Force
	Write-Output "downloadedArchive: $downloadedArchive"
	Write-Output "installDir: $installDir"
#	Expand-Archive -Force -path $downloadedArchive -destinationpath $installDir
	Unzip $downloadedArchive $installDir

	$javaHome = Get-ChildItem -Path $installDir -Filter jdk*
	$javaHome = $installDir + $javaHome
	SetEnvVarIfAbsent "JAVA_HOME" $javaHome
	AddJavaHomeToPathIfAbsent
}