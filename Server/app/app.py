import io
import cv2
import base64
import json
from flask import Flask
from imageio import imread
from flask_jsonrpc import JSONRPC
from Measure.detect_points import detect_points
from flask import jsonify

# Flask application
app = Flask(__name__)

# Flask-JSONRPC
jsonrpc = JSONRPC(app, '/api', enable_web_browsable_api=True)


@jsonrpc.method('App.index')
def index() -> str:
    return 'Welcome to Flask JSON-RPC'

@jsonrpc.method('App.paramtest')
def paramtest(a1: str) -> str:
    
    return "Du bist ein {0}".format(a1)


@jsonrpc.method('App.zozomeasure')
def zozomeasure(a1: str) -> str:
    tmp_img = imread(io.BytesIO(base64.b64decode(a1)))
    # convert RGB image to BGR for opencv
    cv2_img = cv2.cvtColor(tmp_img, cv2.COLOR_RGB2BGR)
    point_ids, confidences, positions, distances, raw_data = detect_points(cv2_img)
    return '-'.join(str(e) for e in raw_data)


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)