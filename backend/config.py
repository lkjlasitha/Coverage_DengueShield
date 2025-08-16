import os
from dotenv import load_dotenv

load_dotenv()

# Database
DB_USER = os.getenv("DB_USER", "app_user")
DB_PASSWORD = os.getenv("DB_PASSWORD", "app_password_here")
DB_HOST = os.getenv("DB_HOST", "db")
DB_NAME = os.getenv("DB_NAME", "appointments_db")

# Email
EMAIL_USER = os.getenv("EMAIL_USER")
EMAIL_PASS = os.getenv("EMAIL_PASS")
SMTP_SERVER = os.getenv("SMTP_SERVER", "smtp.gmail.com")
SMTP_PORT = int(os.getenv("SMTP_PORT", 587))

# JWT Secret
JWT_SECRET = os.getenv("JWT_SECRET", "yoursecret")
