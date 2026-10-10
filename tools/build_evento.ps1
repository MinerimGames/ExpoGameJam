param([string]$OutputDirectory='')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
if(-not $OutputDirectory){$OutputDirectory=Join-Path $env:LOCALAPPDATA ('CodexBuilds/ParadoxoDeWilson/evento-'+(Get-Date -Format 'yyyyMMdd-HHmmss'))}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$OutputDirectory=(Resolve-Path -LiteralPath $OutputDirectory).Path
$runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23'
& (Join-Path $runtime 'bin/igor/windows/x64/Igor.exe') "--project=$root/ParadoxoDeWilson.yyp" "--runtimePath=$runtime" "--user=$env:APPDATA/GameMakerStudio2-LTS2026/unknownUser_unknownUserID" '--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs' "--cache=$OutputDirectory/cache" "--temp=$OutputDirectory/temp" '--runtime=VM' '--config=Default' "--of=$OutputDirectory/ParadoxoDeWilson.win" windows Compile *> (Join-Path $OutputDirectory 'compile.log')
Get-Content (Join-Path $OutputDirectory 'compile.log') -Tail 6
if($LASTEXITCODE -ne 0){throw "Compilação falhou. Log: $OutputDirectory/compile.log"}
if(-not (Test-Path -LiteralPath (Join-Path $OutputDirectory 'ParadoxoDeWilson.win'))){throw 'Binário compilado não encontrado.'}
Write-Output "BUILD: $OutputDirectory"
