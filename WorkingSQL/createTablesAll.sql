/* User relations */
CREATE TABLE UserPublic(
	UserName VARCHAR(20) NOT NULL,
	Avatar VARCHAR(50) NOT NULL,
	CreationDate DATE NOT NULL,
	AccountStatus ENUM('Online','Offline', 'Locked') NOT NULL DEFAULT'Offline',
	LastLogin TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UserStatus VARCHAR(100) DEFAULT NULL,

	CONSTRAINT pkUserName
		PRIMARY KEY(UserName)
);

CREATE TABLE UserPrivate(
	UserName VARCHAR(20) NOT NULL,
	Password VARCHAR(20) NOT NULL,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Email VARCHAR(30) NOT NULL,

	CONSTRAINT pkUserName
		PRIMARY KEY(UserName),
	CONSTRAINT fkUserName
		FOREIGN Key(UserName)
		REFERENCES UserPublic(UserName)
);

CREATE TABLE Friends(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends
		PRIMARY KEY(AccHolder,Friend),
	CONSTRAINT fkUser1
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName)
);

CREATE TABLE Friends2(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends2
		PRIMARY KEY(AccHolder,Friend),
	CONSTRAINT fkUser1_1
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2_1
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName)
);

/* Game relations */
CREATE TABLE Game(
	GameID INT NOT NULL,
	AgeRating ENUM('3','7','12','16','18') NOT NULL,
	DefaultImage VARCHAR(50) NOT NULL,
	Name VARCHAR(30) NOT NULL,
	AverageRating FLOAT DEFAULT NULL,
	NoOfRatings INT NULL,
	OverallRank INT UNIQUE NOT NULL AUTO_INCREMENT,
	Publisher VARCHAR(20) NOT NULL,
	ReleaseDate DATE NOT NULL,
	TextDescription VARCHAR(50)NOT NULL,
	Url VARCHAR(100) DEFAULT NULL,
	Version DECIMAL(4,2) DEFAULT '1.0',

	CONSTRAINT pkGameID
		PRIMARY KEY(GameID)
);

CREATE TABLE Genre(
	GenreID INT NOT NULL,
	Name VARCHAR(20) NOT NULL,
	
	CONSTRAINT pkGenreID
		PRIMARY KEY(GenreID)
);

CREATE TABLE GameToGenre(
	GameID INT NOT NULL,
	GenreID INT NOT NULL,
	RankInGenre INT DEFAULT NULL,

	CONSTRAINT pkIDs
		PRIMARY KEY(GameID,GenreID),
	CONSTRAINT fkGameID
		FOREIGN Key(GameID)
		REFERENCES Game(GameID),
	CONSTRAINT fkGenreID
		FOREIGN Key(GenreID)
		REFERENCES Genre(GenreID)
);

CREATE TABLE GameImage (
	GameImageID INT NOT NULL,
	GameID INT NOT NULL,
	FilePath VARCHAR(100),
	DefaultImage ENUM('True','False') NOT NULL,

	CONSTRAINT pkGameImgID
		PRIMARY KEY (gameImageID),
	CONSTRAINT fkGameID2
		FOREIGN Key(GameID)
		REFERENCES Game(GameID)
);

/* Linking relation for Users & Games */
CREATE TABLE UserToGame(
	ID INT NOT NULL AUTO_INCREMENT,
	UserName VARCHAR(20) NOT NULL,
	GameID INT NOT NULL,
	GameInProgress ENUM('Yes','No') NOT NULL DEFAULT'No',
	InMatch ENUM('Yes','No') NOT NULL DEFAULT'No',
	HighestScore INT NOT NULL DEFAULT'0',
	LastPlayDate DATE DEFAULT NULL,
	UserRating FLOAT NOT NULL DEFAULT'0.0',
	AgeRating ENUM('Unrated','1','2','3','4','5') NOT NULL DEFAULT'Unrated',
	Comments VARCHAR(100) NOT NULL DEFAULT'No comments',

	CONSTRAINT pkID
		PRIMARY KEY(ID),
	CONSTRAINT fk_U2G_UserName
		FOREIGN KEY(UserName)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fk_U2G_GameID
		FOREIGN KEY(GameID)
		REFERENCES Game(GameID)
);

/* Acheivement relations */
CREATE TABLE Achievement (
	achievementID INT AUTO_INCREMENT,
	gameID INT NOT NULL,
	title VARCHAR(50) NOT NULL,
	hiddenFlag BIT(1) NOT NULL DEFAULT 0, /* achievements shown by default */
	icon INT DEFAULT 0,
	pointValue INT NOT NULL DEFAULT 1,
	postDescription VARCHAR(200),
	preDescription VARCHAR(200),
	CONSTRAINT pkAchievement
		PRIMARY KEY (achievementID),
	CONSTRAINT fkAchievToGame
		FOREIGN KEY (GameID)
		REFERENCES Game (GameID)
);

/* Linking relation for Achievements, Users & Games */
CREATE TABLE AchievementToUserToGame (
	achievementID INT,
	userToGameID INT,
	dateGained DATE NOT NULL,
	CONSTRAINT pkAchievUsrGame
		PRIMARY KEY (userToGameID, achievementID),
	CONSTRAINT fk
		FOREIGN KEY (userToGameID)
		REFERENCES UserToGame (ID)	
);