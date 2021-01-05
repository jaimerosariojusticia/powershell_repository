<#
	This is a robocopy backup script that uses a fixed destination in the $BACKUPDISK string.
	This can be changed with whatever variable you want. Currently, this is my current
	set as it looks no matter which drive letter it has, my backup device uses a specific label.
	
	It creates an incremental folder for each run. Each folder uses a "YEAR-MONTH-DATE" format.
	Also creates a folder named 'backuplog' where it stores logs from each run.
	
	Try it and tweak it as you need.
	
	This current settings work for me.
	
	-Jaime Rosario Justicia
#>

### Set variables
# You may want to modify 
$BACKUPDISK = $(Get-Volume -FileSystemLabel 'USB-BACKUP' | Select-Object 'DriveLetter' | Format-Wide | Out-String).Trim()
#
$SRC = "${env:HOMEDRIVE}${env:HOMEPATH}\"
#
$DSTDRIVE = "${BACKUPDISK}:\"
#
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

### Create LASTDATE variable from the previous code mess above
$LASTDATE = $(Get-Date -Year $LASTLOG_YY -Month $LASTLOG_MM -Day $LASTLOG_DD).ToShortDateString()

### 
$MAXDATEAGE = (Get-DaysDiff ${TODAY} ${LASTDATE})

### Create the backup log file
$BACKUPLOG = (Write-Output ${LOGFOLDER}${TSLOG}-BACKUP.LOG)

Write-Output "Last Backup was ${MAXDATEAGE} ago"
### Execute robocopy
robocopy ${SRC} ${DSTDRIVE}${TSLOG}\ *.* /MIR /W:0 /R:0 /XJ /XD "${env:HOMEDRIVE}${env:HOMEPATH}\AppData" /LOG:${BACKUPLOG} /MAXAGE:${MAXDATEAGE}
