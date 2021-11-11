# Powershell script to download a youtube video's audio, convert it to MP3 and place it on a
# removable USB storage device.
#
# Not pretty or optimised, but does what I need.
#
# Pre-requisites:
# 	Pyton installed and in the path
#	PyTube installed
#	FFmpeg installed/copied somewhere
#
# Variables:
# Path to ffmpeg.exe
$ffmpeg = 'C:\Program Files (x86)\FFmpeg for Audacity\ffmpeg.exe'

# Temporary path - where the mp4 file gets downloaded to
$tp = 'D:\Music\'

Clear-Host

# Python script to call that downloads the video's audio
$pyMP3 = "
from pytube import YouTube
import sys
url = (sys.argv[1])

yt = YouTube(url)
ts = yt.streams.filter(only_audio=True, file_extension='mp4').order_by('abr').desc().first()
tp = 'D:\\Music\\'

fsp = (ts.default_filename)
ttl = (ts.title)
ts.download(output_path = tp)
print(fsp)
"

# Detect USB drives attached. Going to assume there's only ever going to be one
# If there's more than one the last will be used
$drives = Get-CimInstance -className CIM_LogicalDisk
$dp = ''
ForEach ($drive in $drives) {
    if ($drive.DriveType -eq 2) {

        $dp = "$($drive.DeviceID)\"

    }
}

# Bale out if no USB device detected
if ($dp -eq '') {
    write-output 'No USB device detected.'
    Read-Host ''
    Exit 0
}

# Main loop
do {
	
    $url = Read-Host -Prompt 'URL of YouTube video to download '

    if ($url -eq '') { Exit }
    $url = $url.Split('&')
	
    Write-Output "Downloading: $($url[0])..."

    try {
        $p = python -c $pyMP3 $url
        # $p
    }

    catch {
        Write error $_.Exception.Message
    }

    $q = $p.Replace('.mp4', '.mp3')
	write-output "Writing:     $q"
	
    $args = "-i ""$tp$p"" -b:a 192K -vn ""$dp$q"""

    try {
        Start-Process -FilePath $ffmpeg -ArgumentList $args
    }
    catch {
        Write error $_.Exception.Message
    }

Write-output ''

} while ($url -ne '')