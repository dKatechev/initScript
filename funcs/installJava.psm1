function Download-Java()
{
	try {
		$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
		[String] $jdkVersion = $appProps.'jdk.version'
		[String] $jdkFullVersion = $jdkVersion + "+9"
		[String] $jdkUrl = "http://download.oracle.com/otn-pub/java/jdk/" + $jdkFullVersion + "/cec27d702aa74d5a8630c65ae61e4305/jdk-" + $jdkVersion + "_windows-x64_bin.zip"
		Write-Output "JDK download URL: $jdkUrl"
		$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
		$downloadDir = $downloadDir + "\jdk\"
		New-Item -Path $downloadDir -ItemType "directory" -Force
		[String] $localFile = $jdkUrl.SubString($jdkUrl.LastIndexOf('/'))
		$localFile = $downloadDir + $localFile
		Write-Output "JDK location: $localFile"

		[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
		$client = New-Object System.Net.WebClient		
		$cookie = "oraclelicense=accept-securebackup-cookie"
		$client.Headers.Add([System.Net.HttpRequestHeader]::Cookie, $cookie)
		Write-Progress -Activity 'Downloading file' -Status $jdkUrl
		
		$client.DownloadFile($jdkUrl, $localFile)
	} finally {
		$client.Dispose()
		Remove-Variable client
		[GC]::Collect()
	}
}

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