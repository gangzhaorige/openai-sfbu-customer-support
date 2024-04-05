import os
from pathlib import Path
from flask_cors import CORS, cross_origin
from flask_session import Session

import openai
from flask import Flask, Response, jsonify, request
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_openai import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory

app = Flask(__name__)
openai.api_key = os.getenv("OPENAI_API_KEY")
cors = CORS(app)
app.config['CORS_HEADERS'] = 'Content-Type'

app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"

Session(app)

persist_directory = 'docs/chroma/'

delimiter = '```'
counter = 0

embedding = OpenAIEmbeddings()

vectordb = Chroma(
    persist_directory=persist_directory,
    embedding_function=embedding
)

llm = ChatOpenAI(model_name='gpt-3.5-turbo', temperature=0)

memory = ConversationBufferMemory(
    memory_key="chat_history",
    # Set return messages equal true
    # - Return the chat history as a  list of messages 
    #   as opposed to a single string. 
    # - This is  the simplest type of memory. 
    #   + For a more in-depth look at memory, go back to  
    #     the first class that I taught with Andrew.  
    return_messages=True
)

retriever = vectordb.as_retriever()
qa = ConversationalRetrievalChain.from_llm(
    llm,
    retriever=retriever,
    memory=memory
)

@app.route('/generate', methods=['POST'])
@cross_origin()
def index():
    question = request.form.get('question')
    result = qa.invoke({"question": question})

    global counter
    speech_file_path = Path(f'reply{counter}.mp3')

    with openai.audio.speech.with_streaming_response.create(
        model="tts-1",
        voice="alloy",
        input=result['answer'],
    ) as response:
        print('Playing audio....')
        response.stream_to_file(speech_file_path)
    counter += 1
    return {
        'response' : result['answer'],
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