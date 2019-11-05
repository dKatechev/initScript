function Download-Java()
{
	try {
		$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
		[String] $jdkVersion = $appProps.'jdk.version'
		[String] $jdkFullVersion = $jdkVersion + "+9"
		[String] $jdkUrl = "http://download.oracle.com/otn-pub/java/jdk/" + $jdkFullVersion + "/cec27d702aa74d5a8630c65ae61e4305/jdk-" + $jdkVersion + "_windows-x64_bin.zip"
		[String] $localFile = (Join-Path $pwd.Path $jdkUrl.SubString($jdkUrl.LastIndexOf('/')))
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