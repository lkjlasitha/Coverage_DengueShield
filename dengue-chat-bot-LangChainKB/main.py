# -*- coding: utf-8 -*-
"""
Dengue Bot - LangChain PDF Question Answering System

A Python application that uses LangChain and Google's Generative AI 
to answer questions based on PDF documents.

Created: August 9, 2025
"""

import os
from dotenv import load_dotenv
from flask import Flask, request, jsonify
from flask_cors import CORS

import os
from dotenv import load_dotenv
from PyPDF2 import PdfReader
from langchain_google_genai import GoogleGenerativeAIEmbeddings, ChatGoogleGenerativeAI
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain.chains import RetrievalQA
import google.generativeai as genai

# Load environment variables from .env file
load_dotenv()

# Initialize Flask app
app = Flask(__name__)
CORS(app)  # Enable CORS for all domains

# Used to securely store your API key
GOOGLE_API_KEY = os.getenv('GOOGLE_API_KEY')
genai.configure(api_key=GOOGLE_API_KEY)

if GOOGLE_API_KEY:
    print("API key is set")
else:
    print("API key is not set")
    print("Please set your GOOGLE_API_KEY in the .env file")
    exit(1)

# Check if PDF file exists
pdf_file = 'den1.pdf'
if not os.path.exists(pdf_file):
    print(f"PDF file '{pdf_file}' not found. Please make sure the file exists in the project directory.")
    exit(1)

pdfreader = PdfReader(pdf_file)

# Read text from PDF
raw_text = ''
for i, page in enumerate(pdfreader.pages):
    content = page.extract_text()
    if content:
        raw_text += content

print(f"Extracted {len(raw_text)} characters from PDF")

# We need to split the text using Character Text Split such that it should not increase token size
text_splitter = CharacterTextSplitter(
    separator = "\n",
    chunk_size = 900,
    chunk_overlap  = 200,
    length_function = len,
)
texts = text_splitter.split_text(raw_text)

print(f"Split text into {len(texts)} chunks")

print("Creating embeddings...")
embeddings = GoogleGenerativeAIEmbeddings(model="models/embedding-001")

print("Building vector database...")
# Process texts in batches to avoid Google's 100 request limit
batch_size = 50  # Use smaller batch size to be safe
all_embeddings = []
document_search = None

print(f"Processing {len(texts)} chunks in batches of {batch_size}...")

for i in range(0, len(texts), batch_size):
    batch_texts = texts[i:i + batch_size]
    print(f"Processing batch {i//batch_size + 1}/{(len(texts) + batch_size - 1)//batch_size}...")
    
    if document_search is None:
        # Create initial FAISS index with first batch
        document_search = FAISS.from_texts(batch_texts, embeddings)
    else:
        # Add subsequent batches to existing index
        batch_vectorstore = FAISS.from_texts(batch_texts, embeddings)
        document_search.merge_from(batch_vectorstore)

print("Vector database created successfully!")

print("Setting up question-answering chain...")
# Use the updated approach for question-answering
llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash")
retriever = document_search.as_retriever()
qa_chain = RetrievalQA.from_chain_type(
    llm=llm,
    chain_type="stuff",
    retriever=retriever,
    return_source_documents=True
)

def ask_question(query):
    """Function to ask questions about the PDF content"""
    print(f"\nQuestion: {query}")
    try:
        result = qa_chain.invoke({"query": query})
        answer = result["result"]
        print(f"Answer: {answer}")
        return answer
    except Exception as e:
        print(f"Error: {e}")
        return None

# Flask API endpoints
@app.route('/', methods=['GET'])
def home():
    """Home endpoint with API information"""
    return jsonify({
        "message": "Dengue Bot API",
        "description": "A Python application that uses LangChain and Google's Generative AI to answer questions based on PDF documents.",
        "endpoints": {
            "/": "GET - API information",
            "/ask": "POST - Ask questions about dengue",
            "/health": "GET - Health check"
        },
        "usage": {
            "method": "POST",
            "url": "/ask",
            "body": {"question": "your question here"}
        }
    })

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        "status": "healthy",
        "message": "Dengue Bot API is running successfully!"
    })

@app.route('/ask', methods=['POST'])
def api_question():
    """API endpoint to ask questions about the PDF content"""
    try:
        # Get the question from request body
        data = request.get_json()
        
        if not data or 'question' not in data:
            return jsonify({
                "error": "Please provide a 'question' in the request body",
                "example": {"question": "What is dengue?"}
            }), 400
        
        question = data['question'].strip()
        
        if not question:
            return jsonify({
                "error": "Question cannot be empty"
            }), 400
        
        # Use the existing ask_question function
        answer = ask_question(question)
        
        if answer is None:
            return jsonify({
                "error": "Failed to get answer. Please try again."
            }), 500
        
        return jsonify({
            "question": question,
            "answer": answer,
            "status": "success"
        })
        
    except Exception as e:
        return jsonify({
            "error": f"An error occurred: {str(e)}"
        }), 500

if __name__ == "__main__":
    print("\n" + "="*50)
    print("DENGUE BOT API SERVER STARTING")
    print("="*50)
    print("API Endpoints:")
    print("- GET  / : API information")
    print("- GET  /health : Health check")
    print("- POST /ask : Ask questions about dengue")
    print("="*50)
    
    # Run the Flask app on port 8000 to avoid macOS AirPlay conflict
    app.run(debug=True, host='0.0.0.0', port=8000)