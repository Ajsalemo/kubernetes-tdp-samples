import os
import platform

from flask import Flask, jsonify

app = Flask(__name__)


@app.route("/")
def index():
    return jsonify({ "message": "kubernetes-tdp-samples-aks-python" })


@app.route("/api/info")
def info():
    cores = os.cpu_count()
    container_os = platform.system()
    return jsonify({ "message": f"Current CPU core count is: {cores}. Current OS type is: {container_os}" })
