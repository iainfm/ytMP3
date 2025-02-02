# https://github.com/JuanBindez/pytubefix

import sys
from pytubefix import YouTube

url = (sys.argv[1])
yt = YouTube(url)

ys = yt.streams.get_audio_only()
filename = ys.download(output_path='D:\\Music\\')

print(filename)