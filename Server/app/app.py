import io
import cv2
import base64
from flask import Flask, request
from imageio import imread
from Measure.detect_points import detect_points
from Render.render import render
from flask_json import FlaskJSON, JsonError, json_response, as_json

# Flask application
app = Flask(__name__)

# Flask-JSONRPC
FlaskJSON(app)


@app.route('/measure', methods=['POST'])
def zozomeasure():
    data = request.get_json(force=True)
    try:
        base64img = str(data['params'])
        gender = str(data['gender'])
    except (KeyError, TypeError, ValueError):
        raise JsonError(description='Invalid value.')
    tmp_img = imread(io.BytesIO(base64.b64decode(base64img)))
    # convert RGB image to BGR for opencv
    cv2_img = cv2.cvtColor(tmp_img, cv2.COLOR_RGB2BGR)
    point_ids, confidences, positions, distances, raw_data = detect_points(cv2_img)
    render(gender, raw_data, len(raw_data))
    with open('output.glb', 'rb') as f:
        encoded = base64.b64encode(f.read())
    return json_response(result=str(encoded))


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, ssl_context='adhoc')
