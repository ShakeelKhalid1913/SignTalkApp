from fastapi import FastAPI, File, UploadFile
from pydantic import BaseModel
from convert import audio_to_text, transcript_video

class Transcript(BaseModel):
    youtube_url: str

app = FastAPI()

@app.get('/')
def index():
    return {"message": "Hello World"}


@app.post('/audio')
async def audio(file: UploadFile = File()):
    contents = await file.read()
    with open("audio.mp3", "wb") as f:
        f.write(contents)
    text = audio_to_text("audio.mp3")
    print(text)
    return {"text": text}

@app.post('/youtube')
async def youtube(transcript: Transcript):
    print(transcript.dict())
    text = transcript_video(transcript.youtube_url)
    return {"text": text}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)