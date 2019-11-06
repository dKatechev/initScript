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