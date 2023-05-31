import re
import nltk
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
import contractions
from src.syn import synonyms

nltk.download('punkt')
nltk.download('wordnet')

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

if __name__=='_main_':
    clean_sentence("i need glass of water")