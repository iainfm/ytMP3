# Powershell script to download a youtube video's audio, convert it to MP3 and place it on a
# removable USB storage device.
#
# Not pretty or optimised, but does what I need.
#
# Pre-requisites:
# 	Pyton installed and in the path
#	PyTube installed
#	FFmpeg installed/copied somewhere
#   pyMP3.py installed somewhere (I tried to put it inline but it was problematic)
#
# Variables:
# Path to ffmpeg.exe
$ffmpeg = 'C:\Program Files\ffmpeg\ffmpeg.exe'

# Temporary path - where the mp4 file gets downloaded to
$tp = 'D:\Music\'

# Python script to call that downloads the video's audio
$pyMP3 = 'D:\Git\ytMP3\pyMP3.py'

# Whether to remove the mp4 afterwards
$delMP4 = $true

# Whether to automatically overwrite the destination mp3 if it exists
$ow = '-y' # Set to '-y' for yes, '-n' for no or '' to prompt.

Clear-Host

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
        Write-Error $_.Exception.Message
    }

    $q = $p.Replace('.mp4', '.mp3')
	write-output "Writing:     $q"
	
    $ff_args = "$ow -i ""$tp$p"" -b:a 192K -vn ""$dp$q"""

    try {
        Start-Process -FilePath $ffmpeg -ArgumentList $ff_args -Wait
    }
    catch {
        Write-Error $_.Exception.Message
    }
	
	if ($delMP4 -eq $true) {
		try {
			Remove-Item $tp$p -Force
		}
		
		catch {}		
	}
	

Write-output ''

} while ($url -ne '')