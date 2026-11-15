
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot

Write-Host "===================================="
Write-Host " OPA NEGATIVE GOVERNANCE TEST"
Write-Host "===================================="

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
    "/project/tests/invalid-plan.json",
    "data.landingzone.deny"
)

$Result = & docker @DockerArgs

if ($LASTEXITCODE -ne 0) {
    throw "OPA evaluation failed."
}

$Evaluation = ($Result -join "`n") | ConvertFrom-Json

$Violations = @(
    $Evaluation.result[0].expressions[0].value
)

if ($Violations.Count -eq 0) {
    Write-Host "TEST FAILED: Invalid infrastructure was accepted." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Detected governance violations:"

foreach ($Violation in $Violations) {
    Write-Host " - $Violation" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "NEGATIVE TEST PASSED" -ForegroundColor Green
Write-Host "OPA successfully rejected non-compliant infrastructure."

exit 0
