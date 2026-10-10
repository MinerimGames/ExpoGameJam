param([string]$OutputDirectory='', [string]$Configuration='Default')
$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
$taskRuntime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23'
$taskProfiles=Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026'
$taskProfile=Get-ChildItem -LiteralPath $taskProfiles -Directory |
    Where-Object {Test-Path -LiteralPath (Join-Path $_.FullName 'licence.plist')} |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if(-not $taskProfile){throw 'Entre na sua conta dentro do GameMaker antes de exportar o executável. Nenhuma licença de exportação carregada foi encontrada.'}
$taskStamp=Get-Date -Format 'yyyyMMdd-HHmmss'
if(-not $OutputDirectory){$OutputDirectory=Join-Path $taskRoot ('dist/ParadoxoDeWilson-Windows-'+$taskStamp)}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$OutputDirectory=(Resolve-Path -LiteralPath $OutputDirectory).Path
$taskBuildHome=if($env:PARADOXO_BUILD_HOME){$env:PARADOXO_BUILD_HOME}else{Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson'}
$taskBuild=Join-Path $taskBuildHome ('export-'+$taskStamp)
New-Item -ItemType Directory -Path $taskBuild -Force | Out-Null
$taskCache=if($env:PARADOXO_CACHE_HOME){$env:PARADOXO_CACHE_HOME}else{Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson/evento-20261006-135421'}
$taskZip=Join-Path $OutputDirectory 'ParadoxoDeWilson.zip'
& (Join-Path $taskRuntime 'bin/igor/windows/x64/Igor.exe') "--project=$taskRoot/ParadoxoDeWilson.yyp" "--runtimePath=$taskRuntime" "--user=$($taskProfile.FullName)" "--licencefile=$($taskProfile.FullName)/licence.plist" '--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs' "--cache=$taskCache/cache" "--temp=$taskCache/temp" '--runtime=VM' "--config=$Configuration" "--of=$taskBuild/ParadoxoDeWilson.win" "--tf=$taskZip" windows PackageZip *> (Join-Path $OutputDirectory 'export.log')
if($LASTEXITCODE -ne 0){Get-Content (Join-Path $OutputDirectory 'export.log') -Tail 20;throw 'A exportação do GameMaker falhou. Consulte export.log.'}
if(-not (Test-Path -LiteralPath $taskZip)){throw 'O GameMaker não gerou o pacote esperado.'}
$taskGameFolder=Join-Path $OutputDirectory 'Jogo'
Expand-Archive -LiteralPath $taskZip -DestinationPath $taskGameFolder -Force
$taskExecutable=Get-ChildItem -LiteralPath $taskGameFolder -Filter 'ParadoxoDeWilson.exe' -Recurse | Select-Object -First 1
if(-not $taskExecutable){throw 'O pacote não contém o executável esperado.'}
Write-Output "EXECUTAVEL: $($taskExecutable.FullName)"
Write-Output "ZIP: $taskZip"
