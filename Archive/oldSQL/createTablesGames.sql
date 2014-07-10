/* (1) Declaration of Game relation 

NOTES:
- We have partial FDs here here as both GameID and rank can act as primary keys. 
- Maybe we should have a separate table for overall rank?
- ScoreFormatType and SortOrder not included. What are they for?

*/

CREATE TABLE Game(
	GameID VARCHAR(10) NOT NULL,
	AgeRating ENUM('3','7','12','16','18') NOT NULL,
	DefaultImage VARCHAR(50) NOT NULL,
	Name VARCHAR(30) NOT NULL,
	OverallRank INT UNIQUE NOT NULL AUTO_INCREMENT,
	Publisher VARCHAR(20) NOT NULL,
	ReleaseDate DATE NOT NULL,
	TextDescription VARCHAR(50)NOT NULL,
	Url VARCHAR(100) DEFAULT NULL,
	Version DECIMAL(4,2) DEFAULT '1.0',

	CONSTRAINT pkGameID
		PRIMARY KEY(GameID));

/* Dummy values for Game */	

INSERT INTO Game (GameID,AgeRating,DefaultImage,Name,Publisher,ReleaseDate,TextDescription) VALUES(
	'A1','18','./img.jpg','GTA V','Rockstar','2013-1-01','A bloody mess');
INSERT INTO Game (GameID,AgeRating,DefaultImage,Name,Publisher,ReleaseDate,TextDescription) VALUES(
	'A2','18','./img.jpg','The Last of Us','Naughty Dog','2013-12-15','The best game ever');
INSERT INTO Game (GameID,AgeRating,DefaultImage,Name,Publisher,ReleaseDate,TextDescription) VALUES(
	'A3','3','./img.jpg','FIFA 14','EA','2014-1-1','Football. Note: England suck');

/* TRIGGER NEEDED FOR GAME RANK ON UPDATE */

/* (2) Declaration of Genre relation 

NOTE:
- GenreDescription left out. Do we need it?

*/

CREATE TABLE Genre(
	GenreID VARCHAR(10) NOT NULL,
	GenreName VARCHAR(20) NOT NULL,
	
	CONSTRAINT pkGenreID
		PRIMARY KEY(GenreID));

/* Dummy values */

INSERT INTO Genre VALUES(
	'001','Horror');
INSERT INTO Genre VALUES(
	'002','Adventure');
INSERT INTO Genre VALUES(
	'003','Sport');
INSERT INTO Genre VALUES(
	'004','Mutliplayer');

/* (3) Declaration of GameToGenre linking relation */

CREATE TABLE GameToGenre(
	GameID VARCHAR(10) NOT NULL,
	GenreID VARCHAR(10) NOT NULL,
	RankInGenre INT DEFAULT NULL,

	CONSTRAINT pkIDs
		PRIMARY KEY(GameID,GenreID),
	CONSTRAINT fkGameID
		FOREIGN Key(GameID)
		REFERENCES Game(GameID),
	CONSTRAINT fkGenreID
		FOREIGN Key(GenreID)
		REFERENCES Genre(GenreID));
	

/* Dummy values */

INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A3','003');
INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A3','004');
INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A1','002');
INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A1','004');
INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A2','001');
INSERT INTO GameToGenre(GameID,GenreID) VALUES(
	'A2','002');	


/* Trigger to work out rank to be added */


