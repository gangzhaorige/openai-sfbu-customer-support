import os
from dotenv import load_dotenv
from flask_cors import CORS, cross_origin

import openai
from flask import Flask, Response, request
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain.memory import ConversationBufferWindowMemory
import requests

from test import init_api
from utils import generate_email, input_moderation, qa_chain, summarize, translate_response

load_dotenv()

init_api()

app = Flask(__name__)
openai.api_key = os.getenv("OPENAI_API_KEY")

cors = CORS(app)

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

dic = {}

inappropriate = 'Inappropriate conversation detected.'

@app.route('/generate', methods=['POST'])
@cross_origin()
def index():
    form = request.form
    question = form.get('question')
    language = form.get('language')
    translate = form.get('translate') == 'true'
    
    flagged = False
    flagged = input_moderation(question)

    qa = qa_chain(memory)

    result = qa.invoke({"question": question, "chat_history":history})['answer'] if not flagged else inappropriate

    history.extend([(question, result)])

    print(history)
    if translate:
        result = translate_response(result, language)

    dic[f'reply{counter}.mp3'] = result

    return {
        'response' : result if not flagged else inappropriate,
        'url': f'reply{counter}.mp3'
    }

@app.route('/email', methods=['POST'])
@cross_origin()
def email():
    language = request.form.get('language')
    translate = request.form.get('translate') == 'true'
    summary = summarize(history)
    email = generate_email(summary, language) if translate else generate_email(summary, 'English')
    return {'response': email}

@app.route('/clear', methods=['GET'])
@cross_origin()
def clear():
    history.clear()
    return {'response': 'Success'}
    

@app.route('/stream/<filename>/<string:audio>')
@cross_origin()
def stream(filename, audio):
    global counter
    def generate():
        url = "https://api.openai.com/v1/audio/speech"
        headers = {
            "Authorization": f'Bearer {os.getenv("OPENAI_API_KEY")}', 
        }
        data = {
            "model": "tts-1",
            "input": dic[f'reply{counter - 1}.mp3'],
            "voice": audio.lower(),
            "response_format": "mp3",
        }
        response = requests.post(url, headers=headers, json=data, stream=True)
        if response.status_code == 200:
            with open(filename, "wb") as f:
                for chunk in response.iter_content(chunk_size=4096):
                    f.write(chunk)
                    yield chunk

    counter += 1
    return Response(generate(), mimetype="audio/mpeg")


@app.route("/mp3/<filename>")
@cross_origin()
def streammp3(filename):
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