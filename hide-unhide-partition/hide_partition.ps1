<# 
    This is a two-script fast and dirty solution for
	hidding and unhidding a partition. I found it useful
	for backups. You unhide the partition for backup and
	then hide it, so you don't mess up with a backup.
    - Jaime Rosario Justicia
#>


if (
    !([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")
    )
    { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

# Storage unit serial number
$SERIAL = 'D34DB33FC4F3'

# Partition to hide
$PN = 3

if ($PSVersionTable.PSVersion.Major -le 4)
    { Get-Disk | Where-Object SerialNumber -EQ $SERIAL | Get-Partition | Where-Object PartitionNumber  -EQ $PN | Set-Partition -IsHidden $true }
else
    { Get-Disk -SerialNumber $SERIAL | Set-Partition -PartitionNumber $PN -IsHidden $true }