from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  # Enables Cross-Origin requests for your frontend

@app.route('/', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy", "service": "portfolio-api"})

@app.route('/api/data', methods=['GET'])
def get_data():
    return jsonify({"message": "Hello from ECS Fargate Microservice!"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
