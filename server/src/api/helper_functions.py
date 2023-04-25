import subprocess

import re
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
import contractions

from src.syn import synonyms


def clean_sentence(sentence):
    # remove contraction
    words = contractions.fix(sentence)

    # Remove punctuation
    words = re.sub(r'[^\w\s]', '', words)

    # Tokenize the sentence into words
    words = word_tokenize(words.lower())

    # Remove stop words
    stop_word = ['an', 'the', 'as', 'were', 'was', 'am', 'to',
                 'too', 'be', 'is', 'by', 'so', 'of']
    words = [word for word in words if word not in stop_word]

    # Lemmatize the words
    lemmatizer = WordNetLemmatizer()
    words = [lemmatizer.lemmatize(word, pos="v") for word in words]
    words = [lemmatizer.lemmatize(word, pos="a") for word in words]

    # find synonym of the word
    words = [synonyms[word] if word in synonyms else word for word in words]

    # Join the words back into a sentence
    glossary = ' '.join(words)
    return glossary.upper()


def get_duration(filename):
    command = ['ffprobe', '-i', filename, '-show_entries',
               'format=duration', '-v', 'quiet', '-of', 'csv=p=0']
    output = subprocess.check_output(command)
    return float(output)


def split_file_subparts(filename, subpart_duration, ext):
    command = ['ffmpeg', '-i', filename, '-c', 'copy', '-map', '0', '-segment_time',
               str(subpart_duration), '-f', 'segment', f'temp/media_%03d.{ext}']
    subprocess.run(command, check=True)


def convert_to_audio(video_file, audio_file):
    command = ['ffmpeg', '-i', video_file, '-vn', '-acodec', 'mp3', audio_file]
    subprocess.run(command, check=True)
