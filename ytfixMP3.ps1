# Powershell script to download a youtube video's audio, convert it to MP3 and place it on a
# removable USB storage device.
#
# Not pretty or optimised, but does what I need.
#
# Pre-requisites:
# 	Pyton installed and in the path
#	PyTube fix installed
#   pyfixMP3.py installed somewhere (I tried to put it inline but it was problematic)
#

Clear-Host
Write-Output "YouTube MP3 downloader - pytubefix version`r`n"

# Variables:

# Whether to delete the local copy after moving to USB
$deleteLocal = $true

# Temporary path - where the mp4 file gets downloaded to
$tp = 'D:\Music\'

# Python script to call that downloads the video's audio
$pyMP3 = 'D:\Git\ytMP3\pyfixMP3.py'

# Detect USB drives attached. Going to assume there's only ever going to be one
# If there's more than one the last will be used
$drives = Get-CimInstance -className CIM_LogicalDisk
$dp = ''
ForEach ($drive in $drives) {
    if ($drive.DriveType -eq 2) {

        $dp = "$($drive.DeviceID)\"

    }
}

# Save locally if no USB device detected
if ($dp -eq '') {
    write-warning "No USB device detected. Saving to $tp."
    Write-Host ''
    $dp = $tp
}

# Main loop
do {
	
    $url = Read-Host -Prompt 'URL of YouTube video to download '

    if ($url -eq '') { Exit }
    $url = $url.Split('&')
	
    Write-Output "Downloading: $($url[0])..."

    try {     
        $p = python $pyMP3 $url
    }
    catch {
        # Report the error
        Write-Error $_.Exception.Message
    }

    # Copy the file to USB if a device was found, and delete source if required
    if ($dp -ne $tp) {
        Copy-Item -Path $tp$p -Destination $dp$p
        if ($deleteLocal) {
            Remove-Item -Path $tp$p
        }
    } 

Write-Output "Downloaded to: $dp$p"
Write-output ''

} while ($url -ne '')