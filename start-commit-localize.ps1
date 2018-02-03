cd $args[2]

# Localization

# Compatible with Unicode file names
[Console]::OutputEncoding = [Text.Encoding]::UTF8

$status = git status -s
$modifiedResources = echo $status | Select-String "M 鼠标配合-工作.ahk" #doesn't end with like pl.ahk
Foreach( $modifiedResource in $modifiedResources)
{
    $relativePath = $modifiedResource.Matches[0].Groups[1].Value
    echo $relativePath
    if($status -match [Regex]::Escape("work.en.ahk"))
    {
        Write-Host "Skip translating because work.en.ahk has been modified."
        continue
    }



    $originalName= -Join($relativePath,".resx")
    git diff $originalName |
    Translator.exe --keyValuePattern "(?<=;\s*)((?!\s).+)(?=\s*$)"  `
                   --source 鼠标配合-工作.ahk:zh `
                   --target work.en.ahk:en `
                   --apiToken  AIzaSyDYLhOjj3KnCAp33VvsVlQCGxa1TmrslQE


    echo "`nwork.en.ahk is translated by Google" | Out-File  $args[1] -Encoding ascii -Append

}
