$tee = Invoke-WebRequest -Uri https://api.github.com/repos/Microsoft/team-explorer-everywhere/releases/latest | ConvertFrom-Json

$homebrew = Invoke-WebRequest -Uri https://api.github.com/repos/Homebrew/homebrew-core/contents/Formula/tee-clc.rb | ConvertFrom-Json

$contents = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($homebrew.content))

$hbVersionLine = $contents.split("`n")
$hbVersion = $hbVersionLine[3].Trim()

if ($hbVersion.contains($tee.name) -ne $True) {
    Write-Host "There is a new version"
    Write-Host $hbVersion
    Write-Host $tee.name
    # brew bump-formula-pr
    Write-Error "##vso[task.logissue type=error;]Error: The versions do not match"
}
else {
    Write-Host "No New Version"
    Write-Host $hbVersion
    Write-Host $tee.name
}
