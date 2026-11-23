"""quick check that signing up and logging in works.
run it with: python test_auth.py

not proper pytest, just asserts. good enough to catch me breaking something
"""
import os
import tempfile

from app import create_app
from app.db import init_db

fd, db_path = tempfile.mkstemp(suffix=".sqlite")
os.close(fd)

app = create_app()
app.config["DATABASE"] = db_path
app.config["TESTING"] = True
with app.app_context():
    init_db()

c = app.test_client()

# sign up
r = c.post("/auth/register", data={"email": "zarif@test.com", "display_name": "zarif", "password": "abc123"})
assert r.status_code == 302, "register should send you to the login page"

# cant sign up twice with the same email
r = c.post("/auth/register", data={"email": "zarif@test.com", "display_name": "zarif", "password": "abc123"})
assert b"already registered" in r.data

# wrong password doesnt get in
r = c.post("/auth/login", data={"email": "zarif@test.com", "password": "wrongpw"})
assert b"Incorrect password" in r.data

# right password does
r = c.post("/auth/login", data={"email": "zarif@test.com", "password": "abc123"}, follow_redirects=True)
assert b"logged in as" in r.data, "should be logged in now"

# and /me loads
assert b"Logged in" in c.get("/auth/me").data

# logged out ppl get bounced off /me
c2 = app.test_client()
assert c2.get("/auth/me").status_code == 302

os.unlink(db_path)
print("register + login + logout all work")
