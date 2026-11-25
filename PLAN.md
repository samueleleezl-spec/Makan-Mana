# Makan Mana? — build plan

Group G01. Based on our market research (Beli + Google Maps, 21 Nov) and Mr Willie's
feedback on the proposal (21 Oct).

## 1. The main idea

Research findings, short version:

- Beli proves pairwise voting works, but it only tracks where you already ate.
  No group room, no "decide for me".
- Google Maps gives you a list sorted by stars. A list is not a decision.

So our thing is: **we end with one answer.**

Mr Willie's feedback and our own section 5.2 both land on the same trick:

> every decision the app makes should also be a vote

Group opens a room -> app auto-picks 2 finalists using ELO + recently eaten + some
randomness -> group votes between those two -> that vote updates ELO.

Nobody has to visit a separate "rank places" page. The app gets better every time
someone actually uses it. This is also our answer to the cold start problem, which
our research says is the biggest risk.

**Rule: every feature either feeds this loop or we cut it.**

## 2. Scope

Mr Willie said scope is a bit big, but if we cut, everyone still has stuff to build.
Decide now, not in week 10.

| Build | Cut / defer |
| --- | --- |
| Browse + filter spots | Photo upload + resizing (use OSM images or placeholder) |
| Pairwise vote + ELO | Custom hand-made personal rankings |
| Campus + cuisine rankings | Social feed, friends, match score |
| Group Decide Room | Streaks, points, heavy gamification |
| Decide for Me | Anything AI |
| Halal / diet requirements | Native app, push notifications |
| Admin review queue | |

Admin review queue stays. Research says data freshness (closures, price changes,
halal changes) is where both Beli and Maps slip. That is a feature, not an extra.

## 3. What makes ours better

1. **Fair pairs.** Beli's worst reviews are about comparing Korean BBQ to a deli.
   We only pair spots in the same cuisine or same price band. Cheap to build,
   kills their biggest complaint.
2. **Honest halal, not a boolean.** Four states: `jakim_certified`,
   `no_pork_muslim_owned`, `not_halal`, `unknown`. The OSM `diet:halal` tag only
   means "declared halal", so import it as unknown and let admin/reports promote it.
   Link each spot to the Halal Malaysia Portal.
3. **Verified student votes.** Harder to fake than Google reviews, where Malaysian
   shops hand out vouchers for 5 stars. This lives in the auth work (section 5).
4. **"Too tough" button.** Beli has skip. Stops forced guesses from polluting ELO.

## 4. Build order

**Phase 1 — skeleton (all three, week 1).**
Flask app factory, SQLite schema, base template, one shared CSS file.
Agree the schema BEFORE anyone writes routes. This is the only real blocker
between us.

**Phase 2 — split up.**
- Soon: seed spots from OpenStreetMap (Overpass API around MMU Cyberjaya).
  This should be his FIRST job, not his last, because it unblocks everyone.
  Mr Willie said starting from scratch means the app won't realistically get used.
- Zheng Long: ELO engine against the seeded data.
- Zarif: auth.

**Phase 3 — the core loop.** browse -> vote -> rank working end to end. Test it
properly. Research says stability before features.

**Phase 4 — rooms.** Decide for Me first, then Group Decide Room on top of it.

**Phase 5 — polish.** Admin queue, report form, fix the mobile nav on the landing
page (currently the nav links just disappear below 860px with nothing replacing them).

## 5. Zarif's first slice: auth

Scope: register, login, email verify, password reset. It's plumbing, keep it tight.
The interesting work is the Decide Room.

**Libraries:** Flask-Login, `werkzeug.security` for hashing, `itsdangerous` for
tokens. All already come with Flask or are tiny. Not using Flask-Security /
Flask-User, too much baggage for 6 routes.

**Schema:**

```sql
CREATE TABLE user (
  id              INTEGER PRIMARY KEY,
  email           TEXT UNIQUE NOT NULL COLLATE NOCASE,
  password_hash   TEXT NOT NULL,
  display_name    TEXT NOT NULL,
  is_verified     INTEGER NOT NULL DEFAULT 0,
  is_admin        INTEGER NOT NULL DEFAULT 0,
  created_at      TEXT NOT NULL DEFAULT (datetime('now'))
);
```

`COLLATE NOCASE` on email matters, otherwise `Zarif@...` and `zarif@...` become
two different accounts.

**Routes:** `/register`, `/verify/<token>`, `/login`, `/logout`, `/forgot`,
`/reset/<token>`. One blueprint.

**Tokens:** don't store them in the DB. `itsdangerous.URLSafeTimedSerializer`
signs the user id with a salt and an expiry. Verify = 24h, reset = 1h.
No table, no cleanup job.

**Big decision:** only allow `@student.mmu.edu.my` to register. Three lines in the
validator, and it's what makes "verified student votes" actually true instead of
just a claim in the report. Also keeps the campus leaderboard meaningful.
Downside: Mr Willie can't make a test account with a personal email, so add an
admin-seeded bypass account.

**Things that lose marks if skipped:**

- `/forgot` must say "if that email exists we sent a link" whether or not it does.
  Otherwise anyone can check which emails are registered.
- Reset token must die after use. Easiest way without a table: put the current
  `password_hash` into the signed payload, so changing the password breaks the token.
- Rate limit `/login` and `/forgot`. A dict of `{ip: [timestamps]}` is enough here.

**Email in dev:** don't set up SMTP yet. Write the emails to `logs/mail/` as .txt
and print the link to the console. Swap in real SMTP at the end behind one function.
Otherwise we burn a whole day on Gmail app passwords.

**Test:** one test that registers -> grabs token -> verifies -> logs in.
If that passes, auth works.

## 6. Risks

1. **Cold start.** Dead rankings = dead app. Fixed by the loop in section 1 plus
   seeding real OSM data on day one.
2. **Schema churn.** Three people, one SQLite file. Lock the schema in phase 1 or
   we spend week 6 merging migrations.
3. **Scope.** Already warned about it. Section 2 is the cut list, decide it now
   while it's cheap.
