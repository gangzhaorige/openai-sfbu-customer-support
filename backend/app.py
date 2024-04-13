import os
from pathlib import Path
from dotenv import load_dotenv
from flask_cors import CORS, cross_origin

import openai
from flask import Flask, Response, session, request
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain.memory import ConversationBufferWindowMemory

from test import init_api
from utils import input_moderation, qa_chain, translate_response
load_dotenv()

init_api()

app = Flask(__name__)
openai.api_key = os.getenv("OPENAI_API_KEY")
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'


persist_directory = 'docs/chroma/'

delimiter = '```'
counter = 0

embedding = OpenAIEmbeddings()

vectordb = Chroma(
    persist_directory=persist_directory,
    embedding_function=embedding
)

memory = ConversationBufferWindowMemory(
    memory_key="chat_history",
    input_key='question',
    output_key='answer',
    return_messages=True,
    k=5
)

history = []


@app.route('/generate', methods=['POST'])
@cross_origin()
def index():
    form = request.form
    question = form.get('question')
    audio = form.get('audio')
    language = form.get('language')
    translate = form.get('translate') == 'true'
    
    response = {}
    flagged = False
    print('Moderation test on question.')
    if input_moderation(question):
        response['response'] = 'Inappropriate conversation detected.'
        flagged = True

    result = ''
    qa = qa_chain(memory)
    if not flagged:
        print('Generating Content.')
        result = qa.invoke({"question": question, "chat_history":history})['answer']
    history.extend([(question, result)])

    if translate:
        result = translate_response(result, language)

    global counter
    speech_file_path = Path(f'reply{counter}.mp3')

    print('Moderation test on response.')
    if input_moderation(result):
        response['response'] = 'Inappropriate conversation detected.'
        flagged = True

    print('Generating Audio')
    with openai.audio.speech.with_streaming_response.create(
        model="tts-1",
        voice=audio.lower(),
        input=result if not flagged else response['response'],
    ) as response:
        response.stream_to_file(speech_file_path)
        print('Done')
    counter += 1
    return {
        'response' : result if not flagged else 'Inappropriate conversation detected.',
        'url': f'reply{counter - 1}.mp3'
    }


@app.route("/mp3/<filename>")
@cross_origin()
def streammp3(filename):
    print(filename)
    def generate():
        with open(filename, "rb") as fwav:
            data = fwav.read(1024)
            while data:
                yield data
                data = fwav.read(1024)
    response = Response(generate(), mimetype="audio/mpeg")
    return response

if __name__ == '__main__':
    app.run()