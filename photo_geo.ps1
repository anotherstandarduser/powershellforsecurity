# Set the path for the user's profile directory
$userProfilePath = [System.Environment]::GetFolderPath('UserProfile')

# Set the path for the desktop folder
$desktopPath = [System.Environment]::GetFolderPath('Desktop')

# Define the path for the text file where we'll list the found photos
$resultFile = Join-Path -Path $desktopPath -ChildPath "PhotosWithLocation.txt"

# Function to check if a file contains location metadata
function ContainsLocationMetadata($file) {
    try {
        $image = [System.Drawing.Bitmap]::FromFile($file)
        $propertyItems = $image.PropertyItems
        foreach ($propertyItem in $propertyItems) {
            if ($propertyItem.Id -eq 0x927C) { # Location metadata tag
                return $true
            }
        }
        return $false
    }
    catch {
        return $false
    }
}

# Recursively search for photos with location metadata in the user's profile directory and output to the text file
Get-ChildItem -Path $userProfilePath -Recurse -Include *.jpg, *.jpeg, *.png, *.gif, *.bmp, *.tiff, *.heif | ForEach-Object {
    if (ContainsLocationMetadata $_.FullName) {
        # Add the file to the result list
        $_.FullName | Out-File -Append -FilePath $resultFile
    }
}

Write-Host "Search complete. List of photos with location metadata saved to: $resultFile"
