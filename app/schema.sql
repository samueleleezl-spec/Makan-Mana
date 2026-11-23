-- auth tables only for now, Soon is doing the spot/restaurant ones
-- dont add stuff here without telling the gc first, we agreed to lock schema in phase 1

DROP TABLE IF EXISTS user;

CREATE TABLE user (
  id              INTEGER PRIMARY KEY,
  email           TEXT UNIQUE NOT NULL COLLATE NOCASE,
  password_hash   TEXT NOT NULL,
  display_name    TEXT NOT NULL,
  is_verified     INTEGER NOT NULL DEFAULT 0,
  is_admin        INTEGER NOT NULL DEFAULT 0,
  created_at      TEXT NOT NULL DEFAULT (datetime('now'))
);
