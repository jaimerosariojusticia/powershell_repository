<#
	This is a powershell script that combines a series of destinations in an array.
	This is useful if, for example, you have multiple backup or online storage services,
	and want to backup a source folder to multiple destinations.
	
	Copying my documents folder to OneDrive, GoogleDrive, USB jumpdrive and NAS in one
	script using array.
	If the destination is not reachable or available, it will skip it.
	You can modify to create the destination.
	
	It works for me.
	-Jaime Rosario Justicia
#>

## Source
$SRC = "$env:USERPROFILE\Documents\"

$DEST = @(
    "$env:USERPROFILE\Google Drive\Documents\",
    "$env:USERPROFILE\OneDrive\Documents\",
    "G:\USB-BACKUP\$env:USERNAME\Documents\",
    "\\NAS-SERVER\\$env:USERNAME\Documents\"
    )
foreach ($DST in $DEST) {
    if (-not (Test-Path -LiteralPath "$DST")) { "Skipping folder $DST..." }
    else { robocopy "$SRC" "$DST" /MIR /R:0 /W:0 }
}
