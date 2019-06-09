# Self-elevate the script
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process PowerShell.exe -Verb Runas -Window Hidden -ArgumentList $CommandLine
  Exit
 }
}

#
$preferences = Get-MpPreference
Set-MpPreference -DisableRealtimeMonitoring (!$preferences.DisableRealtimeMonitoring)
