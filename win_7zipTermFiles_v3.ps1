#This script is useful when backing up a user's directory on a laptop or desktop system after the user's employment was terminated
#Things that I'll be building into this in the future:
# 1. File Hash of completed Archive to assist with verification of file integrity
# 2. Archive Expansion based on File Hash matching
# 3. Build this into it's very own module

#Install & Import 7Zip Powershell Module (uses 7Zip CLI standalone)
Install-Module -Name PS7Zip -Force
Import-Module -Name PS7Zip

#Get the currently logged in user
$loggedInUser = $($env:USERNAME)

#Array of folders to exempt (in this case we're ignoring cloud storage applications that create a virtual folder that may not be accssible)
$exemptFolders = @("Dropbox")

#Setting the root user folder
$userFolder = "C:\Users\"

#Sets the user to a null value to ensure we're targeting the correct folder
$user = $null

#Logic to check if we're logged in as LADMIN (Update any value of LADMIN to whatever your local admin account is)
#If we are logged in as local admin, then give us a grid view to select the user folder we want to backup
#If we're not the local admin, then we must want to backup the user data of the account we're logged in as (not likely, but a good idea for backup regardless)
if ($loggedInUser -eq "LADMIN") {
    $user = (Get-ChildItem -Path $userFolder -Exclude "Default","Public","LADMIN" | Out-GridView -Title "Select Directory" -PassThru).Name
    $userFolder += $user
    Write-Host "varible set to $userFolder"
} else {
    $userFolder = $($env:USERPROFILE)
    Write-Host "varible set to $userFolder"
}

#Now, we can start backing up the user data using 7zip!
#Why 7Zip and not just Compress-Archive? Because Compress-Archive maxxes out at 2GB and will fail to create the archive.
#7Zip allows for much larger archive creations
if ($loggedInUser -eq "LADMIN"){
    $saveZipLocation = "$env:USERPROFILE\Desktop\$(Get-Date -Format yyyy-MM-dd)_$user.7z"
    Get-ChildItem -Path $userFolder -Exclude $exemptFolders | Compress-7Zip -OutputFile $saveZipLocation -ArchiveType 7Z
} else {
    $saveZipLocation = "C:\Users\LADMIN\Desktop\$(Get-Date -Format yyyy-MM-dd)_$loggedInUser.7z"
    Get-ChildItem -Path $userFolder -Exclude $exemptFolders | Compress-7Zip -OutputFile $saveZipLocation -ArchiveType 7Z
}