
$ErrorActionPreference = "Stop"

# Project paths
$ProjectRoot = Split-Path -Parent $PSScriptRoot
$PolicyFile = Join-Path $ProjectRoot "governance\policies\landing_zone.rego"
$PlanFile = Join-Path $ProjectRoot "tfplan"
$PlanJson = Join-Path $ProjectRoot "plan.json"

Write-Host ""
Write-Host "========================================"
Write-Host " MINI AZURE LANDING ZONE"
Write-Host " GOVERNANCE POLICY GATE"
Write-Host "========================================"

# 1. Check Docker availability
Write-Host "`n[1/5] Checking Docker..."

docker info | Out-Null

if ($LASTEXITCODE -ne 0) {
    throw "Docker is unavailable."
}

# 2. Check required files
Write-Host "[2/5] Checking project files..."

if (!(Test-Path $PolicyFile)) {
    throw "OPA policy file not found."
}

if (!(Test-Path $PlanFile)) {
    throw "OpenTofu plan file not found. Generate a plan first."
}

# 3. Convert OpenTofu plan into JSON
Write-Host "[3/5] Generating plan JSON..."

$PlanOutput = & tofu show -json $PlanFile

if ($LASTEXITCODE -ne 0) {
    throw "Unable to convert OpenTofu plan."
}

$PlanOutput | Out-File -FilePath $PlanJson -Encoding utf8

if (!(Test-Path $PlanJson)) {
    throw "Plan JSON generation failed."
}

# 4. Evaluate OPA policy
Write-Host "[4/5] Evaluating governance policies..."

$DockerArgs = @(
    "run",
    "--rm",
    "--mount",
    "type=bind,source=$ProjectRoot,target=/project",
    "openpolicyagent/opa:latest",
    "eval",
    "--format",
    "json",
    "--data",
    "/project/governance/policies/landing_zone.rego",
    "--input",
    "/project/plan.json",
    "data.landingzone.deny"
)

$Result = & docker @DockerArgs

if ($LASTEXITCODE -ne 0) {
    throw "OPA evaluation failed."
}

# 5. Interpret policy results
Write-Host "[5/5] Checking compliance..."

try {
    $Evaluation = ($Result -join "`n") | ConvertFrom-Json
}
catch {
    throw "Unable to parse OPA evaluation output."
}

$Violations = @()

if ($Evaluation.result.Count -gt 0) {
    $Violations = @($Evaluation.result[0].expressions[0].value)
}

if ($Violations.Count -gt 0) {

    Write-Host ""
    Write-Host "POLICY GATE: FAILED" -ForegroundColor Red

    foreach ($Violation in $Violations) {
        Write-Host " - $Violation" -ForegroundColor Red
    }

    exit 1
}

Write-Host ""
Write-Host "POLICY GATE: PASSED" -ForegroundColor Green
Write-Host "All evaluated governance policies passed."
exit 0