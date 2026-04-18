from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_extended import (
    JWTManager,
    create_access_token,
    jwt_required
)
from flasgger import Swagger
from dotenv import load_dotenv
from datetime import timedelta
import os

# ---------------------------------------------------
# Load Environment Variables
# ---------------------------------------------------
load_dotenv()

app = Flask(__name__)

# ---------------------------------------------------
# Configuration
# ---------------------------------------------------
app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv("DATABASE_URL")
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET_KEY"] = os.getenv("JWT_SECRET_KEY")
app.config["JWT_ACCESS_TOKEN_EXPIRES"] = timedelta(hours=2)

db = SQLAlchemy(app)
jwt = JWTManager(app)
swagger = Swagger(app)

# ---------------------------------------------------
# Database Model
# ---------------------------------------------------
class Record(db.Model):
    __tablename__ = "records"

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    category = db.Column(db.String(80), nullable=False)
    status = db.Column(db.String(50), nullable=False)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "category": self.category,
            "status": self.status
        }

# ---------------------------------------------------
# Initialize Tables
# ---------------------------------------------------
with app.app_context():
    db.create_all()

# ---------------------------------------------------
# Home Route
# ---------------------------------------------------
@app.route("/")
def home():
    return jsonify({
        "message": "TPM Prework API Running",
        "swagger": "/apidocs"
    })

# ---------------------------------------------------
# Login Route
# ---------------------------------------------------
@app.route("/login", methods=["POST"])
def login():
    """
    Login API
    ---
    tags:
      - Authentication
    consumes:
      - application/json
    parameters:
      - in: body
        name: credentials
        schema:
          type: object
          properties:
            username:
              type: string
            password:
              type: string
    responses:
      200:
        description: JWT Token
    """
    data = request.get_json()

    username = data.get("username")
    password = data.get("password")

    # Demo credentials
    if username == "admin" and password == "admin123":
        token = create_access_token(identity=username)
        return jsonify(access_token=token), 200

    return jsonify({"error": "Invalid credentials"}), 401

# ---------------------------------------------------
# Add Record
# ---------------------------------------------------
@app.route("/records", methods=["POST"])
@jwt_required()
def add_record():
    data = request.get_json()

    record = Record(
        name=data["name"],
        category=data["category"],
        status=data["status"]
    )

    db.session.add(record)
    db.session.commit()

    return jsonify({
        "message": "Record added successfully",
        "data": record.to_dict()
    }), 201

# ---------------------------------------------------
# Get All / Filter Records
# ---------------------------------------------------
@app.route("/records", methods=["GET"])
@jwt_required()
def get_records():
    status = request.args.get("status")
    category = request.args.get("category")

    query = Record.query

    if status:
        query = query.filter_by(status=status)

    if category:
        query = query.filter_by(category=category)

    records = query.all()

    return jsonify([r.to_dict() for r in records]), 200

# ---------------------------------------------------
# Update Record
# ---------------------------------------------------
@app.route("/records/<int:record_id>", methods=["PUT"])
@jwt_required()
def update_record(record_id):
    record = Record.query.get(record_id)

    if not record:
        return jsonify({"error": "Record not found"}), 404

    data = request.get_json()

    record.name = data.get("name", record.name)
    record.category = data.get("category", record.category)
    record.status = data.get("status", record.status)

    db.session.commit()

    return jsonify({
        "message": "Record updated",
        "data": record.to_dict()
    })

# ---------------------------------------------------
# Delete Record
# ---------------------------------------------------
@app.route("/records/<int:record_id>", methods=["DELETE"])
@jwt_required()
def delete_record(record_id):
    record = Record.query.get(record_id)

    if not record:
        return jsonify({"error": "Record not found"}), 404

    db.session.delete(record)
    db.session.commit()

    return jsonify({"message": "Record deleted"}), 200

# ---------------------------------------------------
# Run App
# ---------------------------------------------------
if __name__ == "__main__":
    app.run(debug=True)