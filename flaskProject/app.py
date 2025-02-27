import numpy as np
import tensorflow as tf


import jsonify

from flask import jsonify
import numpy as np
from flask import Flask,request

app = Flask(__name__)

import joblib

# Load the saved model
new_model = joblib.load('svc1.h5')



@app.route('/upload',methods = ['POST'] )
def upload():
    if request.method == 'POST':

        input_data = request.get_json()['data']

        input_array = np.array(input_data).reshape(1, -1)

        preds = new_model.predict(input_array).astype(int)

        if preds == 1:
            result = 'Autistic'
        else:
            result = 'Non_Autistic'

        return jsonify(result)

     

if __name__ == "__main__":

    app.run(host='0.0.0.0',debug=True,port=5000)

