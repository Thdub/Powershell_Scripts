$paths = Get-ChildItem -Path "$env:Temp"
$shell = New-Object -ComObject 'Shell.Application'

ForEach ($path in $paths)
{
	$shell.NameSpace(0).ParseName($path.FullName).InvokeVerb('delete')
}