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