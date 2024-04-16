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
    
    llm = ChatOpenAI(model_name='gpt-3.5-turbo', temperature=0.2)

    template = """Use only following pieces of context to answer the question at the end. Keep the answer as detailed as possible. If you don't know the answer, just say that you don't know, don't try to make up an answer. \
The context and question are delimited by ```

Context: ```{context}```

Question: ```{question} 

Helpful Answer:"""

    QA_CHAIN_PROMPT = PromptTemplate(input_variables=["context", "question"],template=template)
    qa_chain = ConversationalRetrievalChain.from_llm(
        llm,
        retriever=db_loader().as_retriever(search_type="mmr"),
        return_source_documents=True,
        return_generated_question=True,
        chain_type="stuff",
        combine_docs_chain_kwargs={"prompt": QA_CHAIN_PROMPT},
        get_chat_history=lambda h : h,
        memory=memory,
        verbose=True,
    )

    return qa_chain

def get_completion(
        messages,
        model="gpt-3.5-turbo",
        temperature=0,
    ): 
    response = openai.chat.completions.create(
        model=model,
        messages=messages,
        temperature=temperature, 
    )
    return response.choices[0].message.content

def summarize(history):
    system_message = f"""Assume that you are a SFBU assistant.\
Given conversation between assistant and user.\
Summarize the conversation.\
Pay attention to specific details.\
Assistant message will be delimited by ```\
User message will be delimited by ///\
"""
    for conversation in history:
        user, assistant = conversation
        system_message += f'User: ///{user}///'
        system_message += f'Assistant: ```{assistant}```'

    user_message = f"""Provide a summarization about the conversation."""
    prompt = [
        {'role' : 'system', 'content' : system_message},
        {'role' : 'user', 'content' : user_message},
    ]
    response = get_completion(prompt)
    return response


def generate_email(summary, selected_language):
    print(selected_language)
    system_message = f"""Assume that you are a SFBU assistant.\\
The following information summary of conversation.\
Generate an email in given language. The language is delimited by ///.\
The summary would be delimited by ```.\
Do not include any delimiter in the result.\
```{summary}```
"""
    user_message = f"""
    Please create an email with 100-word in ///{selected_language}/// to be sent to the customer.
    """
    messages =  [  
        {'role' : 'system', 'content' : system_message},    
        {'role' : 'user', 'content': user_message},
    ] 
    return get_completion(messages)