<# 
Download latest Virtualbox for Windows  
#>

$URL = "https://www.virtualbox.org/wiki/Downloads"

$FILES = ((Invoke-WebRequest -Uri $URL -UseBasicParsing | `
Select-String "ext-link" -SimpleMatch | `
Out-String -Stream).Trim().Split('"') | `
Select-String "download.virtualbox.org/virtualbox" -SimpleMatch | `
Select-String "ex" | Sort-Object -Unique)

foreach ($FILE in $FILES) {
    $OUTFILE = ($FILE.ToString().Split("/")[5])
    if ($PSVersionTable.PSVersion.Major -le 5)
        { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 }
    Invoke-WebRequest -Uri ($FILE.ToString()) -OutFile $OUTFILE
}