# Dengue Bot - LangChain PDF Question Answering System

A Python application that uses LangChain and Google's Generative AI to answer questions based on PDF documents.

## Features

- PDF text extraction and processing
- Document embedding using Google's Generative AI
- Vector similarity search with FAISS
- Question-answering chain using Google's Gemini Pro model
- Environment-based API key management

## Setup

### Prerequisites

- Python 3.8 or higher
- Google Generative AI API key (free tier available)

### Installation

1. Clone or download this repository
2. Install the required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Create a `.env` file in the project root and add your Google API key:
   ```
   GOOGLE_API_KEY=your_api_key_here
   ```

4. Place your PDF file in the project directory and update the filename in the script

### Getting a Google Generative AI API Key

1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Create a new API key
4. Copy the key and add it to your `.env` file

## Usage

1. Make sure your PDF file is in the project directory
2. Update the PDF filename in `main.py` if needed
3. Run the application:
   ```bash
   python3 main.py
   ```

4. The script will:
   - Load and process your PDF
   - Create embeddings for text chunks
   - Allow you to ask questions about the document content

## File Structure

```
dengue-bot/
├── main.py              # Main application file
├── requirements.txt     # Python dependencies
├── .env                # Environment variables (create this)
├── .env.example        # Example environment file
└── README.md           # This file
```

## Example Questions

The system can answer questions like:
- "What are the basic human rights?"
- "What is the highest and final superior Court in Sri Lanka?"

## Notes

- Make sure your PDF file exists in the project directory
- The system works best with well-formatted PDF documents
- Text extraction quality depends on the PDF's format and content

## Dependencies

- `langchain`: Framework for developing applications with language models
- `PyPDF2`: PDF file processing
- `faiss-cpu`: Vector similarity search
- `tiktoken`: Tokenization
- `langchain-community`: Community extensions for LangChain
- `langchain-google-genai`: Google Generative AI integration
- `python-dotenv`: Environment variable management
