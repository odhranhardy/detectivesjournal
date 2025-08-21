# PowerShell script to recreate Detective's Journal folder structure
# Run this from your DetectivesJournal project root directory

Write-Host "Creating Detective's Journal folder structure..." -ForegroundColor Green

# Create all missing folders
$folders = @(
    "assets\images\ui",
    "assets\images\characters", 
    "assets\images\locations",
    "assets\audio\sfx",
    "assets\audio\music",
    "assets\fonts",
    "scenes\ui",
    "scenes\investigation", 
    "scenes\menus",
    "scripts\ui",
    "scripts\investigation",
    "scripts\data",
    "data\cases",
    "data\characters",
    "data\save_data"
)

foreach ($folder in $folders) {
    if (!(Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force
        Write-Host "Created: $folder" -ForegroundColor Cyan
    } else {
        Write-Host "Already exists: $folder" -ForegroundColor Yellow
    }
}

# Optional: Create .gitkeep files to track empty folders in Git
Write-Host "`nCreating .gitkeep files for Git tracking..." -ForegroundColor Green
foreach ($folder in $folders) {
    $gitkeepPath = Join-Path $folder ".gitkeep"
    if (!(Test-Path $gitkeepPath)) {
        New-Item -ItemType File -Path $gitkeepPath -Force | Out-Null
        Write-Host "Created .gitkeep in: $folder" -ForegroundColor Cyan
    }
}

Write-Host "`nFolder structure created successfully! 🎉" -ForegroundColor Green
Write-Host "You can now continue with your Godot development." -ForegroundColor White