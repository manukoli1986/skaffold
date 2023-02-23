#!/usr/bin/env python3
#Importing module of flask framework to run app on web
from flask import Flask
import datetime


# Create the application.
app = Flask(__name__)


# Displays the index page accessible at '/'
@app.route("/")
def index():
    return "Hello World !!! - v1"


# This code is finish and ready to server on port 80
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
