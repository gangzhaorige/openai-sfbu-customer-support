from utils import *
from langchain.text_splitter import RecursiveCharacterTextSplitter
# load pdf, video, and urls
loaders = [
    load_PDF('2023Catalog.pdf'),
    load_video('https://www.youtube.com/watch?v=kuZNIvdwnMc'),
    url_loader('https://www.sfbu.edu/admissions/student-health-insurance')
]

docs = []
for loader in loaders:
    docs.extend(loader.load())


# split in chunks
text_splitter = RecursiveCharacterTextSplitter(
    chunk_size = 1500,
    chunk_overlap = 150
)

splits = text_splitter.split_documents(docs)

# start embedding
embedding = OpenAIEmbeddings()

for split in splits:
    embedding.embed_query(split.page_content)

persist_directory = 'docs/chroma/'
# # get_ipython().system('rm -rf ./docs/chroma')  

# save it to vector space
vectordb = Chroma.from_documents(
    documents=splits,
    embedding=embedding,
    persist_directory=persist_directory
)
# save the vector space
vectordb.persist()