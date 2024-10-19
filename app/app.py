from flask import Flask, request, jsonify, send_file
from functools import wraps
from flask_cors import CORS
import os
import secrets
import random

# import subprocess
import logging
from logging.handlers import RotatingFileHandler

app = Flask(__name__)
CORS(app)

API_KEY_FILE = "/app/api_key.txt"
IMAGE_DIR = "/app/images"
app.config["API_KEY"] = None
app.config["IMAGE_LIST"] = []


def check_file_exists(path):
    if not os.path.exists(path):
        logging.error(f"{path} not found. Exiting...")
        return False
    return True


def require_api_key(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = kwargs.get("key")
        if not token or not verify_api_key(token):
            return jsonify({"error": "Unauthorized"}), 401
        return f(*args, **kwargs)

    return decorated_function


@app.route("/update-key/<key>", methods=["GET"])
@require_api_key
def update_api_key(key):
    app.config["API_KEY"] = read_api_key()
    if not app.config["API_KEY"]:
        return jsonify({"error": "API key not found or invalid"}), 404
    return jsonify({"message": "API key updated successfully"}), 200


def read_api_key():
    if os.path.exists(API_KEY_FILE):
        with open(API_KEY_FILE, "r") as f:
            key = f.read().strip()
            if key:
                return key
    logging.error(
        f'API key file {API_KEY_FILE} not found or empty.Try run "update-api-key" command.'
    )
    return None


def verify_api_key(token):
    stored_key = app.config["API_KEY"]
    return stored_key and secrets.compare_digest(stored_key, token)


def parse_image_list():
    if not os.path.exists(IMAGE_DIR):
        os.makedirs(IMAGE_DIR)
    app.config["IMAGE_LIST"] = [f for f in os.listdir(IMAGE_DIR) if f.endswith(".webp")]
    logging.info(f"Initialized with {len(app.config['IMAGE_LIST'])} images.")


@app.route("/update-images/<key>", methods=["GET"])
@require_api_key
def update_images(key):
    parse_image_list()
    if not app.config["IMAGE_LIST"]:
        return jsonify({"error": "No images found"}), 404
    return jsonify({"message": "Images list updated"}), 200


@app.route("/random-image/<key>", methods=["GET"])
@require_api_key
def random_image(key):
    if not app.config["IMAGE_LIST"]:
        return jsonify({"error": "No images found"}), 404
    selected_image = random.choice(app.config["IMAGE_LIST"])
    return send_file(os.path.join(IMAGE_DIR, selected_image), mimetype="image/webp")


if __name__ == "__main__":
    handler = RotatingFileHandler(
        "/app/log/app.log", maxBytes=10 * 1024 * 1024, backupCount=10
    )
    handler.setLevel(logging.INFO)
    formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
    handler.setFormatter(formatter)
    logging.getLogger().addHandler(handler)
    logging.getLogger().addHandler(logging.StreamHandler())
    logging.getLogger().setLevel(logging.INFO)
    parse_image_list()
    app.config["API_KEY"] = read_api_key()
    logging.info(f"API key init:{app.config['API_KEY']}")
    if not app.config["API_KEY"]:
        logging.error("API key not found or invalid. Exiting.")
        exit(1)
    app.run(host="0.0.0.0", port=5000)
