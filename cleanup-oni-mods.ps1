# Paths to the files
$MODS_FILE = "$env:USERPROFILE\AppData\LocalLow\Klei\Oxygen Not Included\mods\mods.json"
$WORKSHOP_FILE = "$env:USERPROFILE\AppData\LocalLow\Klei\Oxygen Not Included\mods\Steam\appworkshop_457140.acf"
$MOD_FOLDER = "$env:USERPROFILE\AppData\LocalLow\Klei\Oxygen Not Included\mods\Steam"

# Check if the files exist
if (-Not (Test-Path $MODS_FILE)) {
    Write-Host "File $MODS_FILE not found."
    exit 1
}

if (-Not (Test-Path $WORKSHOP_FILE)) {
    Write-Host "File $WORKSHOP_FILE not found."
    exit 1
}

# Extract mod IDs from the original mods.json
$MOD_IDS = (Get-Content $MODS_FILE | ConvertFrom-Json).mods.label.id

# Modify mods.json to keep only the required mod and decrement its version
$modsJson = Get-Content $MODS_FILE | ConvertFrom-Json
$modToKeep = $modsJson.mods | Where-Object { $_.label.id -eq "1843965353" }
$modToKeep.label.version -= 1
$modsJson.mods = @($modToKeep)
$modsJson | ConvertTo-Json | Set-Content $MODS_FILE

# Function to delete blocks from the file using PowerShell
function Delete-Block {
    param (
        [string]$file,
        [string]$id
    )
    $inBlock = $false
    $lines = Get-Content $file
    $newLines = @()
    
    foreach ($line in $lines) {
        if ($line -match '"\s*' + [regex]::Escape($id) + '\s*"') {
            $inBlock = $true
        }
        if (-not $inBlock) {
            $newLines += $line
        }
        if ($inBlock -and $line -match '^\s*\}$') {
            $inBlock = $false
        }
    }
    
    $newLines | Set-Content $file
}

# Delete entries from appworkshop_457140.acf
foreach ($MOD_ID in $MOD_IDS) {
    Write-Host "Deleting block for mod $MOD_ID"
    Delete-Block -file $WORKSHOP_FILE -id $MOD_ID
    Write-Host "Deleting mod folder $MOD_FOLDER\$MOD_ID"
    Remove-Item -Recurse -Force "$MOD_FOLDER\$MOD_ID"
}

Write-Host "Files have been updated."
