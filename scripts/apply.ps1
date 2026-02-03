Param(
  [Parameter(Mandatory=$true)][ValidateSet("node","python")] [string]$Type,
  [Parameter(Mandatory=$true)][string]$Target,
  [Parameter(Mandatory=$true)][string]$Owner,
  [Parameter(Mandatory=$true)][string]$Repo,
  [switch]$RepoBaseline
)

New-Item -ItemType Directory -Force -Path (Join-Path $Target ".github\workflows") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Target ".github") | Out-Null

# 1) CI caller
if ($Type -eq "node") {
  Copy-Item "scaffolds\node\ci.yml" (Join-Path $Target ".github\workflows\ci.yml") -Force
} else {
  Copy-Item "scaffolds\python\ci.yml" (Join-Path $Target ".github\workflows\ci.yml") -Force
}

# 2) Always-on callers
Copy-Item "scaffolds\repo-hygiene.yml" (Join-Path $Target ".github\workflows\repo-hygiene.yml") -Force
Copy-Item "scaffolds\dependabot.yml" (Join-Path $Target ".github\dependabot.yml") -Force

# 3) CodeQL (language-specific scaffold)
if ($Type -eq "node") {
  Copy-Item "scaffolds\codeql-js-ts.yml" (Join-Path $Target ".github\workflows\codeql.yml") -Force
} else {
  Copy-Item "scaffolds\codeql-python.yml" (Join-Path $Target ".github\workflows\codeql.yml") -Force
}

# 4) Optional repo baseline
if ($RepoBaseline) {
  foreach ($p in @(".editorconfig", ".gitattributes", ".gitignore")) {
    $dest = Join-Path $Target $p
    if (-not (Test-Path $dest)) {
      Copy-Item (Join-Path "scaffolds\repo" $p) $dest -Force
    }
  }

  $codeownersDest = Join-Path $Target ".github\CODEOWNERS"
  if (-not (Test-Path $codeownersDest)) {
    Copy-Item "scaffolds\repo\CODEOWNERS" $codeownersDest -Force
  }
}

# 5) Replace placeholders
$filesToReplace = @(
  (Join-Path $Target ".github\workflows\ci.yml"),
  (Join-Path $Target ".github\workflows\repo-hygiene.yml"),
  (Join-Path $Target ".github\workflows\codeql.yml"),
  (Join-Path $Target ".github\CODEOWNERS")
)

foreach ($p in $filesToReplace) {
  if (Test-Path $p) {
    (Get-Content $p) -replace "<OWNER>", $Owner -replace "<REUSABLE_WORKFLOWS_REPO>", $Repo | Set-Content $p
  }
}

Write-Host "✅ Applied reusable-workflows scaffolds to: $Target"
Write-Host "Next: commit and push from the target repo."
