# Self-elevate the script 
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# Cmdlet
[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)]
[ValidateNotNull()]
[Array]$Disks,

[Parameter(Mandatory=$True)]
[ValidateNotNull()]
[boolean]$WriteCache,
  
[Parameter(Mandatory=$True)]
[ValidateNotNull()]
[Array]$Servers
)

# Set dskcache.exe utility flag
if ($WriteCache) {$flag="+"} else {$flag="-"}

# Start log transcript
Start-Transcript -Path ($PSScriptRoot -replace 'ps1','log') -Append | out-null

foreach ($server in $servers)
{ 
    Copy-Item -Path "$PSScriptRoot\dskcache.exe" -Destination "$env:TEMP"

	$Disk=Get-WmiObject Win32_DiskDrive

    foreach ($DiskN in $Disks)
      {
        # Check if required disk available otherwise skip changes
        if (!($Disk.Index -contains $DiskN)) {Write-Host $server Disk $DiskN does not exist, or is not available at this time. -f Yellow}
        else
        {

        # Get Diskname and Disk serial number
        $DiskName=($disk | where Index -eq $diskN).Caption
        $DiskSN=($disk | where Index -eq $diskN).SerialNumber
        
		Write-Host $server "Changing write caching for" ($DiskName+" - SN:"+$DiskSN) "- DiskNumber:" $DiskN -f Yellow
		Start-Process -FilePath "$env:TEMP\dskcache.exe" -ArgumentList "$($flag)w PhysicalDrive$($DiskN)" -WindowStyle Hidden
       }}

    # Wait 1s for utility execution and then remove dskcache.exe utility file from temporarily folder
    Sleep 1
    Remove-Item -Path "$env:TEMP\dskcache.exe"
}

Write-Host "Run duration: " -n
Write-Host ([Math]::Round((([DateTime]::Now).Subtract($runStart)).TotalMinutes,2)) -f Yellow -n
Write-Host " minutes" -n

# Stop log
Stop-Transcript | out-null
