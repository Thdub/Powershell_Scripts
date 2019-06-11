# Self-elevate the script
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process PowerShell.exe -Verb Runas -Window Hidden -ArgumentList $CommandLine
  Exit
 }
}

# Start log transcript
Start-Transcript -Path ($PSScriptRoot -replace 'ps1','log') -Append | out-null

# Start process for usb hubs
$hubs = Get-WmiObject Win32_USBHub
$powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi
foreach ($p in $powerMgmt)
{
	$IN = $p.InstanceName.ToUpper()
	foreach ($h in $hubs)
	{
		$PNPDI = $h.PNPDeviceID
                if ($IN -like "*$PNPDI*")
                {
                     $p.enable = $False
                     $p.psbase.put()
                }
	}
}

# Stop log
Stop-Transcript | out-null
