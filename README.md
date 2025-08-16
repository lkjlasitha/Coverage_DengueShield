# 🦟 DengueShield - Dengue Outbreak Management System

A comprehensive platform for dengue surveillance and prevention consisting of a mobile app, admin portal, and backend API.

## 📋 System Components

- **Mobile App** (`dengue_shield/`) - Flutter app for public users
- **Admin Portal** (`dengue_shield_admin/`) - Next.js dashboard for health officials  
- **Backend API** (`backend/`) - Flask API server
- **AI Chatbot** (`dengue-chat-bot-LangChainKB/`) - LangChain-based AI assistant

## 🚀 Quick Setup

### Prerequisites
- Node.js 18+
- Python 3.8+
- Flutter SDK 3.0+
- Docker (for chatbot)

### 1. Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
python app.py
# Runs on http://localhost:5000
```

### 2. Admin Portal Setup
```bash
cd dengue_shield_admin
npm install
npm run dev
# Runs on http://localhost:3000
```

### 3. Mobile App Setup
```bash
cd dengue_shield
flutter pub get
flutter run -d chrome  # Web preview
flutter build apk      # Android build
```

### 4. AI Chatbot Setup
```bash
cd dengue-chat-bot-LangChainKB
pip install -r requirements.txt
python main.py
# Runs on http://localhost:8000
```

Or using Docker:
```bash
cd dengue-chat-bot-LangChainKB
docker-compose up -d
```

## ⚙️ Configuration

### Backend Environment
Create `.env` file in `backend/` folder:
```env
DATABASE_URL=sqlite:///dengue_shield.db
SECRET_KEY=your-secret-key
FLASK_ENV=development
```

### Admin Portal Environment  
Create `.env.local` file in `dengue_shield_admin/` folder:
```env
NEXT_PUBLIC_GOOGLE_MAPS_API_KEY=your-maps-api-key
NEXT_PUBLIC_BACKEND_URL=http://localhost:5000
```

### Mobile App Configuration
Update API endpoint in `dengue_shield/lib/config/` files to point to your backend URL.

### AI Chatbot Configuration
Create `.env` file in `dengue-chat-bot-LangChainKB/` folder:
```env
OPENAI_API_KEY=your-openai-api-key
LANGCHAIN_API_KEY=your-langchain-api-key
```

## 🔑 Default Login Credentials
- Email: `admin@government.lk`
- Password: `admin123`

## 🌟 Key Features

### Mobile App
- Dengue symptom checker
- Prevention guidelines
- Emergency contacts
- AI chatbot assistance

### Admin Portal  
- Real-time dashboard
- Appointment management with QR scanner
- Interactive surveillance map
- Fogging request management
- Alert system

### Backend
- Authentication & user management
- RESTful APIs
- AI chatbot integration
- Data management

### AI Chatbot
- LangChain-powered knowledge base
- Dengue-specific information retrieval
- PDF document processing
- Natural language responses

## 🏗️ Architecture

```
Mobile App (Flutter) ←→ Backend API (Flask) ←→ Admin Portal (Next.js)
                            ↓
                    AI Chatbot (LangChain)
```

## 📱 Building for Production

### Android APK
```bash
cd dengue_shield
flutter build apk --release
```

### iOS Build
```bash
cd dengue_shield
flutter build ios --release
```

### Admin Portal Production
```bash
cd dengue_shield_admin
npm run build
npm start
```

### AI Chatbot Production
```bash
cd dengue-chat-bot-LangChainKB
docker build -t dengue-chatbot .
docker run -p 8000:8000 dengue-chatbot
```

## 🔒 Security Notes

- Admin access restricted to government email domains
- JWT-based authentication
- Role-based permissions (Admin, Officer, Supervisor)

## 📞 Support

For issues or questions, please create an issue in this repository.