import io
import cv2
import base64
import json
from flask import Flask, request
from imageio import imread
from flask_jsonrpc import JSONRPC
from Measure.detect_points import detect_points
from Render.render import render
from flask import jsonify
from flask_json import FlaskJSON, JsonError, json_response, as_json

# Flask application
app = Flask(__name__)

# Flask-JSONRPC
# jsonrpc = JSONRPC(app, '/api')
FlaskJSON(app)


# @jsonrpc.method('App.index')
def index() -> str:
    return 'Welcome to Flask JSON-RPC'

# @jsonrpc.method('App.paramtest')
def paramtest(a1: str) -> str:
    
    return "Du bist ein {0}".format(a1)


# @jsonrpc.method('App.zozomeasure')
@app.route('/zozomeasure', methods=['POST'])
def zozomeasure():
    # tmp_img = imread(io.BytesIO(base64.b64decode(a1)))
    # convert RGB image to BGR for opencv
    # cv2_img = cv2.cvtColor(tmp_img, cv2.COLOR_RGB2BGR)
    # point_ids, confidences, positions, distances, raw_data = detect_points(cv2_img)
    # Todo: raw_data => pose + betas
    # render('female')
    # with open('server/output.stl', 'rb') as f:
    #     encoded = base64.b64encode(f.read())
    # return str(encoded)


    data = request.get_json(force=True)
    try:
        base64img = str(data['params'])
    except (KeyError, TypeError, ValueError):
        raise JsonError(description='Invalid value.')
    tmp_img = imread(io.BytesIO(base64.b64decode(base64img)))
    # convert RGB image to BGR for opencv
    cv2_img = cv2.cvtColor(tmp_img, cv2.COLOR_RGB2BGR)
    point_ids, confidences, positions, distances, raw_data = detect_points(cv2_img)
    # Todo: raw_data => pose + betas
    # render('female')
    with open('server/output.stl', 'rb') as f:
        encoded = base64.b64encode(f.read())
    return json_response(encoded)


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
