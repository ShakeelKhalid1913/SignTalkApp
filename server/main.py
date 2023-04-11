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
    # get extension of file
    ext = file.filename.split('.')[-1]
    filename = f"audio.{ext}"
    with open(filename, "wb") as f:
        f.write(contents)
    text = audio_to_text(filename)
    print(text)
    return {"text": text}

@app.post('/youtube')
async def youtube(transcript: Transcript):
    text = transcript_video(transcript.youtube_url)
    return {"text": text}

if __name__ == '__main__':
    import uvicorn
    uvicorn.run(app, host='0.0.0.0', port=8000)