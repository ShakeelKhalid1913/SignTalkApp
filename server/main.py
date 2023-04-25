from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from src.api import transcribe_media, transcribe_youtube, generate_glossary


class Transcript(BaseModel):
    """
    Represents a YouTube video transcript.

    Attributes:
        youtube_url (str): The URL of the YouTube
        video for which the transcript is available.
    """
    youtube_url: str


class Text(BaseModel):
    """
    Represents a piece of text with a glossary of terms.

    Attributes:
        glossary (str): A string containing a
        glossary of terms used in the text.
    """
    glossary: str


app = FastAPI()


@app.get('/')
def index():
    return {"message": "Hello World"}


@app.post('/media')
async def audio(file: UploadFile = File()):
    contents = await file.read()
    filename = file.filename
    with open(filename, "wb") as f:
        f.write(contents)
    text = transcribe_media(filename)
    print(text)
    return {"text": text}


@app.post('/youtube')
async def youtube(transcript: Transcript):
    text = transcribe_youtube(transcript.youtube_url)
    return {"text": text}


@app.post('/get_glossary')
async def get_glossary(text: Text):
    glossary = generate_glossary(text.glossary)
    return {"glossary": glossary}


if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)
