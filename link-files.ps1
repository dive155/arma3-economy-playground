# Get script location
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define relative paths
$source = Join-Path $scriptRoot "economy_test.VR"
$destination = Join-Path $scriptRoot "symlinks_test.Stratis"

# Files to exclude (case-insensitive)
$excludedFiles = @("mission.sqm", "description.ext", "init.sqf", "initPlayerLocal.sqf")

# Recursively process all files in source
Get-ChildItem -Path $source -Recurse -File | ForEach-Object {
    $relativePath = $_.FullName.Substring($source.Length).TrimStart('\')
    $targetPath = Join-Path -Path $destination -ChildPath $relativePath

    if ($excludedFiles -notcontains $_.Name.ToLower()) {
        # Ensure target directory exists
        $targetDir = Split-Path -Path $targetPath
        if (-not (Test-Path -Path $targetDir)) {
            New-Item -Path $targetDir -ItemType Directory -Force | Out-Null
        }

        # Only create the hard link if the file doesn't already exist
        if (-not (Test-Path -Path $targetPath)) {
            cmd /c mklink /H "$targetPath" "$($_.FullName)"
        }
    }
}
