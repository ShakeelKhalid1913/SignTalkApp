import os
import requests
import time
from dotenv import load_dotenv
import yt_dlp as youtube_dl
import tempfile

from src.api.helper_functions import *

load_dotenv()

auth_key = os.getenv("ASSEMBLY_API_KEY")
transcript_endpoint = "https://api.assemblyai.com/v2/transcript"
upload_endpoint = 'https://api.assemblyai.com/v2/upload'
headers_auth_only = {'authorization': auth_key}
headers = {
   "authorization": auth_key,
   "content-type": "application/json"
}
CHUNK_SIZE = 5242880

def generate_glossary(text):
    return clean_sentence(text)

def read_file(filename):
    with open(filename, 'rb') as _file:
        while True:
            data = _file.read(CHUNK_SIZE)
            if not data:
                break
            yield data

def transcribe_youtube(youtube_url):
    with tempfile.TemporaryDirectory() as tempdirname:
        ydl_opts = {
            'format': 'bestaudio/best',
            'postprocessors': [{
                'key': 'FFmpegExtractAudio',
                'preferredcodec': 'mp3',
                'preferredquality': '192',
            }],
            # 'ffmpeg-location': './',
            'outtmpl': f"{tempdirname}/%(id)s.%(ext)s",
        }
        def download_and_read_contents(link, dirname):
            _id = link.strip()
            meta = youtube_dl.YoutubeDL(ydl_opts).extract_info(_id)
            save_location = dirname + "/" + meta['id'] + ".mp3"
            return save_location, read_file(save_location)

        filename, contents = download_and_read_contents(youtube_url, tempdirname)
        return upload_file(filename, contents)

def upload_file(filename, contents):
    print(f"Uploading file: {filename}")
    response = requests.post(upload_endpoint,
                             headers=headers,
                             data=contents)
    if response.status_code == 200:
        audio_url = response.json()["upload_url"]
        return create_transcript(audio_url)
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return None

def create_transcript(audio_url):
    print("Transcribing audio... This might take a moment.")
    data = {
        "audio_url": audio_url
    }
    response = requests.post(transcript_endpoint, json=data, headers=headers)
    transcript_id = response.json()['id']
    polling_endpoint = f"{transcript_endpoint}/{transcript_id}"

    while True:
        transcription_result = requests.get(polling_endpoint, headers=headers).json()

        if transcription_result['status'] == 'completed':
            break
        elif transcription_result['status'] == 'error':
            raise RuntimeError(f"Transcription failed: {transcription_result['error']}")
        else:
            time.sleep(3)

    return transcription_result['text'], clean_sentence(transcription_result['text'])

# 'https://youtu.be/H5GETOP7ivs'
