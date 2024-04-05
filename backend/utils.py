import os
import openai
import sys
import panel as pn  # GUI
import numpy as np
from dotenv import load_dotenv, find_dotenv
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain_community.document_loaders import PyPDFLoader
from langchain_community.document_loaders.generic import GenericLoader
from langchain_community.document_loaders.parsers import OpenAIWhisperParser
from langchain_community.document_loaders.blob_loaders.youtube_audio import YoutubeAudioLoader
from langchain_community.document_loaders import WebBaseLoader
from langchain_openai import ChatOpenAI
from langchain.chains import ConversationalRetrievalChain
from langchain.memory import ConversationBufferMemory

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
