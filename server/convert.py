import whisper
import os
import re
from youtube_transcript_api import YouTubeTranscriptApi
from youtube_transcript_api.formatters import TextFormatter

type = 'small'
model = whisper.load_model(type)

def audio_to_text(filename):
    print("Converting audio to text... Please wait.")
    result = model.transcribe(filename, fp16=False)
    os.remove(filename)
    text = result["text"]
    return text

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
    print(transcript_video('https://youtu.be/lMvFWKHhVZ0'))