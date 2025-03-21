from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

import os
import streamlit as st
from dotenv import load_dotenv

## enviroment variables call
os.environ["OPENAI_API_KEY"] = os.getenv("OPENAI_API_KEY")

## langsmith tracking

os.environ["LANGCHAIN_API_KEY"] = os.getenv("LANGCHAIN_API_KEY")    
os.environ["LANGCHAIN_TRACING_V2"] = "true"

## chatbot creating

prompt = ChatPromptTemplate.from_messages(
    [
        ("system", "You are a helpful assistant. Please provide response to the user questions"),
        ("user","Question:{question}")
    ]
)

# streamlit framework

st.title("Chatbot Langchain demo OpenAI")
input_text = st.text_input("Enter your question here")

# OpenAI LLM call

llm = ChatOpenAI(model="gpt-3.5-turbo")
output_parser=StrOutputParser()

# Chain
chain = prompt|llm|output_parser

if input_text:
    st.write(chain.invoke({'question':input_text}))










