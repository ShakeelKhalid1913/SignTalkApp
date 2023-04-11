import os
import re
import requests
import subprocess
from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import TextFormatter

from glossary import clean_sentence

API_URL = "https://api-inference.huggingface.co/models/openai/whisper-base"
TOKEN = "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"

headers = {"Authorization": f"Bearer {TOKEN}"}

def get_duration(filename):
    command = ['ffprobe', '-i', filename, '-show_entries', 'format=duration', '-v', 'quiet', '-of', 'csv=%s' % ("p=0")]
    output = subprocess.check_output(command, shell=True)
    return float(output)

def split_file_subparts(filename, subpart_duration, ext):
    # Run the ffmpeg command to split the video into subparts
    command = ['ffmpeg', '-i', filename, '-c', 'copy', '-map', '0', '-segment_time',
               str(subpart_duration), '-f', 'segment', f'temp/media_%03d.{ext}']
    subprocess.call(command)

def audio_to_text(filename):
    transcript = ""
    print("Converting audio to text... Please wait.")

    subpart_duration = 30
    ext = filename.split('.')[-1]

    duration = get_duration(filename)
    split_file_subparts(filename, subpart_duration, ext)

    subparts = [f'temp/media_{i:03d}.{ext}' for i in range(int(duration / subpart_duration) + 1)]

    for subpart in subparts:
        if get_duration(subpart) < 2:
            continue
        with open(subpart, "rb") as f:
            data = f.read()
        response = requests.post(API_URL, headers=headers, data=data)

        output = response.json()
        transcript = transcript + output['text']
        print(f"{subpart} done")

    os.remove(filename)
    for subpart in subparts:
        os.remove(subpart)

    return transcript

def transcript_video(url):
    # get id of youtube video from url
    print('checking if url is valid...')
    pattern = re.compile(r'(?:https://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([\w-]+)')
    match = pattern.search(url)

    if match:
        print('transcripting video...')
        video_id = match.group(1)
        transcript =  YouTubeTranscriptApi.get_transcript(video_id, languages=['en'])
        formatter = TextFormatter()

        return formatter.format_transcript(transcript).replace('\n', ' ')
    else:
        return 'Invalid youtube video link..'

# for testing purpose
if __name__ == "__main__":
    # print(transcript_video('https://youtu.be/UOkOA6W-vwc'))
    filename = "vocal-spoken-the-realm-female-speech_75bpm_C_major.wav"

    output = audio_to_text(filename)

    print(output)

    print("=" * 50)
    print("Output after cleaning:")
    print(clean_sentence(output))