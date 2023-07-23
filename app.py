from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return f"Hello from this demo web project :) :D"

if __name__ == "__main__":
         app.run(host='0.0.0.0')