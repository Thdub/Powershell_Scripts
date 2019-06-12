# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}
Export-StartLayout -Path "$env:UserProfile\Desktop\StartMenuLayout.xml" -verbose
Copy-Item "$env:UserProfile\Desktop\StartMenuLayout.xml" -Destination "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Force
Copy-Item "$env:UserProfile\Desktop\StartMenuLayout.xml" -Destination "$env:LocalAppData\Microsoft\Windows\Shell\LayoutModification.xml" -Force