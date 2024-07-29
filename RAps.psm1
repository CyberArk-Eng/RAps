# .ExternalHelp AleroPS-help.xml

$files = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse -File -Force | Where-Object {$PSItem.Fullname -notlike "*Tests*"}

foreach ($file in $files) {
    . $file.FullName
}