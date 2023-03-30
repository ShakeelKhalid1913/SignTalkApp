import pytube
from moviepy.editor import VideoFileClip
import whisper
import os

type = 'small'
model = whisper.load_model(type)

def audio_to_text(filename):
    print("Converting audio to text... Please wait.")
    result = model.transcribe(filename)
    os.remove(filename)
    text = result["text"]
    return text

def download_video(url):
    video = pytube.YouTube(url)
    stream = video.streams.get_by_itag(18)
    stream.download()
    return stream.default_filename

def convert_to_mp3(filename):
    clip = VideoFileClip(filename)
    clip.audio.write_audiofile(filename[:-4] + ".mp3")
    clip.close()

def youtube_to_text(url):
    print("Downloading video... Please wait.")

    try:
        filename = download_video(url)
        print("Downloaded video as " + filename)
    except Exception as e:
        print(e)
        return "Not a valid link.."
    try:
        convert_to_mp3(filename)
        print("Video converted to mp3")
    except:
        return "Error converting video to mp3"

    result = audio_to_text(filename[:-4] + ".mp3")
    os.remove(filename)
    return result

# print(youtube_to_text('https://youtu.be/2lAe1cqCOXo'))