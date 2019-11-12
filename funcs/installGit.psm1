function Install-Git
{
	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$downloadDir = $downloadDir + "\git\"
	$installDir = [System.IO.Path]::GetFullPath($appProps.'install.dir')
	$installDir = $installDir + "\git\"

	$installer = Get-ChildItem -Path $downloadDir -Filter *.exe
	$installer = $downloadDir + "\" + $installer

	if(-not(Test-Path -LiteralPath $installer)) {
		Write-Output "Git installer is not found: $installer"
		exit
	}

	[String] $installArgs = "/S /D=" + $installDir
	Start-Process -NoNewWindow -FilePath $installer -Args $installArgs -Verb RunAs -Wait
}
