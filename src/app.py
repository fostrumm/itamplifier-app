from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello van de Azure Container App! 🚀"

if __name__ == "__main__":
    # We laten de app luisteren op alle interfaces (0.0.0.0) 
    # en op de poort die we in Azure hebben opengezet.
    app.run(host='0.0.0.0', port=5000)