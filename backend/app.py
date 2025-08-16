from flask import Flask, request, jsonify
from flask_cors import CORS
from database import db
from models import Appointment, User
import config
import jwt
from datetime import datetime, timedelta
from werkzeug.security import generate_password_hash, check_password_hash
import smtplib
from email.mime.text import MIMEText

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{config.DB_USER}:{config.DB_PASSWORD}@{config.DB_HOST}/{config.DB_NAME}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()

def send_email(to_email, subject, message):
    msg = MIMEText(message)
    msg['From'] = config.EMAIL_USER
    msg['To'] = to_email
    msg['Subject'] = subject
    try:
        with smtplib.SMTP(config.SMTP_SERVER, config.SMTP_PORT) as server:
            server.starttls()
            server.login(config.EMAIL_USER, config.EMAIL_PASS)
            server.sendmail(config.EMAIL_USER, to_email, msg.as_string())
    except Exception as e:
        print(f"Email error: {e}")

def verify_jwt(token):
    try:
        return jwt.decode(token, config.JWT_SECRET, algorithms=["HS256"])
    except:
        return None

def generate_jwt(payload, minutes=60):
    payload['exp'] = datetime.utcnow() + timedelta(minutes=minutes)
    return jwt.encode(payload, config.JWT_SECRET, algorithm="HS256")

@app.route("/signup", methods=["POST"])
def signup():
    data = request.json
    name, email, password, role = data.get("name"), data.get("email"), data.get("password"), data.get("role", "user")

    if User.query.filter_by(email=email).first():
        return jsonify({"error": "Email already registered"}), 400

    user = User(name=name, email=email, role=role)
    user.set_password(password)
    db.session.add(user)
    db.session.commit()

    return jsonify({"message": "User registered successfully"}), 201

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email, password = data.get("email"), data.get("password")

    user = User.query.filter_by(email=email).first()
    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid credentials"}), 401

    token = generate_jwt({"email": user.email, "name": user.name, "role": user.role})
    return jsonify({"token": token, "role": user.role})

@app.route("/book", methods=["POST"])
def book_appointment():
    data = request.json
    decoded_user = verify_jwt(data.get("jwt"))
    if not decoded_user:
        return jsonify({"error": "Invalid or expired token"}), 401

    appointment = Appointment(
        hospital_name=data.get("hospitalName"),
        date=data.get("date"),
        time=data.get("time"),
        category=data.get("category"),
        jwt=data.get("jwt"),
        email=decoded_user["email"],
        reference_num=data.get("referenceNum"),
        pdf=data.get("PDF", False)
    )
    db.session.add(appointment)
    db.session.commit()

    send_email(
        decoded_user["email"],
        "Appointment Confirmation",
        f"Hello {decoded_user.get('name')}, your appointment at {data.get('hospitalName')} is confirmed."
    )

    return jsonify({"message": "Appointment booked successfully"}), 201

@app.route("/appointments", methods=["GET"])
def get_appointments():
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"error": "Missing token"}), 401

    token = auth_header.split(" ")[1]
    decoded_user = verify_jwt(token)
    if not decoded_user:
        return jsonify({"error": "Invalid or expired token"}), 401

    if decoded_user["role"] == "admin":
        appointments = Appointment.query.all()
    else:
        appointments = Appointment.query.filter_by(email=decoded_user["email"]).all()

    return jsonify([a.to_dict() for a in appointments]), 200

if __name__ == "__main__":
    app.run(debug=True)
