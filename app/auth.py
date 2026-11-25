import functools

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from .db import get_db

bp = Blueprint("auth", __name__, url_prefix="/auth")


@bp.route("/register", methods=("GET", "POST"))
def register():
    if request.method == "POST":
        email = request.form["email"]
        name = request.form["display_name"]
        password = request.form["password"]
        db = get_db()
        error = None

        if not email:
            error = "Email is required."
        elif not name:
            error = "Name is required."
        elif not password:
            error = "Password is required."

        if error is None:
            try:
                db.execute(
                    "INSERT INTO user (email, display_name, password_hash) VALUES (?, ?, ?)",
                    (email, name, generate_password_hash(password)),
                )
                db.commit()
            except db.IntegrityError:
                error = f"{email} is already registered."
            else:
                return redirect(url_for("auth.login"))

        flash(error)

    return render_template("auth/register.html")


@bp.route("/login", methods=("GET", "POST"))
def login():
    if request.method == "POST":
        email = request.form["email"]
        password = request.form["password"]
        db = get_db()
        error = None

        user = db.execute("SELECT * FROM user WHERE email = ?", (email,)).fetchone()

        if user is None:
            error = "Incorrect email."
        elif not check_password_hash(user["password_hash"], password):
            error = "Incorrect password."

        if error is None:
            # session is a cookie but flask signs it so u cant just edit it
            # and pretend to be user 1. only putting the id in, not the email
            session.clear()
            session["user_id"] = user["id"]
            return redirect(url_for("home"))

        flash(error)

    return render_template("auth/login.html")


@bp.before_app_request
def load_logged_in_user():
    # runs before EVERY request. grabs the id out the cookie and loads the row
    # so templates can just do g.user instead of me querying in every view
    user_id = session.get("user_id")

    if user_id is None:
        g.user = None
    else:
        g.user = get_db().execute(
            "SELECT * FROM user WHERE id = ?", (user_id,)
        ).fetchone()


@bp.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("home"))


def login_required(view):
    """stick @login_required on a view and logged out ppl get bounced to login.
    functools.wraps keeps the original function name, without it flask gets
    confused bc every view would be called "wrapped_view" """

    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for("auth.login"))
        return view(**kwargs)

    return wrapped_view


@bp.route("/me")
@login_required
def me():
    return render_template("auth/me.html")


# ---------------------------------------------------------------------------
# TODO: email verify + password reset. not done yet.
#
# the tutorial i followed stops at login/logout so im on my own for this bit.
# what i worked out so far:
#
#   - user table already has is_verified, defaults to 0, so the column is there
#   - need a token in the link, cant just do /verify/5 bc then anyone can type
#     /verify/1 and verify someone elses account
#   - looked it up, itsdangerous can sign the email with the secret key and
#     stick an expiry on it, and it ships with flask already. looks like:
#         s = URLSafeTimedSerializer(app.secret_key)
#         token = s.dumps(email, salt="verify")
#         s.loads(token, salt="verify", max_age=86400)
#     still need to figure out how to catch it when the token is expired vs
#     just wrong, think its 2 different exceptions
#   - for reset, how do i stop the same link being used twice?? if its just
#     signed it works forever until it expires. ask in the gc
#   - and no actual email sending yet, gmail smtp needs an app password.
#     plan was to dump the email into a txt file for now and copy the link
# ---------------------------------------------------------------------------


@bp.route("/verify/<token>")
def verify(token):
    flash("email verify isnt built yet")
    return redirect(url_for("auth.login"))


@bp.route("/forgot", methods=("GET", "POST"))
def forgot():
    if request.method == "POST":
        flash("password reset isnt built yet sorry")
        return redirect(url_for("auth.login"))
    return render_template("auth/forgot.html")
