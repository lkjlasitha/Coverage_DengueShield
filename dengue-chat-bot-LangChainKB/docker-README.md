# Dengue Bot API - Docker Setup

## Prerequisites
- Docker installed on your system
- Docker Compose installed
- `.env` file with your `GOOGLE_API_KEY`
- `den1.pdf` file in the project directory

## Quick Start

### Option 1: Using the build script
```bash
./docker-build.sh
```

### Option 2: Manual Docker commands
```bash
# Build the image
docker build -t dengue-bot:latest .

# Run with docker-compose
docker-compose up -d
```

### Option 3: Direct Docker run
```bash
# Build the image
docker build -t dengue-bot:latest .

# Run the container
docker run -d \
  --name dengue-bot-api \
  -p 8000:8000 \
  -v "$(pwd)/.env:/app/.env:ro" \
  -v "$(pwd)/den1.pdf:/app/den1.pdf:ro" \
  dengue-bot:latest
```

## API Endpoints

Once running, your API will be available at:
- **Health Check**: `GET http://localhost:8000/health`
- **API Info**: `GET http://localhost:8000/`
- **Ask Questions**: `POST http://localhost:8000/ask`

## Example API Usage

```bash
# Health check
curl http://localhost:8000/health

# Ask a question
curl -X POST http://localhost:8000/ask \
  -H "Content-Type: application/json" \
  -d '{"question": "What is dengue?"}'
```

## Container Management

```bash
# View logs
docker-compose logs -f

# Stop the container
docker-compose down

# Restart the container
docker-compose restart

# View container status
docker-compose ps
```

## Environment Variables

Make sure your `.env` file contains:
```
GOOGLE_API_KEY=your_google_api_key_here
```

## Troubleshooting

1. **Port already in use**: Change the port mapping in `docker-compose.yml` from `8000:8000` to `8001:8000`
2. **API key not found**: Ensure your `.env` file is in the project root
3. **PDF not found**: Ensure `den1.pdf` is in the project root

## Production Deployment

For production, consider:
1. Using environment variables instead of `.env` files
2. Setting up proper secrets management
3. Using a production WSGI server like Gunicorn
4. Setting up proper logging and monitoring
