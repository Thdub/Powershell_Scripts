# Export 3rd party drivers
# Change driver name to more human readable mode
# Printer drivers are excluded by default (inf-file names have been changed automatically)

$Manufacturer = (Get-WmiObject -Class win32_computersystem).Manufacturer
$Model = (Get-WmiObject -Class win32_computersystem).Model
$DestinationPath = "$PSScriptRoot\DriversBackup"
$Date = (Get-Date).ToString("yyyyMMdd")

# Self-elevate the script 
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# Export Drivers
if (Test-Path $DestinationPath)  {
  Write-Host "`"$DestinationPath`" already exists, deleting folder."
   Write-Host "`n"
    Remove-Item -Path $DestinationPath  -Recurse -Force
  }
   Write-Host "Creating"`"$DestinationPath`"
	New-Item $DestinationPath -ItemType Directory
    Write-host "Copying drivers, this can take several minutes."
    $ExportedDrivers = Export-WindowsDriver -Destination $DestinationPath -Online
    $win32pnpsigneddriver = Get-WmiObject win32_pnpsigneddriver
    $win32pnpentity = Get-WmiObject Win32_PNPEntity
    Get-WmiObject Win32_ComputerSystem 
    Get-CIMInstance -ClassName MS_SystemInformation -NameSpace root\WMI 

        foreach($Driver in $ExportedDrivers) { 
            #Write-Host $Driver.OriginalFileName
            #Write-Host $Driver.ClassName

            # Set inf-file path to variable. Just in case we need to do more inf-file magic
            $InfFilePath = $Driver.OriginalFileName -match '^.*\\(.*\\.*\.inf)$'
            $InfFilePath = "$DestinationPath\$($Matches[1])"
            #Write-Host "$InfFileDirectory"

            # Set inf-file name.
            $InfFileName = $Driver.OriginalFileName -match '^.*\\(.*\.inf)_.*$'
            $InfFileName = "$($Matches[1])"
            #Write-Host "$InfFileName"

            # DriverFolder "human" name can be found from Win32PNPSignedDriver list attribute DeviceName
            
            # Search with oem??.inf -drivername
            $DriverFolderName = $win32pnpsigneddriver|Where-Object {$_.InfName -eq "$($Driver.Driver)" }| Select-Object DeviceName
            $DriverFolderName = $DriverFolderName.DeviceName

            if(($DriverFolderName -eq "") -OR ($DriverFolderName -eq $null)) {
                $DriverFolderName = $win32pnpsigneddriver|Where-Object {$_.InfName -eq "$($Driver.Driver)" }| Select-Object DeviceDescription
                $DriverFolderName = $DriverFolderName.DeviceDescription
            }

            # Search with right ini-file -name. Some drivers are not renamed to oem??.inf
            if(($DriverFolderName -eq "") -OR ($DriverFolderName -eq $null)) {
                $DriverFolderName = $win32pnpsigneddriver|Where-Object {$_.InfName -eq "$($InfFileName)" }| Select-Object DeviceDescription
                $DriverFolderName = $DriverFolderName.DeviceDescription
            }

            if($DriverFolderName -is [system.array]) {
                $DriverFolderName = $DriverFolderName[0]
            }

            # Set folder name to infFile name if we couldn't find better information for driver
            # There are no devices using this driver because we didn't find driver info from Win32_pnpsigneddriver
            # Usually these drivers are not needed because there are no devices for these drivers
            # However! There might be devices which will activate later on so they will need driver installed to Windows.
            # Example is SD-card reader device which exist only when SD-card is inserted
            #
            # Move these drivers to _ExtraDrivers_MayNotBeNeeded -folder
            #
            if(($DriverFolderName -eq "") -OR ($DriverFolderName -eq $null)) {
                #$DriverFolderName = "..\_ExtraDrivers_MayNotBeNeeded\$InfFileName"
                $DriverFolderName = "$InfFileName"
                $ExtraDriver = $True
            } else {
                $ExtraDriver = $False
            }

            # Remove unsupported characters from folder name
            #$UnsupportedChars = '[!&{}~#%]'
            $pattern = '[^a-zA-Z0-9()[]{}#!&%=]'
            $DriverFolderName = $DriverFolderName -replace $pattern, ' '
            $DriverFolderName = ($DriverFolderName -replace "`t|`n|`r","")
            $DriverFolderName = ($DriverFolderName -replace "`n","")
            $DriverFolderName = ($DriverFolderName -replace "`r","")
            $DriverFolderName = ($DriverFolderName -replace "\\", " ")
            $DriverFolderName = ($DriverFolderName -replace "\/", " ")
            $DriverFolderName = ($DriverFolderName -replace "\*", " ")
            $DriverFolderName = ($DriverFolderName -replace "\?", " ")
            $DriverFolderName = ($DriverFolderName -replace '\"', ' ')
            $DriverFolderName = ($DriverFolderName -replace '®', '')
            if($($DriverFolderName.Length) -gt 70) {
                $DriverFolderName = $DriverFolderName.Substring(0,70)
            }

            # Create Driver target directory if not already exist
            #$DriverTargetDirectory = "$DestinationPath\$($Driver.ClassName)\$InfFileName\$($Driver.Version)"
            #$DriverTargetDirectory = "$DestinationPath\$($Driver.ClassName)\$DriverFolderName\$($Driver.Version)"
            
            $DeviceCategory = $Driver.ClassDescription
            if(($DeviceCategory -eq "") -OR ($DeviceCategory -eq $null)) {
                $DeviceCategory = $Driver.ClassName
            }
            if($DeviceCategory -is [system.array]) {
                $DeviceCategory = $DeviceCategory[0]
            }
            $pattern = '[^a-zA-Z0-9()[]{}#!&%=]'
            $DeviceCategory = $DeviceCategory -replace $pattern, ' '
            $DeviceCategory = ($DeviceCategory -replace "`t|`n|`r","")
            $DeviceCategory = ($DeviceCategory -replace "`n","")
            $DeviceCategory = ($DeviceCategory -replace "`r","")
            $DeviceCategory = ($DeviceCategory -replace "\\", " ")
            $DeviceCategory = ($DeviceCategory -replace "\/", " ")
            $DeviceCategory = ($DeviceCategory -replace "\*", " ")
            $DeviceCategory = ($DeviceCategory -replace "\?", " ")
            $DeviceCategory = ($DeviceCategory -replace '\"', ' ')
            $DeviceCategory = ($DeviceCategory -replace '®', '')
            if($($DeviceCategory.Length) -gt 50) { $DeviceCategory = $DeviceCategory.Substring(0,70) }

            if($ExtraDriver) {
                # This driver does NOT exist in Win32_pnpsigneddriver
                # Usually these drivers are not needed
                $DriverTargetDirectory = "$DestinationPath\Drivers without existing device\$DeviceCategory\$DriverFolderName $($Driver.Version)"
            } else {
                # This driver exist in Win32_pnpsigneddriver
                $DriverTargetDirectory = "$DestinationPath\$DeviceCategory\$DriverFolderName $($Driver.Version)"
            }

            # Printer drivers should not be needed
            if($DeviceCategory -eq "Printers") {
                $DriverTargetDirectory = "$DestinationPath\Drivers without existing device\$DeviceCategory\$DriverFolderName $($Driver.Version)"
            }

            if(-not (Test-Path $DriverTargetDirectory)) {
                New-Item $DriverTargetDirectory -ItemType Directory
            }
            
            # Set inf-file directory to variable. We will move this directory to ClassName-directory we created earlier
            $DriverDirectory = $Driver.OriginalFileName -match '^.*\\(.*)\\.*\.inf$'
            $DriverDirectory = "$DestinationPath\$($Matches[1])"
            #Write-Host "$DriverDirectory""

            # Move Driver-files to Destination Directory
            #Move-Item "$DriverDirectory\*" $DriverTargetDirectory -Force
            Get-ChildItem "$DriverDirectory\*" -Recurse | Move-Item -Destination $DriverTargetDirectory -Force
            Remove-Item $DriverDirectory

            # Rename Printer inf-files so they won't be installed
            if($DeviceCategory -eq "Printers") {
                $InfFiles = Get-Childitem $DriverTargetDirectory -Filter *.inf -Recurse
                foreach($InfFile in $InfFiles) {
                    Rename-Item $($InfFile.Fullname) "$($InfFile.Basename).inf_DO_NOT_IMPORT"
                }
            }	
        }

