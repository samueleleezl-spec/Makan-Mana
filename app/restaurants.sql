-- restaurant list from our research doc (Restaurants Near MMU Cyberjaya)
-- this file only touches the restaurant table, the user table is safe
-- run: flask --app run init-restaurants

DROP TABLE IF EXISTS restaurant;

CREATE TABLE restaurant (
  id             INTEGER PRIMARY KEY,
  name           TEXT NOT NULL,
  cuisine        TEXT,
  price          TEXT,
  halal_status   TEXT,
  opening_hours  TEXT,
  map_link       TEXT
);

INSERT INTO restaurant (name, cuisine, price, halal_status, opening_hours, map_link) VALUES
('Azeey Kopitiam (inside MMU, Starbees Bldg)', 'Malaysian / kopitiam', 'RM1–20', 'Not confirmed', 'Mon–Fri 8AM–8PM', 'https://maps.google.com/maps?cid=8742053260948765542'),
('Nasi Kandar Haji Deen', 'Mamak', 'RM1–20', 'Muslim-run (Indian Muslim)', '24 hrs', 'https://maps.google.com/maps?cid=13044212344425280509'),
('Amir Damascus', 'Arabic', 'RM20–40', 'Not confirmed', 'Mon–Thu 8AM–2AM; Fri 8AM–12:30PM & 2PM–3AM; Sat 8AM–12AM; Sun 8AM–3AM', 'https://maps.google.com/maps?cid=1918407607556697522'),
('Deen Cafe', 'Indian Muslim, Western, local', 'RM1–20', 'Muslim-run', 'Daily 10AM–2AM', 'https://maps.google.com/maps?cid=8701528889588559235'),
('Dude''s Cafe', 'Fusion', 'RM20–40', 'Muslim-owned', 'Mon–Thu, Sat–Sun 11AM–10PM; Fri 11AM–1PM & 3–10PM', 'https://maps.google.com/maps?cid=1492063131835843471'),
('Padi House, Nadayu 99', 'Asian fusion / Western', 'RM20–40', 'Not confirmed', 'Sun–Thu 7:30AM–12AM; Fri–Sat 7:30AM–1:30AM', 'https://maps.google.com/maps?cid=6844261267300251346'),
('Glaze Eatery (Tamarind Sq)', 'Asian fusion / cafe', 'RM20–40', 'Not confirmed', 'Daily 9AM–11:30PM', 'https://maps.google.com/maps?cid=512287087631455478'),
('10gram', 'Asian fusion / Western', 'RM20–40', 'Muslim-friendly (has a surau)', 'Daily 10AM–11PM', 'https://maps.google.com/maps?cid=10722659351024233363'),
('Bakers & Steak by 10gram', 'Steakhouse', 'RM20–40', 'Not confirmed', 'Daily 10AM–11PM', 'https://maps.google.com/maps?cid=1675285806214790330'),
('Duer Cafe (Tamarind Sq)', 'Malaysian / Western', 'RM20–40', 'Not confirmed', 'Daily 10AM–10PM', 'https://maps.google.com/maps?cid=8324165996777196860'),
('Texas BBQ Barn', 'American BBQ', NULL, 'Not confirmed', 'Daily 11AM–11PM', 'https://maps.google.com/maps?cid=4450344575887985016'),
('Hunger Cafe', 'Fusion, pizza, pasta', 'RM20–40', 'Not confirmed', 'Fri 12–3PM, 6–10:30PM (other days not listed)', 'https://maps.google.com/maps?cid=8298063736551197234'),
('Mr.Mee', 'Chinese Muslim (Xinjiang)', 'RM1–20', 'Halal-certified', 'Daily 10:30AM–10PM', 'https://maps.google.com/maps?cid=9256647824503068743'),
('Homst', 'Chinese Muslim', 'RM20–40', 'Halal-certified', 'Mon–Thu 11AM–10:30PM; Fri–Sun 11AM–11PM', 'https://maps.google.com/maps?cid=3076671842627960936'),
('Restoran Jamek', 'Mamak', 'RM1–20', 'Muslim-run', '24 hrs', 'https://maps.google.com/maps?cid=8757466271596434283'),
('Murni Discovery', 'Mamak / kopitiam', 'RM20–40', 'Not confirmed', 'Daily 7AM–2AM', 'https://maps.google.com/maps?cid=18216169511554286222'),
('Nasi Kandar Pelita', 'Mamak', 'RM1–20', 'Muslim-run', '24 hrs', 'https://maps.google.com/maps?cid=4501646053569643861'),
('DapurMu', 'Chinese Muslim', 'RM20–40', 'Halal ingredients, pork-free', 'Mon–Fri 8AM–10PM; Sat–Sun 10AM–10PM', 'https://maps.google.com/maps?cid=11158434590590238262'),
('Restoran SRS Maju', 'Mamak', 'RM1–20', 'Muslim-run', '24 hrs', 'https://maps.google.com/maps?cid=17525823022128810884'),
('Raihana One Bistro', 'Mamak / Malay', 'RM1–20', 'Muslim-run', '24 hrs', 'https://maps.google.com/maps?cid=7903252156206455025'),
('Pak Ngah Kopitiam', 'Malaysian / kopitiam', 'RM1–20', 'Not confirmed', 'Mon–Fri 7AM–3PM & 5–9:30PM; Sun 7AM–3PM; closed Sat (cash only)', 'https://maps.google.com/maps?cid=13495071458106856973'),
('Giggles & Geeks', 'Western / local', 'RM20–40', 'Halal-certified', 'Mon–Thu 11:30AM–10:30PM; Fri 11AM–11:30PM; Sat–Sun 10AM–11:30PM', 'https://maps.google.com/maps?cid=4730686505985701145'),
('Namo Garden (Shaftsbury Sq)', 'Arabic', 'RM20–40', 'Not confirmed', 'Daily 12PM–12AM', 'https://maps.google.com/maps?cid=285909857724819798'),
('D''Kunafa Cafe', 'Arabic', 'RM1–20', 'Not confirmed', 'Mon–Fri 7AM–7PM', 'https://maps.google.com/maps?cid=9051451606647201837'),
('Kor.B Korean (Shaftsbury Sq)', 'Korean', 'RM1–20', 'Muslim-friendly (no pork or alcohol)', 'Daily 11AM–10PM', 'https://maps.google.com/maps?cid=7031210658699405901'),
('Kung Fu Restaurant (Shaftsbury Sq)', 'Chinese', 'RM20–40', 'Non-halal', 'Daily 11AM–10PM', 'https://maps.google.com/maps?cid=9223141442521308922'),
('KFC Edusphere DT', 'Fast food (fried chicken)', 'RM20–40', 'Halal-certified', '24 hrs', 'https://maps.google.com/maps?cid=359167069114441480'),
('McDonald''s Edusphere DT', 'Fast food (burgers)', 'RM20–40', 'Halal-certified', '24 hrs', 'https://maps.google.com/maps?cid=6233734263003165075');
