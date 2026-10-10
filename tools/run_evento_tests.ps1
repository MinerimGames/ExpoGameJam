param([ValidateSet('Input','OnScreenControls','Battle','Ambient','Integration','Visual','Castle','Route','Guard','Royal','Autumn','Skip','Peasants','City','Progression','PlayerArt','Newton','MapSafety','Scenery','Presentation','BattleFacing','EvilNewton','Audio','CombatMotion','MenuPoster','Epilogue','Credits','Steampunk','CityFlags','VictoryPortals','Release','CombatProgression','UIScaling','All')][string]$Suite='All', [string]$WorkspaceDirectory='', [string]$Configuration='EventoTests')
$ErrorActionPreference='Stop'
$root=Split-Path $PSScriptRoot -Parent
$runtime='C:/ProgramData/GameMakerStudio2-LTS2026/Cache/runtimes/runtime-2026.0.0.23'
$igor=Join-Path $runtime 'bin/igor/windows/x64/Igor.exe'
$runner=Join-Path $runtime 'windows/x64/Runner.exe'
$pythonExecutable=(Get-Command python -ErrorAction SilentlyContinue).Source
if(-not $pythonExecutable){$pythonExecutable=Join-Path $env:USERPROFILE '.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'}
if(-not (Test-Path -LiteralPath $pythonExecutable)){throw 'Python instalado não encontrado.'}
$suites=if($Suite -eq 'All'){@('Input','OnScreenControls','Battle','Ambient','Integration','Castle','Route','Guard','Royal','Autumn','Skip','Peasants','City','Progression','PlayerArt','Newton','MapSafety','Scenery','Presentation','BattleFacing','EvilNewton','Audio','CombatMotion','MenuPoster','Epilogue','Credits','Steampunk','CityFlags','VictoryPortals','Release','CombatProgression','UIScaling')}else{@($Suite)}
$shared=if($WorkspaceDirectory){$WorkspaceDirectory}elseif($Suite -eq 'All'){Join-Path $env:TEMP ('paradoxo-evento-tests/All-'+[guid]::NewGuid().ToString('N'))}else{''}
$runName='run-'+(Get-Date -Format 'yyyyMMdd-HHmmss')
foreach($current in $suites) {
    $work=if($shared){Join-Path $shared "$runName/$current"}else{Join-Path $env:TEMP ('paradoxo-evento-tests/'+$current+'-'+[guid]::NewGuid().ToString('N'))}
    New-Item -ItemType Directory -Path $work -Force | Out-Null
    # Suites run sequentially, so their generated project/cache can be reused.
    # Keep each suite's diagnostics separate without duplicating all assets.
    $workspace=if($shared){$shared}else{$work}
    & $pythonExecutable (Join-Path $PSScriptRoot 'evento_project.py') $root (Join-Path $workspace 'project') $current
    if($LASTEXITCODE -ne 0){throw 'Falha na preparação do projeto de teste.'}
    $binary=Join-Path $workspace 'ParadoxoDeWilson.win'
    & $igor "--project=$workspace/project/ParadoxoDeWilson.yyp" "--runtimePath=$runtime" "--user=$env:APPDATA/GameMakerStudio2-LTS2026/unknownUser_unknownUserID" '--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs' "--cache=$workspace/cache" "--temp=$workspace/temp" '--runtime=VM' "--config=$Configuration" "--of=$binary" windows Compile *> (Join-Path $work 'compile.log')
    if($LASTEXITCODE -ne 0){Get-Content (Join-Path $work 'compile.log') -Tail 30; throw "Compilação de $current falhou. Log: $work/compile.log"}
    $stdout=Join-Path $work 'runner.log'
    $stderr=Join-Path $work 'runner-error.log'
    $proc=Start-Process -FilePath $runner -ArgumentList @('-game',('"'+$binary+'"')) -WorkingDirectory $work -WindowStyle Hidden -RedirectStandardOutput $stdout -RedirectStandardError $stderr -PassThru
    if($current -eq 'Visual'){Write-Output "VISUAL_PID: $($proc.Id)"; Write-Output "LOG: $work"; exit 0}
    # Include the additional mask reveal and silence in the real-time ending.
    $taskTestTimeout=if($current -eq 'Epilogue'){150000}else{60000}
    if(-not $proc.WaitForExit($taskTestTimeout)){Stop-Process -Id $proc.Id; throw "Timeout em $current. Logs: $work"}
    $log=(Get-Content -LiteralPath $stdout -Raw -ErrorAction SilentlyContinue)+(Get-Content -LiteralPath $stderr -Raw -ErrorAction SilentlyContinue)
    $log -split "`n" | Where-Object {$_ -match 'EVENTO_TEST_|STRATEGY_|AMBIENT_'} | Write-Output
    Write-Output "LOG: $work"
    if($log -notmatch 'EVENTO_TEST_PASS' -or $log -match 'EVENTO_TEST_FAIL|ERROR!!!|FATAL ERROR'){throw "Testes $current falharam."}
}
