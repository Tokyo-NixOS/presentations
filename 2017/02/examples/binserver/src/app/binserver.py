from flask import Flask

app = Flask(__name__)

@app.route('/<int:decimal>')
def bin(decimal):
    return "{0:b}".format(decimal)

def run_server():
    app.run('0.0.0.0', 8080)

if __name__ == '__main__':
    run_server()
