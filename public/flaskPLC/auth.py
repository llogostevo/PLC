import functools

from flask import (
    Blueprint, flash, g, redirect, render_template, request, session, url_for
)
from werkzeug.security import check_password_hash, generate_password_hash

from flaskPLC.db import get_db

bp = Blueprint('auth', __name__, url_prefix='/auth')

# REGISTER
@bp.route('/register', methods=('GET', 'POST'))
def register():
    if request.method == 'POST':
        firstName = request.form['firstName']
        secondName = request.form['secondName']
        email = request.form['emailAddress']
        password = request.form['password']
        userType = "student"

        db = get_db()
        error = None

        if not email:
            error = 'Email is required.'
        elif not password:
            error = 'Password is required.'

        if error is None:
            try:
                db.execute(
                    "INSERT INTO user (firstName, secondName, email, password, userType) VALUES (?, ?, ?, ?, ?)",
                    (firstName, secondName, email, generate_password_hash(password), userType),
                )
                db.commit()
            except db.IntegrityError:
                error = f"User {email} is already registered."
            else:
                return redirect(url_for("auth.login"))

        flash(error)

    return render_template('auth/register.html')

# LOGIN

@bp.route('/login', methods=('GET', 'POST'))
def login():
    if request.method == 'POST':
        email = request.form['emailAddress']
        password = request.form['password']
        db = get_db()
        error = None
        user = db.execute(
            'SELECT * FROM user WHERE email = ?', (email,)
        ).fetchone()

        if user is None:
            error = 'Incorrect email.'
        elif not check_password_hash(user['password'], password):
            error = 'Incorrect password.'

        if error is None:
            session.clear()
            session['user_id'] = user['id']
            return redirect(url_for('index'))

        flash(error)

    return render_template('auth/login.html')

# BEFORE REQUEST TO CHECK IF USER IS STORED IN A SESSION

@bp.before_app_request
def load_logged_in_user():
    user_id = session.get('user_id')

    if user_id is None:
        g.user = None
    else:
        g.user = get_db().execute(
            'SELECT * FROM user WHERE id = ?', (user_id,)
        ).fetchone()


# LOGOUT
@bp.route('/logout')
def logout():
    session.clear()
    return redirect(url_for('auth.login'))

# REQUIRE AUTHENTICATION IN OTHER VIEWS
def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for('auth.login'))

        return view(**kwargs)

    return wrapped_view

