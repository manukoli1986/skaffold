#!/usr/bin/env python3
#Importing module of flask framework to run app on web
from flask import Flask, render_template
import datetime


# Create the application.
app = Flask(__name__)


# Displays the index page accessible at '/'
@app.route("/")
def index():
    print ("Hello World !!! - v2")
    return "This is second deployment. Kindly use /image uri to get output"


# This code is finish and ready to server on port 80
if __name__ == "__main__":
    app.run(host='0.0.0.0', port=80, debug=True)
