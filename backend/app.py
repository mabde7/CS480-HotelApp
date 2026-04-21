from flask import Flask, request, jsonify
from flask_cors import CORS
from db import get_connection

app = Flask(__name__)
CORS(app)

@app.route('/')
def home():
    return "Backend is running"

# TEST DB CONNECTION
@app.route('/test-db')
def test_db():
    try:
        conn = get_connection()
        cur = conn.cursor()
        cur.execute("SELECT NOW();")
        result = cur.fetchone()
        cur.close()
        conn.close()
        return jsonify({"time": str(result[0])})
    except Exception as e:
        return jsonify({"error": str(e)})

# REGISTER MANAGER
@app.route('/manager/register', methods=['POST'])
def register_manager():
    data = request.get_json()

    ssn = data.get('ssn')
    name = data.get('name')
    email = data.get('email')

    if not ssn or not name or not email:
        return jsonify({"error": "Missing fields"}), 400

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "INSERT INTO manager (ssn, name, email) VALUES (%s, %s, %s)",
            (ssn, name, email)
        )

        conn.commit()
        cur.close()
        conn.close()

        return jsonify({"message": "Manager registered"}), 201

    except Exception as e:
        return jsonify({"error": str(e)}), 500

# LOGIN MANAGER
@app.route('/manager/login', methods=['POST'])
def login_manager():
    data = request.get_json()
    ssn = data.get('ssn')

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT * FROM manager WHERE ssn = %s", (ssn,))
        manager = cur.fetchone()

        cur.close()
        conn.close()

        if manager:
            return jsonify({"message": "Login successful"})
        else:
            return jsonify({"error": "Manager not found"}), 404

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)