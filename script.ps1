$tee = Invoke-WebRequest -Uri https://api.github.com/repos/Microsoft/team-explorer-everywhere/releases/latest -UseBasicParsing | ConvertFrom-Json

$homebrew = Invoke-WebRequest -Uri https://api.github.com/repos/Homebrew/homebrew-core/contents/Formula/tee-clc.rb -UseBasicParsing | ConvertFrom-Json

$contents = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($homebrew.content))

$hbVersionLine = $contents.split("`n")
$hbVersion = $hbVersionLine[3].Trim()

if ($hbVersion.contains($tee.name) -ne $True) {
    Write-Host "There is a new version"
    Write-Host "----------------------"
    Write-Host "Homebrew Version: $hbVersion"
    Write-Host "Current TEE Version: " $tee.name
    Write-Error "##vso[task.logissue type=error;]Error: The versions do not match"
    Write-Error "Use the current TEE version to update homebrew."
    Write-Error "Update from the command line using: brew bump-formula-pr"
    Write-Error "Make sure to get the SHA256 of the file"    
}
else {
    Write-Host "No New Version"
    Write-Host "--------------"
    Write-Host "Homebrew Version: $hbVersion"
    Write-Host "Current TEE Version: " $tee.name
}
