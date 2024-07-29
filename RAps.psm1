# .ExternalHelp RAps-help.xml

$files = Get-ChildItem -Path $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.Tests.ps1'

foreach ($file in $files) {
    . $file.FullName
}