from langchain_text_splitters import RecursiveCharacterTextSplitter
import openai
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAI, OpenAIEmbeddings
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.document_loaders.generic import GenericLoader
from langchain_community.document_loaders.parsers import OpenAIWhisperParser
from langchain_community.document_loaders.blob_loaders.youtube_audio import YoutubeAudioLoader
from langchain_community.document_loaders import WebBaseLoader
from langchain_openai import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory
from langchain.prompts import PromptTemplate

delimiter = '```'

def load_PDF(path):
    return PyPDFLoader(path)

def load_video(url):
    save_dir="docs/youtube/"
    load_video = GenericLoader(
       YoutubeAudioLoader([url],save_dir),
       OpenAIWhisperParser()
    )
    return load_video

def url_loader(url):
    url_loader = WebBaseLoader(url)
    return url_loader


def db_loader():
    embedding = OpenAIEmbeddings()
    vectordb = Chroma(
       persist_directory='docs/chroma/',
       embedding_function=embedding
    )
    return vectordb

def input_moderation(comment):
    response = openai.moderations.create(input=comment)
    moderation_output = response.results[0]
    flagged = moderation_output.flagged
    return flagged

def get_completion(
        messages,
        model="gpt-3.5-turbo",
        temperature=0.3,
    ): 
    response = openai.chat.completions.create(
        model=model,
        messages=messages,
        temperature=temperature, 
    )
    return response.choices[0].message.content

def translate_response(text, language):
    system_message = f"""Assume you are a professional translator.\
    The text will be delimited by tripe backticks.\
    {delimiter}{text}{delimiter}"""
    user_message = f"""
    Translate the text into {language} language."""
    messages_translate =  [  
        {'role' : 'system', 'content' : system_message},    
        {'role' : 'user', 'content' : f"{delimiter}{user_message}{delimiter}"}  
    ] 
    return get_completion(messages_translate)

def qa_chain(memory):
    
    llm = ChatOpenAI(model_name='gpt-3.5-turbo', temperature=0)

    template = """You are San Francisco Bay University Assitant. 
Use the following pieces of context to answer the question at the end. 
If you don't know the answer, just say that you don't know, don't try to make up an answer.
Keep the answer as detailed as possible.
Context will delimited by ```
Question will be delimited by ///

Context: ```{context}```

Question: ///{question}/// 

Helpful Answer:"""

    QA_CHAIN_PROMPT = PromptTemplate(input_variables=["context", "question"],template=template)
    qa_chain = ConversationalRetrievalChain.from_llm(
        llm,
        retriever=db_loader().as_retriever(search_type="similarity", search_kwargs={"k": 3}),
        return_source_documents=True,
        return_generated_question=True,
        chain_type="stuff",
        verbose=True,
        combine_docs_chain_kwargs={"prompt": QA_CHAIN_PROMPT},
        get_chat_history=lambda h : h,
        memory=memory,
    )

    return qa_chain