CREATE TABLE UserToGame(
	ID INT NOT NULL AUTO_INCREMENT,
	UserName VARCHAR(20) NOT NULL,
	GameID VARCHAR(10) NOT NULL,
	GameInProgress ENUM('Yes','No') NOT NULL DEFAULT'No',
	InMatch ENUM('Yes','No') NOT NULL DEFAULT'No',
	HighestScore INT NOT NULL DEFAULT'0',
	LastPlayDate DATE DEFAULT NULL,
	Rating ENUM('Unrated','1','2','3','4','5') NOT NULL DEFAULT'Unrated',
	Comment VARCHAR(100) NOT NULL DEFAULT'No comments',

	CONSTRAINT pkID
		PRIMARY KEY(ID),
	CONSTRAINT fk_U2G_UserName
		FOREIGN KEY(UserName)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fk_U2G_GameID
		FOREIGN KEY(GameID)
		REFERENCES Game(GameID));
	
