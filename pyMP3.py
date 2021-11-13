from pytube import YouTube
import sys

url = (sys.argv[1])

yt = YouTube(url)
ts = yt.streams.filter(only_audio=True, file_extension='mp4').order_by('abr').desc().first()
tp = 'D:\\Music\\'

fsp = (ts.default_filename)
asciifsp = (fsp.encode(encoding="ascii", errors="ignore")).decode().lstrip().replace(' .', '.')
ts.download(output_path = tp, filename = asciifsp)
print(asciifsp)