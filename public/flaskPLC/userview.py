from flask import (
    Blueprint, flash, g, redirect, render_template, request, url_for
)
from werkzeug.exceptions import abort

from flaskPLC.auth import login_required
from flaskPLC.db import get_db

bp = Blueprint('userview', __name__)


@bp.route('/')
def index():
    db = get_db()
    users = db.execute(
        'SELECT id, firstName, secondName, email, userType'
        ' FROM user'
    ).fetchall()
    return render_template('profile/index.html', users=users)