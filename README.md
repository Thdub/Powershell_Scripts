# Powershell Scripts
  Various powershell scripts.

# CleanRevoUninstallerLeftovers
  Move Revo Uninstaller installations backups/leftovers to Recycle Bin.
  
  After you uninstalled an application through Revo Uninstaller, it leaves files under "%LocalAppdata%\VS Revo Group\Revo Uninstaller Pro\" for restore purpose. You can clean them once you don't need it anymore.

# CleanTempFolder_Move_to_Recycle_Bin
  Move your TEMP folder contents to Recycle Bin.
  
  Since long time I wanted to make that script to clean my temp folder but sending files to recycle bin, instead of "batch delete" and sending files into space... 

# DiskWriteCaching
  Enable write caching on all drives.
  
  This task normally can only be done manually through device manager (disk drives/policies tab/enable write caching), and one drive at a time. This script will enable write caching for all your drives at once, handful when you set up your system for the first time.
 
 Note: Needs Microsoft Dskcache.exe tool next to the script.
 
 Download dskcache.exe : https://www.upload.ee/files/10230433/Utilities.zip.html

# Export_StartMenuLayout_and_make_Default
  Export Start Menu layout on your Desktop and copy to default user.
  
  Useful when you have problems with your start menu and pinned items resetting, or when using Group Policy to force start menu layout.
  
  Note: Sadly that command does not work perfectly at parsing your links (microsoft fault), and some items may be missing when you have lots of pinned apps/links. Editing .xml manually is recommended.

# Get_Indexed_Locations_PS_ISE
  Simple script to display indexed locations using Powershell ISE.
  
  Note: Needs Microsoft.Search.Interop.dll next to the script. Open the file with Powershell ISE.
  
  Download Microsoft.Search.Interop.dll : https://www.upload.ee/files/10230433/Utilities.zip.html

# PowerManagementNIC
  Disable/untick "Allow the computer to turn off this device to save power" for network adapter(s). 
  
  This setting is found under "Power Management" tab in Device Manager.

# PowerManagementUSB
  Disable/untick "allow the computer to turn off this device to save power" for all USB Hubs.
  
  This setting is found under "PowerManagement" tab in Device Manager

# WinDefenderToggle
  Toggle Windows Defender on and off.
  
  Can be used for a context menu Defender on/off switch.
  
  Another good (better) method for that though, is this one:
  
  https://github.com/Thdub/Personalize_Next_Gen/blob/master/CUSTOMIZE/02_Context_Menu_CUSTOMIZE/DB06_Desktop_Background_WindowsDefender_Toggle.reg
