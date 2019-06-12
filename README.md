# Powershell_Scripts
Various powershell scripts.

# CleanTempFolder_Move_to_Recycle_Bin
- Moves your TEMP folder contents to Recycle Bin.
- Since long time I wanted to make that script to clean my temp folder but sending files to recycle bin, instead of "batch delete" and sending files into space...

# CleanRevoUninstallerLeftovers
- Moves Revo Uninstaller installations backups/leftovers to Recycle Bin.
- After you uninstalled an application through Revo Uninstaller, it leaves files under "%LocalAppdata%\VS Revo Group\Revo Uninstaller Pro\" for restore purpose. You can clean them once you don't need it anymore.

# DiskWriteCaching
- Enables write caching on all drives.
- This task normally can only be done manually through device manager (disk drives/policies tab/enable write caching), and one drive at a time.
- This script will enable write caching for all your drives at once, handful when you set up your system for the first time.
- Note: Needs Microsoft Dskcache.exe tool next to the script.
- Download dskcache: https://www.upload.ee/files/10083654/dskcache.exe.html

# DriversBackup_Desktop
- Export all your (3rd party) drivers, changes drivers folders names to a "human readable" one.
- Sorts them in folders by "classname" : Display adapters - Human Interface Devices - IDE ATA ATAPI controllers - Network adapters - Sound, video and game controllers System devices - Universal Serial Bus controllers, making them much easier to find.
- Also creates a "Drivers without existing device" folder for driver installed without physically existing device.
- Note: Drivers are extracted in "%TEMP%" folder and then compressed as "DriversBackup.zip" on your Desktop.

# DriversBackup_ScriptFolder
- Same as above, but drivers will be extracted in "DriversBackup" folder, next to the script (and folder is not zipped). Faster method, file compression through powershell is quite slow.

# Export_StartMenuLayout_and_make_Default
- Exports Start Menu layout on your Desktop and copy to default user.
- Useful when you have problems with your start menu and pinned items resetting, or when using Group Policy to force start menu layout.
- Note: Sadly the command does not work perfectly (microsoft bug), and some items may be missing when you have lots of pinned apps/links. Editing .xml manually is recommended.

# Get_Indexed_Locations_PS_ISE
- Simple script to display indexed locations using Powershell ISE.
- Note: Needs Microsoft.Search.Interop.dll next to the script. Open the file with Powershell ISE.
- Download Microsoft.Search.Interop.dll : https://anonfile.com/FfA0Nfndn6/Microsoft.Search.Interop_dll

# PowerManagementNIC
- Disables/untick "Allow the computer to turn off this device to save power" for network adapter(s). 
- This setting is found under "Power Management" tab in Device Manager.

# PowerManagementUSB
- Disables/untick "allow the computer to turn off this device to save power" for all USB Hubs.
- This setting is found under "PowerManagement" tab in Device Manager

# WinDefenderToggle.ps1
- Toggle Windows Defender on and off. 
- Can be used for a context menu Defender on/off switch. Another good (better) method for that though, is this one:
- https://github.com/Thdub/Personalize_Next_Gen/blob/master/CUSTOMIZE/02_Context_Menu_CUSTOMIZE/DB06_Desktop_Background_WindowsDefender_Toggle.reg
