import os

from flask import Flask, render_template


def create_app():
    # the app factory. tutorial says make the app inside a function instead of
    # a global one, something about tests being able to make their own
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY="dev",  # TODO change this before we hand it in
        DATABASE=os.path.join(app.instance_path, "makanmana.sqlite"),
    )

    os.makedirs(app.instance_path, exist_ok=True)

    from . import db
    db.init_app(app)

    from . import auth
    app.register_blueprint(auth.bp)

    @app.route("/")
    def home():
        return render_template("home.html")

    return app
