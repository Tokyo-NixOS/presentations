from flask import Flask, request, render_template, jsonify
from scipy.misc import imsave, imread, imresize
from io import BytesIO
from keras.models import load_model
import numpy as np
import os
import base64
import re

app = Flask(__name__)
# Loading the model
model = load_model(os.environ.get('MODEL'))

@app.route('/')
def index():
    return render_template("index.html")

@app.route('/predict/', methods=['POST'])
def predict():
    # Getting the posted data (base64)
    imgData = BytesIO( base64.b64decode( re.sub('^data:image/.+;base64,', '', request.get_data()) ) )
    # Formatting the image
    x = imresize(np.invert(imread(imgData,mode='L')) ,(28,28)).reshape(1,28,28,1)
    # Use the model to classify the data
    h = model.predict(x)
    # return the response as json
    return jsonify ({
        'prediction' : np.argmax(h[0])
      , 'data'       : h[0].tolist()
    })

def run_server():
    port = int( os.environ.get('PORT', 8080) )
    host = os.environ.get('HOST', '0.0.0.0')
    app.run(host, port)

if __name__ == '__main__':
    run_server
