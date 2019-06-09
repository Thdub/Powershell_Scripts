$revo1 = Get-ChildItem -Path "$env:LocalAppdata\VS Revo Group\Revo Uninstaller Pro\BackUpsData"
$revo2 = Get-ChildItem -Path "$env:LocalAppdata\VS Revo Group\Revo Uninstaller Pro\RegBackup"
$shell = New-Object -ComObject 'Shell.Application'

ForEach ($path in $revo1)
{
	$shell.NameSpace(0).ParseName($path.FullName).InvokeVerb('delete')
}
ForEach ($path in $revo2)
{
	$shell.NameSpace(0).ParseName($path.FullName).InvokeVerb('delete')
}