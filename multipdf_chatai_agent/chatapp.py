import os
import streamlit as st
from PyPDF2 import PdfReader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai.embeddings import OpenAIEmbeddings
from langchain_openai.chat_models import ChatOpenAI
from langchain.chains.question_answering import load_qa_chain
from langchain.vectorstores import FAISS
from langchain.prompts import PromptTemplate
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Function to extract text from PDFs
def get_pdf_text(pdf_docs):
    pdf_text = ""
    for pdf in pdf_docs:
        pdf_reader = PdfReader(pdf)
        for page in pdf_reader.pages:
            pdf_text += page.extract_text()
    return pdf_text

# Function to split text into chunks
def get_text_chunks(text):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
    chunks = text_splitter.split_text(text)
    return chunks

# Function to create vector store
def get_vector_store(text_chunks):
    embeddings = OpenAIEmbeddings(openai_api_key=os.getenv("OPENAI_API_KEY"))
    vector_store = FAISS.from_texts(text_chunks, embedding=embeddings)
    vector_store.save_local("faiss_index")

# Function to create conversational chain
def get_conversational_chain():
    prompt_template = """
    Answer the question as detailed as possible from the provided context,
    make sure to provide all the details, if the answer is not in provided
    context just say, "answer is not available in the context",
    don't provide the wrong answer\n\n
    Context:\n{context}\n
    Question:  \n{question}\n

    Answer:
    """

    model = ChatOpenAI(
        model="gpt-3.5-turbo",  # Changed from model_name to model
        temperature=0.3,
        openai_api_key=os.getenv("OPENAI_API_KEY")  # Added API key here
    )
    prompt = PromptTemplate(template=prompt_template, input_variables=["context", "question"])
    chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)
    return chain

def user_input(user_question):
    embeddings = OpenAIEmbeddings(openai_api_key=os.getenv("OPENAI_API_KEY"))
    new_db = FAISS.load_local("faiss_index", embeddings)
    docs = new_db.similarity_search(user_question, k=1)

    chain = get_conversational_chain()
    response = chain({"input_documents": docs, "question": user_question}, return_only_outputs=True)

    st.write("Reply:", response["output_text"])

# Main function
def main():
    st.set_page_config(page_title="Multi-PDF Chatbot", page_icon=":speech_balloon:")
    st.header("Multi-PDF's 📚 - Chat Agent 🤖")

    user_question = st.text_input("Ask a question:")

    if user_question:
        user_input(user_question)

    with st.sidebar:
        st.image("img/Robot.jpg")
        st.write("---")
        st.title("📁 PDF File's Section")
        pdf_docs = st.file_uploader("Upload PDF's", accept_multiple_files=True)
        if st.button("Submit & Process"):
            with st.spinner("Processing PDFs..."):
                raw_text = get_pdf_text(pdf_docs)
                text_chunks = get_text_chunks(raw_text)
                get_vector_store(text_chunks)
                st.success("PDF's Processed Successfully!")

if __name__ == "__main__":
    main()