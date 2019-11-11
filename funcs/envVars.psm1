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

function AddMavenHomeToPathIfAbsent
{
	[String] $mavenHomePathValue1 = "%MAVEN_HOME%\bin"
	[String] $mavenHomePathValue2 = "%M2_HOME%\bin"
	$regKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\CurrentControlSet\Control\Session Manager\Environment', $true)
	[String] $envVarPath = $regKey.GetValue('Path', $null, "DoNotExpandEnvironmentNames")
	$envVarPath = $envVarPath.TrimEnd(";")
	
	Write-Output $envVarPath
	
	[String] $mavenHomeRegex1 = "*" + $mavenHomePathValue1 + "*"
	[String] $mavenHomeRegex2 = "*" + $mavenHomePathValue2 + "*"
	if($envVarPath -like $mavenHomeRegex1) {
		Write-Output "Path already contains '$mavenHomePathValue1'"
	} else {
		$newPath = $envVarPath + ";" + $mavenHomePathValue1 + ";"
		$regKey.SetValue("Path", $newPath, "ExpandString")
	}

	$envVarPath = $envVarPath.TrimEnd(";")

	if($envVarPath -like $mavenHomeRegex2) {
		Write-Output "Path already contains '$mavenHomePathValue2'"
	} else {
		$newPath = $envVarPath + ";" + $mavenHomePathValue2 + ";"
		$regKey.SetValue("Path", $newPath, "ExpandString")
	}
}
