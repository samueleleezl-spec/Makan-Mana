# Makan-Mana

Decide where to eat around MMU Cyberjaya. Build plan is in [PLAN.md](PLAN.md).

## running it

```
python -m venv .venv
.venv\Scripts\activate
pip install -r requirements.txt
flask --app run init-db
python run.py
```

then http://127.0.0.1:5000

## what works

- sign up (`/auth/register`)
- log in / log out (`/auth/login`, `/auth/logout`)
- `/auth/me` to check the session actually stuck

passwords are hashed with werkzeug, the plain one never goes in the db.

test it:

```
python test_auth.py
```

## not done yet

- **email verification** - route is there but it just flashes a message.
  need to do the token thing, notes are at the bottom of `app/auth.py`
- **password reset** - same, `/auth/forgot` has a form that does nothing
- no actual emails get sent
- landing page (index.html) isnt wired into flask, still static
- restaurant + voting tables, thats Soon and Zheng Long
