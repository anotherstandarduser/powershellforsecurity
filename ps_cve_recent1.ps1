# Define the URL for retrieving the NVD data
$nvdApiUrl = "https://services.nvd.nist.gov/rest/json/cves/1.0"

# Specify parameters for the API request
$params = @{
    resultsPerPage = 100
    orderBy = "published"
    sortOrder = "desc"
}

try {
    # Invoke the API to retrieve CVE data
    $response = Invoke-RestMethod -Uri $nvdApiUrl -Method Get -Body $params

    # Define the file path to save the CVEs on the desktop
    $desktopPath = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Desktop)
    $filePath = Join-Path -Path $desktopPath -ChildPath "recent_cves.txt"

    # Open the text file for writing
    $file = [System.IO.File]::CreateText($filePath)

    # Extract and write the most recent CVEs to the file
    foreach ($entry in $response.result.CVE_Items) {
        $cveId = $entry.cve.CVE_data_meta.ID
        $description = $entry.cve.description.description_data[0].value

        # Write CVE ID and description to the file
        $file.WriteLine("CVE ID: $cveId")
        $file.WriteLine("Description: $description")
        $file.WriteLine()  # Add an empty line between CVEs
    }

    # Close the file
    $file.Close()
    Write-Host "100 most recent CVEs have been saved to $filePath"
} catch {
    Write-Host "An error occurred: $_"
}
