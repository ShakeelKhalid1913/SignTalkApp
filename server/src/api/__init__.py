import os
import re
import requests
from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import TextFormatter

from src.api.helper_functions import clean_sentence, convert_to_audio, get_duration, split_file_subparts

API_URL = "https://api-inference.huggingface.co/models/openai/whisper-base"
TOKEN = "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"

headers = {"Authorization": f"Bearer {TOKEN}"}

def generate_glossary(text):
    return clean_sentence(text)

def transcribe_media(filename):
    transcript = ""
    ext = filename.split('.')[-1]
    # check if file is audio or video
    if ext == 'mp4':
        convert_to_audio(filename, 'audio.mp3')
        os.remove(filename)
        filename = 'audio.mp3'
        ext = 'mp3'
    print("Converting audio to text... Please wait.")

    subpart_duration = 30

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

def transcribe_youtube(url):
    # get id of youtube video from url
    print('checking if url is valid...')
    pattern = re.compile(r'(?:https://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([\w-]+)')
    match = pattern.search(url)

    if match:
        print('transcripting video...')
        video_id = match.group(1)
        try:
            transcript =  YouTubeTranscriptApi.get_transcript(video_id, languages=['en'])
            formatter = TextFormatter()

            return formatter.format_transcript(transcript).replace('\n', ' ')
        except:
            return "Transcript is not available for this video."
    else:
        return 'Invalid youtube video link..'

# for testing purpose
if __name__ == "__main__":
    print(transcribe_media('https://youtu.be/UOkOA6W-vwc'))


    # print(output)
    # https://youtu.be/skOTEbGwncE
