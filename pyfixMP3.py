# https://github.com/JuanBindez/pytubefix

import sys
from pytubefix import YouTube
# from pytubefix.cli import on_progress

url = (sys.argv[1])
yt = YouTube(url) # , on_progress_callback = on_progress)

fsp = (yt.title)
asciifsp = (fsp.encode(encoding="ascii", errors="ignore")).decode().lstrip().replace(' .', '.')

ys = yt.streams.get_audio_only()
filename = ys.download(mp3=True, output_path='D:\\Music\\', filename=asciifsp)

print(asciifsp + '.mp3')
