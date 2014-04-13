-- SQL code to create Game, Genre, GameToGenre, and GameImage (currently disabled) tables.
/* Code layout/format:
	-Game Table code and dummy values
	-Genre Table code and dummy values
	-GameToGenre code and dummy values
	-GameImage code and dummy values (currently commented out of Game table as foreign key)
*/

/* Game table code */
DROP TABLE Game;
CREATE TABLE Game (
	gameID INT,
	ageRating INT NOT NULL,
	defaultImageID INT DEFAULT 0, --Make game image table e.g. 0 is blank icon, other values for other images.
	name VARCHAR(50) NOT NULL UNIQUE,
	--Delete Overall Rank? Rank value could come from GameToGenre table for genreID = all genres. Good to isolate rank from Game?
	--overallRank INT DEFAULT 0, --MySQL default is 0 but stated anyway. Not unique in case usr ratings equal.
	publisher VARCHAR(50),
	releaseDate DATE NOT NULL,
	textDescription VARCHAR(1000),
	url VARCHAR(100),
	versionNumber FLOAT DEFAULT 1.0 NOT NULL,
	CONSTRAINT pkGameID
		PRIMARY KEY (gameID),
	--CONSTRAINT fkDefImg
		--FOREIGN KEY (defaultImageID)
		--REFERENCES GameImage (gameImageID)
	CHECK (ageRating = 3 OR ageRating = 7 OR ageRating = 12 OR ageRating = 16 OR ageRating = 18) --UK/EU PEGI game age ratings
);
--Game table test values
INSERT INTO Game
	VALUES (null, 7, 0, 'Angry Birds',  'Rovio Entertainment Ltd', '2010-03-09', 'Save the angry birds!', 'www.angrybirds.com', 
		   1.0); --should fail: null gameid test (checking primary key default setup includes not null).
INSERT INTO Game
	VALUES (1, 7, 0, 'Angry Birds',  'Rovio Entertainment Ltd', '2010-03-09', 'Save the angry birds!', 'www.angrybirds.com', 
		   1.0);
INSERT INTO Game
	VALUES (2, 18, 0, 'XCOM: Enemy Unknown',  '2K Games', '2013-04-06', 'Threatened by an unknown enemy...', 'www.xcom.com', 
		   1.6);
INSERT INTO Game
	VALUES (3, 18, 0, 'Infinity Blade',  'Chair Entertainment Group', '2012-02-03', '...', 
		   'www.infinity.com', 1.4);
INSERT INTO Game
	VALUES (4, 3, 0, 'Shark Dash',  'Gameloft', '2012-02-03', '...', 'www.sharkdash.com', 1.89);


/* Genre table generation code */
DROP TABLE Genre
CREATE TABLE Genre (
	genreID INT,
	name VARCHAR(50) NOT NULL UNIQUE,
	genreDescription VARCHAR(100),
	CONSTRAINT pkGenreID
		PRIMARY KEY (genreID)
);
--Genre table test values
INSERT INTO Genre
	VALUES (1, 'Overall', 'All games');
INSERT INTO Genre
	VALUES (2, 'Action', 'Action games');
INSERT INTO Genre
	VALUES (3, 'Indie', 'Indie games');
INSERT INTO Genre
	VALUES (4, 'Strategy', 'Strategic games');


/* GameToGenre table */
DROP TABLE GameToGenre
CREATE TABLE GameToGenre (
	gameID INT,
	genreID INT,
	rankWithinGenre INT,
	CONSTRAINT pkGameGenre
		PRIMARY KEY (gameID, genreID),
	CONSTRAINT fkGameID
		FOREIGN KEY (gameID)
		REFERENCES Game (gameID),
	CONSTRAINT fkGenreID
		FOREIGN KEY (genreID)
		REFERENCES Genre (genreID)
);
--GameToGenre table test values
INSERT INTO GameToGenre
	VALUES (1, 2, 1); --Angry Birds, indie
INSERT INTO GameToGenre
	VALUES (4, 2, 2); --Shark Dash, indie
INSERT INTO GameToGenre
	VALUES (3, 1, 1); --Infity Blade, action
INSERT INTO GameToGenre
	VALUES (2, 3, 1); --XCOM, strategy


--GameImage table (all game front covers)
CREATE TABLE GameImage (
	gameImageID INT,
	filepath VARCHAR(100),
	CONSTRAINT pkGameImgID
		PRIMARY KEY (gameImageID)
);
--GameImage table test values
INSERT INTO GameImage
	VALUES (0, './images/blank.jpg');
INSERT INTO GameImage
	VALUES (1, './images/angrybirds.jpg');
INSERT INTO GameImage
	VALUES (2, './images/xcom.jpg');
INSERT INTO GameImage
	VALUES (3, './images/infinityblade.jpg');
INSERT INTO GameImage
	VALUES (4, './images/sharkdash.jpg');



	

	
