from database import db
from werkzeug.security import generate_password_hash, check_password_hash

class User(db.Model):
    __tablename__ = "user"   

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), default='user')  
    appointments = db.relationship('Appointment', backref='user', lazy=True)

    def set_password(self, password):
        self.password_hash = generate_password_hash(password)

    def check_password(self, password):
        return check_password_hash(self.password_hash, password)

class Appointment(db.Model):
    __tablename__ = "appointment"   

    id = db.Column(db.Integer, primary_key=True)
    hospital_name = db.Column(db.String(255), nullable=False)
    date = db.Column(db.String(50), nullable=False)
    time = db.Column(db.String(50), nullable=False)
    category = db.Column(db.String(100), nullable=False)
    jwt = db.Column(db.Text, nullable=False)
    email = db.Column(db.String(255), nullable=False)
    reference_num = db.Column(db.String(100), nullable=False)
    pdf = db.Column(db.Boolean, default=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)

    def to_dict(self, include_user=False):
        data = {
            "hospitalName": self.hospital_name,
            "date": self.date,
            "time": self.time,
            "category": self.category,
            "jwt": self.jwt,
            "email": self.email,
            "referenceNum": self.reference_num,
            "PDF": self.pdf
        }
        if include_user and self.user:
            data["userName"] = self.user.name
        return data
