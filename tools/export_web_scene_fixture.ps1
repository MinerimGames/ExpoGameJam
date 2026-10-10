$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
python (Join-Path $PSScriptRoot 'web_scene_fixture.py')
if($LASTEXITCODE -ne 0){throw 'Falha ao preparar verificação visual isolada.'}
$taskBuild=Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson/web-scene-fixture'
$taskWeb=Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson/web-scene-fixture-export'
New-Item -ItemType Directory -Path (Join-Path $taskBuild 'game') -Force | Out-Null
$taskRuntime=Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson/html5-runtime-install/runtime-2026.0.0.23'
$taskProfile=Get-ChildItem -LiteralPath (Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026') -Directory | Where-Object {Test-Path -LiteralPath (Join-Path $_.FullName 'licence.plist')} | Sort-Object LastWriteTime -Descending | Select-Object -First 1
& (Join-Path $taskRuntime 'bin/igor/windows/x64/Igor.exe') "--project=$taskBuild/project/ParadoxoDeWilson.yyp" "--runtimePath=$taskRuntime" "--user=$($taskProfile.FullName)" "--licencefile=$($taskProfile.FullName)/licence.plist" '--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs' "--cache=$taskBuild/cache" "--temp=$taskBuild/temp" '--runtime=VM' '--config=FinalRelease' "--of=$taskBuild/game/scene" "--tf=$taskWeb" html5 folder *> (Join-Path $taskBuild 'compile.log')
if($LASTEXITCODE -ne 0){Get-Content -LiteralPath (Join-Path $taskBuild 'compile.log') -Tail 20;throw 'Falha no teste HTML5 isolado.'}
Write-Output "FIXTURE: $taskWeb"
