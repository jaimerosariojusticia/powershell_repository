if (
	!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
		[Security.Principal.WindowsBuiltInRole] "Administrator")
	)
	{ Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$outputWindow = Start-Process powershell ' -NoExit -Command "[console]::windowwidth=100; [console]::windowheight=50; [console]::bufferwidth=[console]::windowwidth; attrib -r "C:\Windows\System32\drivers\etc\hosts"; While ($True) { Get-Content -Path "C:\Windows\System32\drivers\etc\hosts"; Start-Sleep -Seconds 3; Clear-Host; }" ' -PassThru
$outputWindow

$hostsfilelocation = "$env:windir\System32\drivers\etc\hosts"

notepad.exe $hostsfilelocation