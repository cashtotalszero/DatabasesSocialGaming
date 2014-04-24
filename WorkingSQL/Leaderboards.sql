CREATE TABLE Leaderboard(
	LeaderboardID INT NOT NULL AUTO_INCREMENT,
	GameID INT NOT NULL,
	SortOrder ENUM('asc','desc') NOT NULL DEFAULT 'desc',
	CONSTRAINT pkLdbdID
		PRIMARY KEY (LeaderboardID),
	CONSTRAINT fk_ldbd_GameID
		FOREIGN KEY(GameID)
		REFERENCES Game(GameID)
);


CREATE TABLE LeaderboardToUserToGame(
	LeaderboardID INT NOT NULL,
	UserToGameID INT NOT NULL,
	Score INT NOT NULL,
	TimeOfScore TIMESTAMP NOT NULL,
	CONSTRAINT pk_LTUTG
		PRIMARY KEY (TimeOfScore, UserToGameID),
	CONSTRAINT fk_UTG
		FOREIGN KEY (UserToGameID)
		REFERENCES UserToGame(ID),
	CONSTRAINT fk_Leaderboard
		FOREIGN KEY (LeaderboardID)
		REFERENCES Leaderboard(LeaderboardID)
);



/* Trigger to after update on usertogame when LastScore is update to add row to LeaderboardToUSerToGame table */
DELIMITER $$
CREATE TRIGGER AvgOnUpdate AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	UPDATE Game
		SET AverageRating = (SELECT AVG(UserRating) from UserToGame 
		where UserToGame.GameID=Game.GameID
		and UserToGame.GameID=NEW.GameID)
	WHERE Game.GameID=NEW.GameID;

	IF NEW.GameInProgress = 'yes' AND OLD.GameInProgress = 'no' THEN BEGIN
		INSERT INTO Plays (GameID, UserName, TimeOfPlay)
		Values (
			(SELECT GameID FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			(SELECT UserName FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			NOW());
	END; END IF;

	IF NEW.LastScore != OLD.LastScore THEN BEGIN 
		INSERT INTO LeaderboardToUserToGame (LeaderboardID, UserToGameID, Score, TimeOfScore)
		VALUES(
			(SELECT LeaderboardID FROM Leaderboard WHERE Leaderboard.GameID = NEW.GameID),
			(SELECT ID FROM UserToGame WHERE UserToGame.ID = NEW.ID),
			(SELECT LastScore FROM UserToGame WHERE UserToGame.ID = NEW.ID),
			NOW()
		);
	END; END IF;

END $$
DELIMITER ;