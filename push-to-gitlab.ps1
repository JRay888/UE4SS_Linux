# Push to GitLab Script
# Run this after you create your GitLab repository

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   UE4SS Linux Port - Push to GitLab" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in a git repo
if (-not (Test-Path .git)) {
    Write-Host "ERROR: Not in a git repository!" -ForegroundColor Red
    exit 1
}

Write-Host "Before running this script, you need to:" -ForegroundColor Yellow
Write-Host "1. Create a GitLab account at https://gitlab.com" -ForegroundColor Yellow
Write-Host "2. Create a new project/repository" -ForegroundColor Yellow
Write-Host "3. Copy the repository URL" -ForegroundColor Yellow
Write-Host ""

# Prompt for GitLab URL
$gitlabUrl = Read-Host "Enter your GitLab repository URL (e.g., https://gitlab.com/username/repo-name.git)"

if ([string]::IsNullOrWhiteSpace($gitlabUrl)) {
    Write-Host "ERROR: No URL provided!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Using repository: $gitlabUrl" -ForegroundColor Green
Write-Host ""

# Add remote
Write-Host "Adding GitLab remote..." -ForegroundColor Cyan
git remote remove origin 2>$null # Remove if exists
git remote add origin $gitlabUrl

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to add remote!" -ForegroundColor Red
    exit 1
}

# Set default branch to main
Write-Host "Setting default branch to main..." -ForegroundColor Cyan
git branch -M main

# Push to GitLab
Write-Host ""
Write-Host "Pushing to GitLab..." -ForegroundColor Cyan
Write-Host "You may be prompted for your GitLab credentials." -ForegroundColor Yellow
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "   SUCCESS! Code pushed to GitLab!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Go to your GitLab project" -ForegroundColor White
    Write-Host "2. Click 'CI/CD' → 'Pipelines'" -ForegroundColor White
    Write-Host "3. Watch the automated build run!" -ForegroundColor White
    Write-Host ""
    Write-Host "The .gitlab-ci.yml file will automatically trigger the build." -ForegroundColor Green
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Push failed!" -ForegroundColor Red
    Write-Host "This might be due to:" -ForegroundColor Yellow
    Write-Host "- Wrong credentials" -ForegroundColor Yellow
    Write-Host "- Wrong repository URL" -ForegroundColor Yellow
    Write-Host "- Network issues" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Try running: git push -u origin main" -ForegroundColor Cyan
    exit 1
}
