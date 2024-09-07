from flask import Flask, request, jsonify, send_file
from functools import wraps
from flask_cors import CORS
import os
import secrets
import random

app = Flask(__name__)
CORS(app) 

API_KEY_FILE = '/app/api_key.txt'

def read_api_key():
    if os.path.exists(API_KEY_FILE):
        with open(API_KEY_FILE, 'r') as f:
            return f.read().strip()
    return None

def verify_api_key(token):
    stored_key = read_api_key()
    return stored_key and secrets.compare_digest(stored_key, token)

def require_api_key(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = kwargs.get('key')
        if not token or not verify_api_key(token):
            return jsonify({"error": "Unauthorized"}), 401
        return f(*args, **kwargs)
    return decorated_function

@app.route('/random-image/<key>', methods=['GET'])
@require_api_key
def random_image(key):
    image_dir = '/app/images'
    if not os.path.exists(image_dir):
        return jsonify({"error": "Image directory not found"}), 404
    
    images = [f for f in os.listdir(image_dir) if f.endswith('.webp')]
    if not images:
        return jsonify({"error": "No images found"}), 404
    
    selected_image = os.path.join(image_dir, random.choice(images))
    
    return send_file(selected_image, mimetype='image/webp')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
