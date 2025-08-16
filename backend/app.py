from flask import Flask, request, jsonify
from flask_cors import CORS
from database import db
from models import Appointment, User
import config
import jwt
from datetime import datetime, timedelta
import smtplib
from email.mime.text import MIMEText

app = Flask(__name__)
CORS(app)

app.config['SQLALCHEMY_DATABASE_URI'] = f"mysql+pymysql://{config.DB_USER}:{config.DB_PASSWORD}@{config.DB_HOST}/{config.DB_NAME}"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db.init_app(app)

with app.app_context():
    db.create_all()

# ----------------- Helpers -----------------
def appointment_email_template(user_name, hospital_name, date, time, reference_num):
    return f"""
    <html>
      <body style="font-family: Arial, sans-serif; color: #333;">
        <h2 style="color: #2c3e50;">Appointment Confirmation</h2>
        <p>Dear <b>{user_name}</b>,</p>
        <p>Your appointment has been successfully booked with the following details:</p>
        <table style="border-collapse: collapse; width: 100%; margin: 15px 0;">
          <tr>
            <td style="padding: 8px; border: 1px solid #ddd;"><b>Hospital</b></td>
            <td style="padding: 8px; border: 1px solid #ddd;">{hospital_name}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #ddd;"><b>Date</b></td>
            <td style="padding: 8px; border: 1px solid #ddd;">{date}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #ddd;"><b>Time</b></td>
            <td style="padding: 8px; border: 1px solid #ddd;">{time}</td>
          </tr>
          <tr>
            <td style="padding: 8px; border: 1px solid #ddd;"><b>Reference Number</b></td>
            <td style="padding: 8px; border: 1px solid #ddd;">{reference_num}</td>
          </tr>
        </table>
        <p>Please arrive at least <b>15 minutes</b> before your appointment.</p>
        <p style="margin-top: 20px;">Thank you,<br><i>Appointment Booking Team</i></p>
      </body>
    </html>
    """

def send_email(to_email, subject, message, is_html=False):
    msg = MIMEText(message, "html" if is_html else "plain")
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

# ----------------- Auth Routes -----------------
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

    token = generate_jwt({"email": user.email, "name": user.name, "role": user.role, "id": user.id})
    return jsonify({"message": "User registered successfully", "token": token, "role": user.role})

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email, password = data.get("email"), data.get("password")

    user = User.query.filter_by(email=email).first()
    if not user or not user.check_password(password):
        return jsonify({"error": "Invalid credentials"}), 401

    token = generate_jwt({"email": user.email, "name": user.name, "role": user.role, "id": user.id})
    return jsonify({"token": token, "role": user.role})

# ----------------- Appointment Routes -----------------
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
        pdf=data.get("PDF", False),
        user_id=decoded_user["id"]
    )
    db.session.add(appointment)
    db.session.commit()

    # Use the email template
    email_html = appointment_email_template(
        decoded_user.get("name"),
        data.get("hospitalName"),
        data.get("date"),
        data.get("time"),
        data.get("referenceNum")
    )
    send_email(decoded_user["email"], "Appointment Confirmation", email_html, is_html=True)

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
        appointments = Appointment.query.filter_by(user_id=decoded_user["id"]).all()

    return jsonify([a.to_dict(include_user=True) for a in appointments]), 200

# ----------------- User Info Route -----------------
@app.route("/me", methods=["GET"])
def get_user_info():
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return jsonify({"error": "Missing token"}), 401

    token = auth_header.split(" ")[1]
    decoded_user = verify_jwt(token)
    if not decoded_user:
        return jsonify({"error": "Invalid or expired token"}), 401

    user = User.query.filter_by(id=decoded_user["id"]).first()
    if not user:
        return jsonify({"error": "User not found"}), 404

    return jsonify({
        "id": user.id,
        "name": user.name,
        "email": user.email,
        "role": user.role
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
