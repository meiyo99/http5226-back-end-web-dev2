-- Create the database
CREATE DATABASE IF NOT EXISTS GameReviewSystemDB;
USE GameReviewSystemDB;

-- Table: platforms
CREATE TABLE IF NOT EXISTS platforms (
    platform_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE
);

-- Table: games
CREATE TABLE IF NOT EXISTS games (
    game_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    release_date DATE NOT NULL,
    description VARCHAR(255) NOT NULL, -- As per ERD, VARCHAR(255) for description
    developer VARCHAR(255) NOT NULL,
    publisher VARCHAR(255) NOT NULL
);

-- Table: reviews
-- Note: UserID is not in the provided ERD for this table, so it's omitted here.
CREATE TABLE IF NOT EXISTS reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    date DATETIME NOT NULL,
    rating INT NOT NULL,
    headline VARCHAR(255) NOT NULL,
    text VARCHAR(255) NOT NULL, -- As per ERD, VARCHAR(255) for review text
    status VARCHAR(255) NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE
);

-- Table: game_platforms (Junction Table)
CREATE TABLE IF NOT EXISTS game_platforms (
    game_platform_id INT AUTO_INCREMENT PRIMARY KEY,
    game_id INT NOT NULL,
    platform_id INT NOT NULL,
    FOREIGN KEY (game_id) REFERENCES games(game_id) ON DELETE CASCADE,
    FOREIGN KEY (platform_id) REFERENCES platforms(platform_id) ON DELETE CASCADE,
    UNIQUE (game_id, platform_id) -- Ensures a game is listed only once per platform
);

-- Populate platforms table
INSERT INTO platforms (name) VALUES
('PC'),
('PlayStation 5'),
('Xbox Series X'),
('Nintendo Switch'),
('PlayStation 4'),
('Xbox One');

-- Populate games table
INSERT INTO games (title, release_date, description, developer, publisher) VALUES
('Cyber Odyssey 2077', '2023-03-15', 'An open-world action RPG set in a dystopian future. Explore Night City and define your legend.', 'CD Future Works', 'Future Publishing'),
('Mystic Realms: Echoes', '2022-11-01', 'A high-fantasy RPG with a rich story and tactical combat. Journey through the land of Eldoria.', 'Dragon Forge Studios', 'Epic Quest Games'),
('Star Voyager Online', '2024-01-20', 'A massively multiplayer online space exploration and combat game. Chart unknown galaxies.', 'Galaxy Interactive', 'Cosmic Ventures'),
('Pixel Racers Turbo', '2023-07-10', 'A retro-style arcade racing game with vibrant pixel art and a catchy soundtrack.', 'RetroWave Games', 'IndieBoost'),
('Chronicles of Eldoria', '2022-05-12', 'Embark on an epic adventure in a vast open world filled with magic and monsters.', 'Fantasy Softworks', 'Mythic Games Inc.');


-- Populate reviews table
INSERT INTO reviews (game_id, date, rating, headline, text, status) VALUES
(1, '2023-03-20 10:00:00', 8, 'A Glimpse into a Dystopian Future', 'Cyber Odyssey 2077 offers a visually stunning world, but has some launch bugs. Great story!', 'Approved'),
(1, '2023-03-22 14:30:00', 9, 'Night City Beckons!', 'Incredible immersion and storytelling. The patches have improved performance significantly.', 'Approved'),
(2, '2022-11-05 09:15:00', 9, 'A Modern Classic RPG', 'Mystic Realms: Echoes delivers on its promise of a deep and engaging RPG experience.', 'Approved'),
(2, '2022-11-10 17:00:00', 7, 'Good, but a bit grindy', 'The story is great, and combat is fun, but some quests feel repetitive. Overall enjoyable.', 'Approved'),
(3, '2024-01-25 11:00:00', 7, 'Vast Universe, Needs More Content', 'Star Voyager Online has a massive galaxy to explore, but currently feels a bit empty.', 'Pending'),
(3, '2024-02-01 16:45:00', 8, 'Promising MMO with Great Potential', 'The core gameplay loop is fun, and the community is growing. Excited for future updates!', 'Approved'),
(4, '2023-07-15 12:00:00', 10, 'Pixel Perfect Fun!', 'Pixel Racers Turbo is pure arcade joy. Amazing soundtrack and tight controls!', 'Approved'),
(5, '2022-06-01 08:00:00', 6, 'Beautiful World, Generic Quests', 'Eldoria is stunning to look at, but the quest design feels uninspired. Decent for a playthrough.', 'Approved');

-- Populate game_platforms table
-- Cyber Odyssey 2077 (ID 1) on PC, PS5, Xbox Series X
INSERT INTO game_platforms (game_id, platform_id) VALUES
(1, (SELECT platform_id FROM platforms WHERE name = 'PC')),
(1, (SELECT platform_id FROM platforms WHERE name = 'PlayStation 5')),
(1, (SELECT platform_id FROM platforms WHERE name = 'Xbox Series X'));

-- Mystic Realms: Echoes (ID 2) on PC, PS4
INSERT INTO game_platforms (game_id, platform_id) VALUES
(2, (SELECT platform_id FROM platforms WHERE name = 'PC')),
(2, (SELECT platform_id FROM platforms WHERE name = 'PlayStation 4'));

-- Star Voyager Online (ID 3) on PC
INSERT INTO game_platforms (game_id, platform_id) VALUES
(3, (SELECT platform_id FROM platforms WHERE name = 'PC'));

-- Pixel Racers Turbo (ID 4) on PC, Nintendo Switch
INSERT INTO game_platforms (game_id, platform_id) VALUES
(4, (SELECT platform_id FROM platforms WHERE name = 'PC')),
(4, (SELECT platform_id FROM platforms WHERE name = 'Nintendo Switch'));

-- Chronicles of Eldoria (ID 5) on PC, PlayStation 5, Xbox Series X
INSERT INTO game_platforms (game_id, platform_id) VALUES
(5, (SELECT platform_id FROM platforms WHERE name = 'PC')),
(5, (SELECT platform_id FROM platforms WHERE name = 'PlayStation 5')),
(5, (SELECT platform_id FROM platforms WHERE name = 'Xbox Series X'));

-- Verification Queries (Optional - to check if data is inserted)
SELECT * FROM platforms;
SELECT * FROM games;
SELECT * FROM reviews;
SELECT * FROM game_platforms;

SELECT g.title, p.name AS platform_name
FROM games g
JOIN game_platforms gp ON g.game_id = gp.game_id
JOIN platforms p ON gp.platform_id = p.platform_id
WHERE g.title = 'Cyber Odyssey 2077';

SELECT g.title, r.headline, r.rating, r.status
FROM games g
JOIN reviews r ON g.game_id = r.game_id
WHERE g.title = 'Mystic Realms: Echoes';