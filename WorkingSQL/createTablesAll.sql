/* This file holds all the create statements to generate the database. */

/* User information  relations */
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
	Email VARCHAR(30) NOT NULL UNIQUE,

	CONSTRAINT pkUserName
		PRIMARY KEY(UserName),
	CONSTRAINT fkUserName
		FOREIGN Key(UserName)
		REFERENCES UserPublic(UserName)
);

/* Game relations */
CREATE TABLE Game(
	GameID INT NOT NULL AUTO_INCREMENT,
	AgeRating ENUM('3','7','12','16','18') NOT NULL,
	DefaultImage VARCHAR(50) NOT NULL,
	Name VARCHAR(30) NOT NULL,
	AverageRating FLOAT DEFAULT NULL,
	NoOfRatings INT DEFAULT NULL,
	/*OverallRank INT UNIQUE DEFAULT NULL,*/
	Publisher VARCHAR(20) NOT NULL,
	ScoreFormat VARCHAR(20) NOT NULL DEFAULT 'points',
	SortOrder ENUM('asc','desc') NOT NULL DEFAULT 'desc',
	ReleaseDate DATE NOT NULL,
	TextDescription VARCHAR(50)NOT NULL,
	Url VARCHAR(100) DEFAULT NULL,
	Version DECIMAL(4,2) DEFAULT '1.0',
	MaxScore INT DEFAULT NULL,
	MinScore INT DEFAULT NULL,

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
	LastScore INT DEFAULT '0',
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

/* Friendship Relations */ 
CREATE TABLE Friends(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends
		PRIMARY KEY(AccHolder, Friend),
	CONSTRAINT fkUser
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName)
);

/* Friend request relation with game invites */
CREATE TABLE FriendRequest(
	RequestID INT NOT NULL AUTO_INCREMENT,
	Requester VARCHAR(20) NOT NULL,
	Requestee VARCHAR(20) DEFAULT NULL,
	Email VARCHAR(30) DEFAULT NULL,
	Response ENUM('Pending','Accepted','Declined','Completed') NOT NULL DEFAULT'Pending',
	/*GameInvite INT DEFAULT NULL,
	InviteResponse ENUM('Accepted','Denied','Pending') NOT NULL DEFAULT'Pending',
	*/
	CONSTRAINT pkFriendReq
		PRIMARY KEY(RequestID),
	CONSTRAINT fkRequester
		FOREIGN Key(Requester)
		REFERENCES UserPrivate(UserName),
	CONSTRAINT fkRequestee
		FOREIGN Key(Requestee)
		REFERENCES UserPrivate(UserName),
	CONSTRAINT fkReqEmail
		FOREIGN Key(Email)
		REFERENCES UserPrivate(Email)
);

/* Leaderboards */ 
CREATE TABLE Leaderboard(
	LeaderboardID INT NOT NULL AUTO_INCREMENT,
	GameID INT NOT NULL,
	SortOrder ENUM('asc','desc') NOT NULL DEFAULT 'desc',
	TimePeriod ENUM('forever','1_year','1_week','1_day') NOT NULL DEFAULT 'forever',
	IsDefault BOOLEAN NOT NULL DEFAULT 0,
	
	CONSTRAINT pkLdbdID
		PRIMARY KEY (LeaderboardID),
	CONSTRAINT fk_ldbd_GameID
		FOREIGN KEY(GameID)
		REFERENCES Game(GameID)
);

/* Plays relation records any time a user plays a game */
CREATE TABLE Plays(
	PlayID INT AUTO_INCREMENT,
	GameID INT NOT NULL,
	UserName VARCHAR(20) NOT NULL,
	TimeOfPlay TIMESTAMP,
	
	CONSTRAINT pkNoOfPlaysID
		PRIMARY KEY(PlayID)
);

/* Scores relation records all of the scores made on any game*/
CREATE TABLE Scores(
	ScoreID INT AUTO_INCREMENT,
	UserToGameID INT NOT NULL,
	Score INT NOT NULL,
	TimeOfScore TIMESTAMP NOT NULL,
	
	CONSTRAINT pk_scores
		PRIMARY KEY (ScoreID)
);

/* Acheivement relation */
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

/* Matches relations */
CREATE TABLE Matches (
	MatchID INT AUTO_INCREMENT,
	MatchName VARCHAR(30) NOT NULL,
	Initiator INT NOT NULL,
	MinPlayers INT NOT NULL DEFAULT 2,
	MaxPlayers INT NOT NULL DEFAULT 2,
	NoOfPlayer INT NOT NULL DEFAULT 1,
	Status ENUM('not_started', 'in_play', 'ended') NOT NULL DEFAULT 'not_started',
	
	CONSTRAINT pkMatch
		PRIMARY KEY (MatchID),
	CONSTRAINT fkmatch1
		FOREIGN KEY (Initiator)
		REFERENCES UserToGame(ID)
);

/* Linking relation for matches, users and games */
CREATE TABLE MatchToUserToGame(
	MatchID INT NOT NULL,
	UserToGameID INT NOT NULL,
	PlayerStatus ENUM('playing', 'paused', 'quit') NOT NULL DEFAULT 'playing',
	
	CONSTRAINT pkMatchToUserToGame
		PRIMARY KEY (MatchID, UserToGameID),
	CONSTRAINT fkMTUTG1
		FOREIGN KEY (MatchID)
		REFERENCES Matches(MatchID),
	CONSTRAINT fkmtutg2
		FOREIGN KEY (UserToGameID)
		REFERENCES UserToGame(ID)
);

CREATE TABLE MatchRequest (
	MatchRequestID INT AUTO_INCREMENT,
	SendingUTG INT NOT NULL,
	ReceivingUTG INT NOT NULL,
	MatchID INT NOT NULL,
	Response ENUM('Accepted','Denied','Pending') NOT NULL DEFAULT'Pending',
	
	CONSTRAINT pkmatchrequest
		PRIMARY KEY (MatchRequestID),
	CONSTRAINT fkmatchrequest
		FOREIGN KEY (SendingUTG)
		REFERENCES UserToGame(ID),
	CONSTRAINT fkmatchrequest2
		FOREIGN KEY (ReceivingUTG)
		REFERENCES UserToGame(ID)
);

/* Relation to hold contain obscene/offensive terms */
CREATE TABLE RudeWord (
	word VARCHAR(50),
	
	CONSTRAINT pkRudeWord
		PRIMARY KEY (word)
);


SHOW tables;