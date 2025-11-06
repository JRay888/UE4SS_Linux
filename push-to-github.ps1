# Push to GitHub Script
# Run this after you create your GitHub repository

Write-Host "===============================================" -ForegroundColor Cyan
Write-Host "   UE4SS Linux Port - Push to GitHub" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Check if we're in a git repo
if (-not (Test-Path .git)) {
    Write-Host "ERROR: Not in a git repository!" -ForegroundColor Red
    exit 1
}

Write-Host "Before running this script, you need to:" -ForegroundColor Yellow
Write-Host "1. Create a GitHub account at https://github.com (if you don't have one)" -ForegroundColor Yellow
Write-Host "2. Create a new repository" -ForegroundColor Yellow
Write-Host "3. Copy the repository URL" -ForegroundColor Yellow
Write-Host ""
Write-Host "IMPORTANT: Link your GitHub account to Epic Games!" -ForegroundColor Red
Write-Host "This is required for Unreal Engine submodules to work." -ForegroundColor Red
Write-Host ""

# Prompt for GitHub URL
$githubUrl = Read-Host "Enter your GitHub repository URL (e.g., https://github.com/username/repo-name.git)"

if ([string]::IsNullOrWhiteSpace($githubUrl)) {
    Write-Host "ERROR: No URL provided!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Using repository: $githubUrl" -ForegroundColor Green
Write-Host ""

# Add remote
Write-Host "Adding GitHub remote..." -ForegroundColor Cyan
git remote remove origin 2>$null # Remove if exists
git remote add origin $githubUrl

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to add remote!" -ForegroundColor Red
    exit 1
}

# Set default branch to main
Write-Host "Setting default branch to main..." -ForegroundColor Cyan
git branch -M main

# Push to GitHub
Write-Host ""
Write-Host "Pushing to GitHub..." -ForegroundColor Cyan
Write-Host "You may be prompted for your GitHub credentials." -ForegroundColor Yellow
Write-Host ""

git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host "   SUCCESS! Code pushed to GitHub!" -ForegroundColor Green
    Write-Host "===============================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Go to your GitHub repository" -ForegroundColor White
    Write-Host "2. Click 'Actions' tab" -ForegroundColor White
    Write-Host "3. Watch the automated build run!" -ForegroundColor White
    Write-Host ""
    Write-Host "The .github/workflows/build-linux.yml file will automatically trigger the build." -ForegroundColor Green
    Write-Host ""
    Write-Host "REMINDER: Make sure your GitHub account is linked to Epic Games!" -ForegroundColor Yellow
    Write-Host "Go to: epicgames.com → Account → Connections → GitHub" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "ERROR: Push failed!" -ForegroundColor Red
    Write-Host "This might be due to:" -ForegroundColor Yellow
    Write-Host "- Wrong credentials" -ForegroundColor Yellow
    Write-Host "- Wrong repository URL" -ForegroundColor Yellow
    Write-Host "- Network issues" -ForegroundColor Yellow
    Write-Host "- Need to use Personal Access Token instead of password" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Try running: git push -u origin main" -ForegroundColor Cyan
    exit 1
}
