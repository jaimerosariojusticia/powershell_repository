<#
	Another powershell script for backup using robocopy, logs and a specific device
	which can be identified using the serial number. This was customized for a client
	that uses a external usb to backup data. The device often gets a different drive letter,
	so I use 'Get-Disk' to find the serial number, and the drive letter assigned to.

	-Jaime Rosario Justicia
#>

### Get Drive letter by using disk serial number
$SERIALNUM = 'AA00000000000489'
#
$DRIVE=$(Get-Disk | Select-Object Number,SerialNumber | Where-Object SerialNumber -EQ ${SERIALNUM} | Select-Object -ExpandProperty Number)
$DRIVENUM = [int]${DRIVE}
# Get Drive letter with Get-Partition. You can use additional parameters if more than one partition exists.
$DRIVELETTER = $(Get-Partition -DiskNumber ${DRIVENUM} | Select-Object -ExpandProperty DriveLetter)
#$DRIVELETTER = $(Get-Volume -FileSystemLabel 'USB-BACKUP' | Select-Object 'DriveLetter' | Format-Wide | Out-String).Trim()
#
$SRC = "${env:HOMEDRIVE}${env:HOMEPATH}\"
$DSTDRIVE = "${DRIVELETTER}:\"
$LOGFOLDER = "${DSTDRIVE}backuplog\"
#$DST = "${DSTDRIVE}$env:USERNAME\"

### Create function to calculate Days in range
function Get-DaysDiff()
{
    param ([datetime]$start, [datetime]$end)
    return (NEW-TIMESPAN -Start $start -End $end).Days
}

### Use the creation timestamp of log file
$LASTLOG_MM = (Get-ChildItem -Path $LOGFOLDER | Sort-Object LastAccessTime | Select-Object -Last 1 | Select-Object {$_.CreationTime.Month} | Format-Table -HideTableHeaders | Format-Wide | Out-String).Trim()
$LASTLOG_DD = (Get-ChildItem -Path $LOGFOLDER | Sort-Object LastAccessTime | Select-Object -Last 1 | Select-Object {$_.CreationTime.Day}   | Format-Table -HideTableHeaders | Format-Wide | Out-String).Trim()
$LASTLOG_YY = (Get-ChildItem -Path $LOGFOLDER | Sort-Object LastAccessTime | Select-Object -Last 1 | Select-Object {$_.CreationTime.Year}  | Format-Table -HideTableHeaders | Format-Wide | Out-String).Trim()

### Create a 'TODAY' variabe
$TODAY = $(Get-Date -UFormat "%d/%m/%Y")

### Create a TIMESTAMP for the log file
$TSLOG = (Get-Date -Format "yyyyMMdd")

### Create LATEST variable from the previous code mess above
$LATEST = $(Get-Date -Year $LASTLOG_YY -Month $LASTLOG_MM -Day $LASTLOG_DD).ToShortDateString()
$MAXDATEAGE = (Get-DaysDiff ${TODAY} ${LATEST})

### Create the backup log file
$BACKUPLOG = (Write-Output ${LOGFOLDER}${TSLOG}-BACKUP.LOG)

Write-Output "Last Backup was ${MAXDATEAGE} ago"
### Execute robocopy
robocopy ${SRC} ${DSTDRIVE}${TSLOG}\ *.* /MIR /W:0 /R:0 /XJ /XD "${env:HOMEDRIVE}${env:HOMEPATH}\AppData" /TEE /LOG:${BACKUPLOG} /MAXAGE:${MAXDATEAGE}
