import subprocess
import json
import whisper
import os
import yt_dlp as youtube_dl

type = 'small'
model = whisper.load_model(type)

def audio_to_text(filename):
    print("Converting audio to text... Please wait.")
    result = model.transcribe(filename)
    os.remove(filename)
    text = result["text"]
    return text

def download_video(url):
    URLS = [url]

    ydl_opts = {
        'format': 'm4a/bestaudio/best',
        'postprocessors': [{  # Extract audio using ffmpeg
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'mp3',
        }],
        'outtmpl': 'temp/audio'
    }

    with youtube_dl.YoutubeDL(ydl_opts) as ydl:
        error_code = ydl.download(URLS)

    print("Error" if error_code == 0 else "Success")

    return "temp/audio.mp3"

def youtube_to_text(url):
    print("Downloading video... Please wait.")

    try:
        filename = download_video(url)
        print("Downloaded audio as " + filename)
    except Exception as e:
        print(e)
        return "Not a valid link.."

    result = audio_to_text(filename)
    return result

# for testing purpose
if __name__ == "__main__":
    # print(youtube_to_text('https://youtu.be/hEVQch72TBo'))
    # download_video('https://youtu.be/hEVQch72TBo')

    input_file  = "temp/audio.mp3"

    metadata = subprocess.check_output(f"ffprobe -i {input_file} -v quiet -print_format json -show_format -hide_banner".split(" "))

    metadata = json.loads(metadata)
    print(f"Length of file is: {float(metadata['format']['duration'])}")


    # Define the desired duration of each subpart (in seconds)
    subpart_duration = 30

    # Run the ffmpeg command to split the video into subparts
    subprocess.call(['ffmpeg', '-i', input_file, '-c', 'copy', '-map', '0', '-segment_time', str(subpart_duration), '-f', 'segment', 'temp/subpart_%03d.mp3'])