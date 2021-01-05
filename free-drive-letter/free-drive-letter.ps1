# Get first free drive letter from H to Z
$FreeDrive=(Get-ChildItem function:[H-Z]: -n | Where-Object{ !(Test-Path $_) } | Select-Object -First 1)
$FreeDrive