'.\funcs\*' | gci -include '*.psm1' | Import-Module
try {
#	Download-Java
#	Install-Java
	Download-Maven
	Install-Maven
	Download-Putty
	Install-Putty

	Remove-Downloads
} catch [Exception] {
	if ($_.Exception.InnerException) {
		Write-Error $_.Exception.InnerException.Message
	} else {
		Write-Error $_.Exception.Message
	}
}