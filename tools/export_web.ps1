param([string]$OutputDirectory='', [string]$Configuration='Default')
$ErrorActionPreference='Stop'
$taskRoot=Split-Path $PSScriptRoot -Parent
$taskRuntime=Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson/html5-runtime-install/runtime-2026.0.0.23'
if(-not (Test-Path -LiteralPath (Join-Path $taskRuntime 'html5/scripts.html5.zip'))){
    throw 'O módulo HTML5 da versão 2026.0.0.23 deve ser instalado pelo Igor antes de exportar.'
}
$taskProfiles=Join-Path $env:APPDATA 'GameMakerStudio2-LTS2026'
$taskProfile=Get-ChildItem -LiteralPath $taskProfiles -Directory |
    Where-Object {Test-Path -LiteralPath (Join-Path $_.FullName 'licence.plist')} |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1
if(-not $taskProfile){throw 'Licença de exportação do GameMaker não encontrada.'}
$taskStamp=Get-Date -Format 'yyyyMMdd-HHmmss'
if(-not $OutputDirectory){$OutputDirectory=Join-Path $taskRoot ('dist/ParadoxoDeWilson-Web-'+$taskStamp)}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$OutputDirectory=(Resolve-Path -LiteralPath $OutputDirectory).Path
$taskBuildHome=if($env:PARADOXO_BUILD_HOME){$env:PARADOXO_BUILD_HOME}else{Join-Path $env:LOCALAPPDATA 'CodexBuilds/ParadoxoDeWilson'}
$taskBuild=Join-Path $taskBuildHome ('html5-export-'+$taskStamp)
New-Item -ItemType Directory -Path $taskBuild -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $taskBuild 'game') -Force | Out-Null
$taskWebFolder=Join-Path $OutputDirectory 'Web'
$taskLog=Join-Path $OutputDirectory 'export-web.log'
& (Join-Path $taskRuntime 'bin/igor/windows/x64/Igor.exe') "--project=$taskRoot/ParadoxoDeWilson.yyp" "--runtimePath=$taskRuntime" "--user=$($taskProfile.FullName)" "--licencefile=$($taskProfile.FullName)/licence.plist" '--prefabs=C:/ProgramData/GameMakerStudio2-LTS2026/Prefabs' "--cache=$taskBuild/cache" "--temp=$taskBuild/temp" '--runtime=VM' "--config=$Configuration" "--of=$taskBuild/game/ParadoxoDeWilson" "--tf=$taskWebFolder" html5 folder *> $taskLog
if($LASTEXITCODE -ne 0){Get-Content -LiteralPath $taskLog -Tail 25;throw 'A exportação HTML5 falhou. Consulte export-web.log.'}
if(-not (Test-Path -LiteralPath (Join-Path $taskWebFolder 'index.html'))){throw 'O GameMaker não gerou index.html.'}
$taskIndex=Join-Path $taskWebFolder 'index.html'
$taskHtml=[IO.File]::ReadAllText($taskIndex).Replace('lang="en"','lang="pt-BR"').Replace('background: #0;','background: #140c20;').Replace('image-rendering: optimizeSpeed;','image-rendering: pixelated;')
$taskStyle='<style>html,body{width:100%;height:100%;overflow:hidden}#canvas{max-width:100vw;max-height:100vh;object-fit:contain}</style><script>window.addEventListener("keydown",function(){if(typeof g_WebAudioContext!=="undefined"&&g_WebAudioContext&&g_WebAudioContext.state==="suspended"){g_WebAudioContext.resume().catch(function(){});}});</script>'
$taskStyle+='<script defer src="web_fullscreen.js"></script>'
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'web_fullscreen.js') -Destination (Join-Path $taskWebFolder 'web_fullscreen.js')
$taskHtml=$taskHtml.Replace('</head>',($taskStyle+[Environment]::NewLine+'</head>'))
[IO.File]::WriteAllText($taskIndex,$taskHtml,[Text.UTF8Encoding]::new($false))
python (Join-Path $PSScriptRoot 'verify_web_export_syntax.py') (Join-Path $taskWebFolder 'html5game/ParadoxoDeWilson.js')
if($LASTEXITCODE -ne 0){throw 'O JavaScript exportado não passou na verificação de sintaxe.'}
Write-Output "WEB: $taskWebFolder"
