import os
import re
from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import TextFormatter

from src.api.helper_functions import *


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

    subparts = [f'temp/media_{i:03d}.{ext}'
                for i in range(int(duration / subpart_duration) + 1)]

    for subpart in subparts:
        if get_duration(subpart) < 2:
            continue
        with open(subpart, "rb") as f:
            data = f.read()
        response = transcribe(data)

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
    pattern = re.compile(
        r'(?:https://)?(?:www\.)?(?:youtube\.com/watch\?v=|youtu\.be/)([\w-]+)')
    match = pattern.search(url)

    if match:
        print('transcripting video...')
        video_id = match.group(1)
        try:
            transcript = YouTubeTranscriptApi.get_transcript(video_id, languages=['en'])
            formatter = TextFormatter()

            return formatter.format_transcript(transcript).replace('\n', ' ')
        except ValueError as _:
            return "Transcript is not available for this video."
    else:
        return 'Invalid youtube video link..'

#! ASSEMBLY AI
def read_file(filename, chunk_size=5242880):
    with open(filename, 'rb') as _file:
        while True:
            data = _file.read(chunk_size)
            if not data:
                break
            yield data


def upload_file(filename):
    api_token = "4fa61f36f16d48518104e9c9678a5b61"
    print(f"Uploading file: {filename}")

    headers = {'authorization': api_token}
    response = requests.post('https://api.assemblyai.com/v2/upload',
                             headers=headers,
                             data=read_file(filename))
    os.remove(filename)
    if response.status_code == 200:
        audio_url = response.json()["upload_url"]
        return create_transcript(audio_url)
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return None

def create_transcript(audio_url):
    print("Transcribing audio... This might take a moment.")
    api_token = "4fa61f36f16d48518104e9c9678a5b61"
    url = "https://api.assemblyai.com/v2/transcript"
    headers = {
        "authorization": api_token,
        "content-type": "application/json"
    }
    data = {
        "audio_url": audio_url
    }
    response = requests.post(url, json=data, headers=headers)
    transcript_id = response.json()['id']
    polling_endpoint = f"https://api.assemblyai.com/v2/transcript/{transcript_id}"

    while True:
        transcription_result = requests.get(polling_endpoint, headers=headers).json()

        if transcription_result['status'] == 'completed':
            break
        elif transcription_result['status'] == 'error':
            raise RuntimeError(f"Transcription failed: {transcription_result['error']}")
        else:
            time.sleep(3)

    return transcription_result['text']

# for testing purpose
if __name__ == "__main__":
    print(transcribe_media('https://youtu.be/UOkOA6W-vwc'))
    # https://www.youtube.com/watch?v=--khbXchTeE
