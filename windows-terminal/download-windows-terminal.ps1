<# 
    Simple script to download latest release of Windows Terminal
    Don't expect fancy and polished stuff here.
    This was done in a hurry. This only downloads the file.
    If you don't like it, google for other authors with better scripting skills,
    or improve with the current code or idea.
	It's not perfect, but it worked for me.
    - Jaime Rosario Justicia
#>

$URL = 'https://github.com/microsoft/terminal/releases/latest'

$DLINK = ((Invoke-WebRequest -Uri $URL -UseBasicParsing | `
Select-String 'msixbundle' -SimpleMatch | Out-String -Stream | `
Select-String 'Microsoft.WindowsTerminal' | Select-Object -First 1 | `
Out-String).Trim().Split('"'))[1]

$DDOM = 'https://github.com'

$LINK = (-join ($DDOM.ToString(),$DLINK.ToString()) | Out-String -Stream)

$OUTFILE = ($LINK).Trim().Split("/")[8]

Write-Output "Downloading from: $LINK"
Write-Output "File: $OUTFILE"

Invoke-WebRequest -Uri $LINK -OutFile $OUTFILE