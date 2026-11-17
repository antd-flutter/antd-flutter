# gen_docs.ps1 - 文档生成命令（dart doc + API 索引 + 单轨一致性校验）
# 用法: .\scripts\gen_docs.ps1 [-Pkg <name>] [-CheckOnly] [-SkipDartDoc]
# 平台: Windows 完整实现（与 gen_docs.sh / gen_docs.bat 逻辑一致）
[CmdletBinding()]
param(
  [string]$Pkg = "",
  [switch]$CheckOnly,
  [switch]$SkipDartDoc
)

$ErrorActionPreference = "Stop"
$INFO = "[信息]"; $OK = "[成功]"; $WARN = "[警告]"; $ERR = "[错误]"; $DONE = "[完成]"

# 定位工作区根（脚本位于 <root>\scripts\）
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Root = Split-Path -Parent $ScriptDir
Set-Location $Root

# dart 探测：fvm 优先，其次 PATH（真实路径）
$DartCmd = $null
$fvmDart = Join-Path $env:USERPROFILE "fvm\default\bin\dart.bat"
if (Test-Path $fvmDart) {
  $DartCmd = @($fvmDart)
} elseif (Get-Command fvm -ErrorAction SilentlyContinue) {
  $DartCmd = @("fvm", "dart")
} elseif (Get-Command dart -ErrorAction SilentlyContinue) {
  $DartCmd = @((Get-Command dart).Source)
}
if (-not $DartCmd) {
  Write-Output "$ERR 未找到 dart（fvm 或 PATH 均不可用）"
  exit 1
}
Write-Output "$INFO 使用 dart: $($DartCmd -join ' ')"

function Invoke-Dart {
  param([string[]]$DartArgs)
  if ($DartCmd.Count -gt 1) {
    & $DartCmd[0] $DartCmd[1..($DartCmd.Count-1)] @DartArgs
  } else {
    & $DartCmd[0] @DartArgs
  }
}

$PackagesDir = Join-Path $Root "packages"

# 参数校验
if ($Pkg -and -not (Test-Path (Join-Path $PackagesDir $Pkg))) {
  Write-Output "$ERR 未知包: $Pkg"
  exit 2
}

# 依赖解析（提取脚本依赖 analyzer dev 依赖）
if (-not $CheckOnly) {
  $pkgConfig = Join-Path $Root ".dart_tool\package_config.json"
  $needGet = $true
  if (Test-Path $pkgConfig) {
    if ((Get-Content $pkgConfig -Raw) -match '"name": "analyzer"') { $needGet = $false }
  }
  if ($needGet) {
    Write-Output "$INFO 解析依赖（flutter pub get）..."
    flutter pub get
    if ($LASTEXITCODE -ne 0) { Write-Output "$ERR flutter pub get 失败"; exit 1 }
  }
}

$Failed = 0

# 步骤 1: dart doc（产物 doc/api/，已 gitignore）
if (-not $CheckOnly -and -not $SkipDartDoc) {
  $dirs = @(".")
  if ($Pkg) { $dirs += $Pkg } else {
    $dirs += (Get-ChildItem -Directory $PackagesDir | ForEach-Object { $_.Name })
  }
  $TargetsText = ($dirs -join ", ")
  Write-Output "$INFO 步骤 1/3: dart doc（$TargetsText）"
  foreach ($d in $dirs) {
    Write-Output "$INFO dart doc: $d"
    $dir = Join-Path $Root $d
    Push-Location $dir
    Invoke-Dart @("doc", "--output", "doc/api")
    if ($LASTEXITCODE -ne 0) { Write-Output "$ERR dart doc 失败: $d"; $Failed = 1 }
    Pop-Location
  }
} else {
  Write-Output "$INFO 跳过 dart doc（-CheckOnly 或 -SkipDartDoc）"
}

# 步骤 2+3: API 索引提取 + 一致性校验
Write-Output "$INFO 步骤 2/3: 生成 docs/api-index.md + docs\api\*.md 并执行步骤 3/3 一致性校验"
$extractArgs = @("run", "scripts/gen_docs_extract.dart", "--root", $Root)
if ($CheckOnly) { $extractArgs += "--check-only" }
if ($Pkg) { $extractArgs += @("--pkg", $Pkg) }

Invoke-Dart $extractArgs
$extractExit = $LASTEXITCODE
if ($extractExit -ne 0) {
  Write-Output "$ERR 一致性校验未通过（缺失/多余 API 清单见上方输出），退出码 $extractExit"
  exit $extractExit
}
if ($Failed -ne 0) {
  Write-Output "$ERR 存在 dart doc 失败的包"
  exit 1
}

Write-Output "$DONE gen-docs 完成"
exit 0
