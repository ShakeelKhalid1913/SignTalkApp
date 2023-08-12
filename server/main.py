from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from src.api import *


class Transcript(BaseModel):
    """
    Represents a YouTube video transcript.

    Attributes:
        youtube_url (str): The URL of the YouTube
        video for which the transcript is available.
    """

    youtube_url: str


class Input(BaseModel):
    """
    Represents a piece of text with a glossary of terms.

    Attributes:
        glossary (str): A string containing a
        glossary of terms used in the text.
    """

    text: str


app = FastAPI()


@app.get('/')
def index():
    return {"message": "Hello World"}

@app.post('/text')
def glossary(text: Input):
    return {"glossary": clean_sentence(text.text)}


@app.post('/media')
async def audio(file: UploadFile = File()):
    contents = await file.read(CHUNK_SIZE)
    filename = file.filename
    text, glossary_text = upload_file(filename, contents)
    # text, glossary_text = ("hello", "OK")
    print(text, glossary_text)
    return {"text": text, "glossary_text": glossary_text}


@app.post('/youtube')
async def youtube(transcript: Transcript):
    # text = transcribe_youtube(transcript.youtube_url)
    return {"text": transcript.youtube_url}


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)
