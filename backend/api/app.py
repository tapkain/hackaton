from flask import Flask
from endpoint.post import bp
from context import create


app = Flask(__name__)
app.register_blueprint(bp)
c = create(True)
app.db = c.db

if __name__ == '__main__':
    app.run(debug=True)
