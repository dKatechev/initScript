function SetEnvVarIfAbsent
{
	param([String] $envVarName, [String] $envVarValue)

	[String] $envVarActual = [Environment]::GetEnvironmentVariable($envVarName, "Machine")
	Write-Output "$envVarName : $envVarActual"
	if($envVarActual -eq "") {
		Write-Output "Set $envVarName : $envVarValue"
		[Environment]::SetEnvironmentVariable($envVarName, $envVarValue, "Machine")
	} else {
		Write-Output "$envVarName already exists"
	}
}

function AddJavaHomeToPathIfAbsent
{
	[String] $javaHomePathValue = "%JAVA_HOME%\bin"
	$regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
	[String] $envVarPath = $regKey.GetValue('Path', $null, "DoNotExpandEnvironmentNames")
	$envVarPath = $envVarPath.TrimEnd(";")
	
	Write-Output $envVarPath
	
	[String] $javaHomeRegex = "*" + $javaHomePathValue + "*"
	if($envVarPath -like $javaHomeRegex) {
		Write-Output "Path already contains '$javaHomePathValue'"
	} else {
		$newPath = $envVarPath + ";" + $javaHomePathValue + ";"
		$regKey.SetValue("Path", $newPath, "ExpandString")
	}
}