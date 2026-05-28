-- ============================================================
-- 1. Reset existing data (keep table structure)
-- ============================================================
TRUNCATE TABLE product_translations, products RESTART IDENTITY CASCADE;

-- ============================================================
-- 2. Create base products (7 items)
-- ============================================================
INSERT INTO products (slug, price_cents, category, image_url)
VALUES ('vesna-awakening-elixir', 45000, 'perfume', '/images/vesna.jpg'),
       ('yemanja-radiance-elixir', 45000, 'perfume', '/images/yemanja.jpg'),
       ('hekate-threshold-elixir', 45000, 'perfume', '/images/hekate.jpg'),
       ('inanna-descent-elixir', 45000, 'perfume', '/images/inanna.jpg'),
       ('mazuzu-cream', 32000, 'cream', '/images/mazuzu.jpg'),
       ('lecivka-oil', 32000, 'oil', '/images/lecivka.jpg'),
       ('four-seasons-kit', 160000, 'kit', '/images/kit.jpg');

-- ============================================================
-- 3. Insert product translations (English, Czech, Slovak)
-- ============================================================

-- ---------- ENGLISH (en) ----------
INSERT INTO product_translations (product_id, language_code, name, intro_text, full_description, ingredients_text,
                                  season, goddess)
VALUES (1, 'en', 'Vesna – Follicular Elixir',
        'Awakening • Renewal • Fresh Beginnings.',
        'Wear this potion when you feel the earth turn once more. Let it be the whispered spell for fresh beginnings. Apply to wrists and temples.',
        'Basil. Lemon. Mint. Ginger. Cardamom. Cypress.',
        'spring', 'Vesna'),

       (2, 'en', 'Yemanja – Radiance Elixir',
        'Radiance • Abundance • Flowing Love',
        'Yemanja enhances radiance and confidence during ovulation. Opens the heart and encourages self‑expression. Apply to chest, neck, and solar plexus during your fertile window.',
        'Jasmine, Rose, Cypress, Ginger, Cedarwood, Patchouli.',
        'summer', 'Yemanja'),

       (3, 'en', 'Hekate – Threshold Elixir',
        'Introspection • Inner Knowing • Threshold Wisdom',
        'Hekate supports the luteal phase, encouraging introspection and inner wisdom. It helps you navigate emotional intensity. Apply to the back of your neck and over your heart during the luteal phase.',
        'Bergamot, Geranium, Palmarosa, Lavender, Sandalwood.',
        'autumn', 'Hekate'),

       (4, 'en', 'Inanna – Descent & Rebirth Elixir',
        'Release • Surrender • Sacred Rebirth',
        'Inanna supports menstruation, release, and rebirth. It honors the sacred power of shedding and renewal. Apply to lower belly, inner wrists, and temples during your period.',
        'Bergamot, Thyme, Rose, Geranium, Lavender, Clary Sage, Sandalwood, Frankincense.',
        'winter', 'Inanna'),

       (5, 'en', 'Mazuzu – Healing Cream',
        NULL,
        $$When my daughter was small, she fell into an open fire. Fear settled into my bones. And at night, when the
        doctors failed me and my child whimpered in her sleep — I knew : The earth can heal my girl.I took the sun of
        calendula and laid it to sleep in olive oil.Added the aloe my grandmother gave me, shea for comfort,
        held it together with beeswax, and calmed it with lavender.So my child could dream in peaceful purple fields.The
        cream healed her.Then it healed my husband 's cracked legs, my friend' s baby bottom,
        my own dry face in winter. Handmade. No chemicals. No preservatives. Just a mother and her plants. My daughter fell into fire. This cream was my answer. Mazuzu. Apply a thin layer to affected area as needed. Reapply after washing.$$,
        'Aloe vera, Calendula, Shea butter, beeswax, lavender.',
        NULL, NULL),

       (6, 'en', 'Léčivka – Soothing Oil',
        NULL,
        $$Nettle's sting, mosquito's bite, the sudden burn of a hot pan – life's small aggressions. Lecivka is not a medicine; it is a gentle apology from nature. It provides fast relief from insect bites, stings, and minor burns. Apply directly to the affected area. Repeat as needed.$$,
 'Plantain, comfrey, peppermint.',
 NULL, NULL),

(7, ' en ', ' Four Seasons – Cycle Kit',
 'Complete harmony for your cycle',
 'This kit contains all four seasonal elixirs: Vesna, Yemanja, Hekate, and Inanna.Each bottle supports a different phase
        of your moon cycle.Embrace the wisdom of the seasons.',
 ' Each elixir contains its own blend of essential oils.',
 NULL, NULL);

-- ---------- CZECH (cs) ----------
INSERT INTO product_translations (product_id, language_code, name, intro_text, full_description, ingredients_text, season, goddess) VALUES
(1, ' cs ', ' Vesna – Folikulární elixír ',
 ' Probuzení • Obnova • Nové začátky ',
 ' Noste tento lektvar, když cítíte, že se země znovu otáčí. Nechť je zašeptaným kouzlem nových začátků. Aplikujte na zápěstí a spánky.',
 'Bazalka. Citrón. Máta. Zázvor. Kardamom. Cypřiš.',
 'jaro', 'Vesna'),

(2, 'cs', 'Yemanja – Elixír záře',
 'Záře • Hojnost • Plynoucí láska',
 'Yemanja zvyšuje záři a sebevědomí během ovulace. Otevírá srdce a podporuje sebevyjádření. Aplikujte na hrudník, krk a solar plexus během plodného okna.',
 'Jasmín, Růže, Cypřiš, Zázvor, Cedrové dřevo, Pačuli',
 'léto', 'Yemanja'),

(3, 'cs', 'Hekate – Elixír prahu',
 'Introspekce • Vnitřní vědění • Moudrost prahu',
 'Hekate podporuje luteální fázi, podporuje introspekci a vnitřní moudrost. Pomáhá zvládat emoční intenzitu. Aplikujte na zadní stranu krku a na srdce během luteální fáze.',
 'Bergamot, Geranium, Palmarosa, Levandule, Santalové dřevo',
 'podzim', 'Hekate'),

(4, 'cs', 'Inanna – Elixír sestupu a znovuzrození',
 'Uvolnění • Odevzdání • Posvátné znovuzrození',
 'Inanna podporuje menstruaci,
        uvolnění a znovuzrození. Ctí posvátnou sílu zbavování se a obnovy. Aplikujte na podbřišek, vnitřní stranu zápěstí a spánky během menstruace.',
 'Bergamot, Tymián, Růže, Geranium, Levandule, Šalvěj muškátová, Santalové dřevo, Kadidlo',
 'zima', 'Inanna'),

(5, 'cs', 'Mazuzu – Hojivý krém',
 NULL,
 $$Když moje dcera spadla do ohně, lékaři jen zírali. Šla jsem tedy do své zahrady. Aloe vera – tichý léčitel. Měsíček naložený v olivovém oleji pod ubývajícím měsícem. Bambucké máslo pro útěchu, včelí vosk k udržení magie, levandule k zazpívání ran do spánku. Krém jí zahojil popáleniny. Potom zahojil popraskané nohy mého muže, dětskou zadeček mé přítelkyně, mou vlastní suchou zimní tvář. Žádné chemikálie, žádné konzervanty – jen matčiny ruce a pakt mezi ženami a zelenými věcmi. Toto je Mazuzu. Naneste tenkou vrstvu na popáleniny, suchou pokožku nebo popraskané paty. Podle potřeby opakujte.$$,
 'Aloe vera, Měsíčkový olej, bambucké máslo, včelí vosk, levandulový esenciální olej',
 NULL, NULL),

(6, 'cs', 'Léčivka – Uklidňující olej',
 NULL,
 $$Žahavka kopřivy, štípnutí komára, náhlé popálení horkou pánví – malé agrese života. Léčivka není lék; je to jemné omluvenka od přírody. Poskytuje rychlou úlevu od bodnutí hmyzem, štípanců a drobných popálenin. Aplikujte přímo na postižené místo. Podle potřeby opakujte.$$,
 'Jitrocel, kostival, máta peprná',
 NULL, NULL),

(7, 'cs', 'Čtyři roční období – Cyklus set',
 'Úplná harmonie vašeho cyklu',
 'Tato sada obsahuje všechny čtyři sezónní elixíry: Vesna, Yemanja, Hekate a Inanna. Každá láhev podporuje jinou fázi vašeho měsíčního cyklu. Přijměte moudrost ročních období.',
 'Každý elixír obsahuje vlastní směs esenciálních olejů.',
 NULL, NULL);

-- ---------- SLOVAK (sk) ----------
INSERT INTO product_translations (product_id, language_code, name, intro_text, full_description, ingredients_text, season, goddess) VALUES
(1, 'sk', 'Vesna – Folikulárny elixír',
 'Prebudenie • Obnova • Nové začiatky',
 'Noste tento elixír, keď cítite, že sa zem opäť otáča. Nech je zašepkaným kúzlom nových začiatkov. Aplikujte na zápästia a spánky.',
 'Bazalka. Citrón. Mäta. Zázvor. Kardamóm. Cyprus.',
 'jar', 'Vesna'),

(2, 'sk', 'Yemanja – Elixír žiary',
 'Žiara • Hojnosť • Plynúca láska',
 'Yemanja zvyšuje žiaru a sebavedomie počas ovulácie. Otvára srdce a podporuje sebavyjadrenie. Aplikujte na hrudník, krk a solárny plexus počas plodného okna.',
 'Jazmín, Ruža, Cyprus, Zázvor, Cédrové drevo, Pačuli',
 'leto', 'Yemanja'),

(3, 'sk', 'Hekate – Elixír prahu',
 'Introspekcia • Vnútorné poznanie • Múdrosť prahu',
 'Hekate podporuje luteálnu fázu, podporuje introspekciu a vnútornú múdrosť. Pomáha zvládať emočnú intenzitu. Aplikujte na zadnú stranu krku a na srdce počas luteálnej fázy.',
 'Bergamot, Geranium, Palmarosa, Levanduľa, Santalové drevo',
 'jeseň', 'Hekate'),

(4, 'sk', 'Inanna – Elixír zostupu a znovuzrodenia',
 'Uvoľnenie • Odovzdanie • Posvätné znovuzrodenie',
 'Inanna podporuje menštruáciu,
        uvoľnenie a znovuzrodenie. Cti posvätnú silu zbavovania sa a obnovy. Aplikujte na podbruško, vnútornú stranu zápästí a spánky počas menštruácie.',
 'Bergamot, Tymian, Ruža, Geranium, Levanduľa, Šalvia muškátová, Santalové drevo, Kadidlo',
 'zima', 'Inanna'),

(5, 'sk', 'Mazuzu – Hojivý krém',
 NULL,
 $$Keď moja dcéra spadla do ohňa, lekári len hľadeli. Išla som teda do svojej záhrady. Aloe vera – tichý liečiteľ. Nechtík naložený v olivovom oleji pod ubúdajúcim mesiacom. Bambucké maslo na útechu, včelí vosk na udržanie mágie, levanduľa na zaspievanie rán do spánku. Krém jej zahojil popáleniny. Potom zahojil popraskané nohy môjho muža, detský zadoček mojej priateľky, moju vlastnú suchú zimnú tvár. Žiadne chemikálie, žiadne konzervanty – len matkine ruky a pakt medzi ženami a zelenými vecami. Toto je Mazuzu. Naneste tenkú vrstvu na popáleniny, suchú pokožku alebo popraskané päty. Podľa potreby opakujte.$$,
 'Aloe vera, Nechtíkový olej, bambucké maslo, včelí vosk, levanduľový esenciálny olej',
 NULL, NULL),

(6, 'sk', 'Liečivka – Upokojujúci olej',
 NULL,
 $$Žihľavová pŕhľava, uštipnutie komárom, náhle popálenie horúcou panvicou – malé agresie života. Liečivka nie je liek; je to jemné ospravedlnenie od prírody. Poskytuje rýchlu úľavu od uštipnutí hmyzom, štípancov a drobných popálenín. Aplikujte priamo na postihnuté miesto. Podľa potreby opakujte.$$,
 'Skorocel, kostival, mäta pieporná',
 NULL, NULL),

(7, 'sk', 'Štyri ročné obdobia – Súprava cyklu',
 'Úplná harmónia vášho cyklu',
 'Táto súprava obsahuje všetky štyri sezónne elixíry: Vesna, Yemanja, Hekate a Inanna. Každá fľaša podporuje inú fázu vášho mesačného cyklu. Prijmite múdrosť ročných období.',
 'Každý elixír obsahuje vlastnú zmes esenciálnych olejov.',NULL, NULL);

-- ============================================================
-- 4. Verify data
-- ============================================================
SELECT COUNT(*) AS products_count FROM products;                -- should be 7
SELECT language_code, COUNT(*) FROM product_translations GROUP BY language_code; -- 7 each

UPDATE product_translations
SET name = 'Ishtar – Descent & Rebirth Elixir'
WHERE product_id = '4';