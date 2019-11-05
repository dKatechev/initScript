Add-Type -AssemblyName System.IO.Compression.FileSystem
function Unzip
{
    param([string]$zipfile, [string]$target)

	if(Test-Path -LiteralPath $target) {
		Write-Output "$target already exists, replacing it"
		Remove-Item -Path $target -Recurse
	}
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $target)
}
