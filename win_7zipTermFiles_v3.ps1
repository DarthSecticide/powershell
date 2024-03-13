#Install-Module -Name PS7Zip -Force
Import-Module -Name PS7Zip

$loggedInUser = $($env:USERNAME)

$exemptFolders = @("Dropbox")

$userFolder = "C:\Users\"

$user = $null

if ($loggedInUser -eq "Patrick") {
    $user = (Get-ChildItem -Path $userFolder -Exclude "Default","Public","Patrick" | Out-GridView -Title "Select Directory" -PassThru).Name
    $userFolder += $user
    Write-Host "varible set to $userFolder"
} else {
    $userFolder = $($env:USERPROFILE)
    Write-Host "varible set to $userFolder"
}

if ($loggedInUser -eq "Patrick"){
    $saveZipLocation = "$env:USERPROFILE\Desktop\$(Get-Date -Format yyyy-MM-dd)_$user.7z"
    Get-ChildItem -Path $userFolder -Exclude $exemptFolders | Compress-7Zip -OutputFile $saveZipLocation -ArchiveType 7Z
} else {
    $saveZipLocation = "C:\Users\LADMIN\Desktop\$(Get-Date -Format yyyy-MM-dd)_$loggedInUser.7z"
    Get-ChildItem -Path $userFolder -Exclude $exemptFolders | Compress-7Zip -OutputFile $saveZipLocation -ArchiveType 7Z
}