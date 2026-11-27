import sqlite3

import click
from flask import current_app, g


def get_db():
    # g is a per-request box. one connection per request instead of one per query
    if "db" not in g:
        g.db = sqlite3.connect(current_app.config["DATABASE"])
        g.db.row_factory = sqlite3.Row  # lets me do row["email"] instead of row[1]
    return g.db


def close_db(e=None):
    db = g.pop("db", None)
    if db is not None:
        db.close()


def init_db():
    db = get_db()
    with current_app.open_resource("schema.sql") as f:
        db.executescript(f.read().decode("utf8"))


@click.command("init-db")
def init_db_command():
    """wipes the db and rebuilds it. run: flask --app run init-db"""
    init_db()
    click.echo("db made fresh")


@click.command("init-restaurants")
def init_restaurants_command():
    """(re)loads the restaurant table only. run: flask --app run init-restaurants"""
    db = get_db()
    with current_app.open_resource("restaurants.sql") as f:
        db.executescript(f.read().decode("utf8"))
    click.echo("restaurants loaded")


def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)
    app.cli.add_command(init_restaurants_command)
