function Install-Putty
{
	'.\*' | gci -include '*.psm1' | Import-Module

	$appProps = Convertfrom-Stringdata (Get-Content ./app.properties -raw)
	$downloadDir = [System.IO.Path]::GetFullPath($appProps.'download.dir')
	$installDir = [System.IO.Path]::GetFullPath($appProps.'install.dir')
	$downloadDir = $downloadDir + "\putty\"
	if(-not(Test-Path -LiteralPath $downloadDir)) {
		Write-Output "Putty installer directory is not found: $downloadDir"
		exit
	}

	$installer = Get-ChildItem -Path $downloadDir -Filter *.msi
	$installer = $downloadDir + "\" + $installer
	
	if(-not(Test-Path -LiteralPath $installer)) {
		Write-Output "Putty installer is not found: $installer"
		exit
	}

	$installDir = $installDir + "\putty\"
	New-Item -Path $installDir -ItemType "directory" -Force
	$installDirParam = "INSTALLDIR=$installDir"
	$installParams = '/i', $installer,
			$installDirParam,
          '/qb!'
	Write-Output "putty install parameters: $installParams"
	$p = Start-Process 'msiexec.exe' -ArgumentList $installParams -NoNewWindow -Wait -PassThru
	$p.ExitCode
}