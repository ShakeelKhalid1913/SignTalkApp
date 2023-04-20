import re
from nltk.tokenize import word_tokenize
from nltk.stem import WordNetLemmatizer
import contractions

from src.syn import synonyms

# nltk.download('punkt')
# nltk.download('stopwords')
# nltk.download('wordnet')
# nltk.download('omw-1.4')

def clean_sentence(sentence):
    # remove contraction
    words = contractions.fix(sentence)

    # Remove punctuation
    words = re.sub(r'[^\w\s]', '', words)

    # Tokenize the sentence into words
    words = word_tokenize(words.lower())

    # Remove stop words
    stop_word = ['an','the','as','were','was','am','to','too','be','is','by','so','of']
    words = [word for word in words if word not in stop_word]

    # Lemmatize the words
    lemmatizer = WordNetLemmatizer()
    words = [lemmatizer.lemmatize(word,pos="v") for word in words]
    words = [lemmatizer.lemmatize(word,pos="a") for word in words]

    # find synonym of the word
    words = [synonyms[word] if word in synonyms else word for word in words]

    # Join the words back into a sentence
    clean_sentence = ' '.join(words)
    return clean_sentence.upper()


if __name__ == "__main__":
    sentence = " i ? den?ied should've didn't ran giving great crucial unhappy brown fine well happiness better good great jumps over of the happiest caught catch thinking dog ."
    cleaned_sentence = clean_sentence(sentence)
    print(cleaned_sentence)