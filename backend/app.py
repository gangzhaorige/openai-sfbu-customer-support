import os
from pathlib import Path
from flask_cors import CORS, cross_origin

import openai
from flask import Flask, Response, session, request
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_openai import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferWindowMemory
from langchain_core.messages import SystemMessage
from langchain_core.prompts import ChatPromptTemplate
from langchain.prompts import HumanMessagePromptTemplate
from utils import db_loader, generate_response, input_moderation, translate_response

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
    if input_moderation(question):
        response['response'] = 'Inappropriate conversation detected.'
        flagged = True

    result = ''
    if not flagged:
        result = generate_response(memory, question)['answer']

    if translate:
        result = translate_response(result, language)

    global counter
    speech_file_path = Path(f'reply{counter}.mp3')

    if input_moderation(result):
        response['response'] = 'Inappropriate conversation detected.'
        flagged = True

    with openai.audio.speech.with_streaming_response.create(
        model="tts-1",
        voice=audio.lower(),
        input=result if not flagged else response['response'],
    ) as response:
        response.stream_to_file(speech_file_path)
    counter += 1
    return {
        'response' : result if not flagged else 'Inappropriate conversation detected.',
        'url': f'reply{counter - 1}.mp3'
    }


@app.route("/mp3/<filename>")
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
    app.run(debug=True)