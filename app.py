# send_file用于向客户端发送文件(如图片、PDF等)作为响应。
from flask import Flask, request, jsonify, send_file
from functools import wraps
import os
import secrets

app = Flask(__name__)

# API密钥存储文件路径
API_KEY_FILE = '/app/api_key.txt'

# 从文件中读取API密钥
def read_api_key():
    if os.path.exists(API_KEY_FILE):
        with open(API_KEY_FILE, 'r') as f:
            return f.read().strip()
    return None

# 验证请求中提供的API密钥
def verify_api_key(token):
    stored_key = read_api_key()
    return stored_key and secrets.compare_digest(stored_key, token)

# 装饰器：验证API密钥
def require_api_key(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.args.get('key')  # 从请求参数中获取密钥
        if not verify_api_key(token):
            return jsonify({"error": "Unauthorized"}), 401
        return f(*args, **kwargs)
    return decorated_function

# 提供随机图片的API，要求提供API密钥
@app.route('/random-image', methods=['GET'])
@require_api_key
def random_image():
    images = [f for f in os.listdir('/app/images') if f.endswith('.webp')]
    selected_image = os.path.join('/app/images', secrets.choice(images))
    return send_file(selected_image, mimetype='image/webp')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
