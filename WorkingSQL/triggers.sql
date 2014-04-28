
/* Triggers AFTER INSERT Game */
DELIMITER $$
CREATE TRIGGER Game_after_insert AFTER INSERT ON Game
FOR EACH ROW
BEGIN 
	INSERT INTO Leaderboard (GameID, IsDefault)
	VALUES ((SELECT GameID FROM Game WHERE Game.GameID = NEW.GameID), 1);
END $$
DELIMITER ;

/* Triggers AFTER INSERT to UserToGame */
DELIMITER $$
CREATE TRIGGER AvgOnInsert AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	/* AP: Updates AverageRating if there are 10+ ratings (q2 & q3) */ 
	UPDATE Game
		/* AP: Set new rating count for new rated Game */
		SET NoOfRatings = (
			SELECT COUNT(UserRating) 
			FROM UserToGame
			WHERE UserToGame.GameID = Game.GameID
			AND UserToGame.GameID = NEW.GameID)
		WHERE Game.GameID = NEW.GameID;

		/* AP: If new rating count is over 10, update the average */
		IF (SELECT NoOfRatings FROM Game WHERE GameID = NEW.GameID) >= 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = (
					SELECT AVG(UserRating) 
					FROM UserToGame 
					WHERE UserToGame.GameID = Game.GameID
					AND UserToGame.GameID = NEW.GameID)
				WHERE Game.GameID = NEW.GameID;
		END; END IF;
END $$
DELIMITER ; 


/* Triggers AFTER UPDATE on UserToGame */
DELIMITER $$
CREATE TRIGGER AvgOnUpdate AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	/* AP: Updates AverageRating if there are 10+ ratings (q2 & q3) */ 
	UPDATE Game
		/* AP: Set new rating count for new rated Game */
		SET NoOfRatings = (
			SELECT COUNT(UserRating) 
			FROM UserToGame
			WHERE UserToGame.GameID = Game.GameID
			AND UserToGame.GameID = NEW.GameID)
		WHERE Game.GameID = NEW.GameID;

		/* AP: If new rating count is over 10, update the average */
		IF (SELECT NoOfRatings FROM Game WHERE GameID=NEW.GameID) >= 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = (
					SELECT AVG(UserRating) 
					FROM UserToGame 
					WHERE UserToGame.GameID = Game.GameID
					AND UserToGame.GameID = NEW.GameID)
				WHERE Game.GameID = NEW.GameID;
		END;END IF;

		/* WW */
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
	

/* Triggers AFTER DELETE on UserToGame */
DELIMITER $$
CREATE TRIGGER AvgOnDelete AFTER DELETE ON UserToGame
FOR EACH ROW 
BEGIN
	/* AP: Updates AverageRating if there are 10+ ratings (q2 & q3) */ 
	UPDATE Game
		/* AP: Set new rating count for new rated Game */
		SET NoOfRatings = (
			SELECT COUNT(UserRating) 
			FROM UserToGame
			WHERE UserToGame.GameID = Game.GameID
			AND UserToGame.GameID = OLD.GameID)
		WHERE Game.GameID = OLD.GameID;

		/* AP : If new rating count is over 10, update the average */
		IF (SELECT NoOfRatings FROM Game WHERE GameID = OLD.GameID) >= 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = (
					SELECT AVG(UserRating) 
					FROM UserToGame 
					WHERE UserToGame.GameID = Game.GameID
					AND UserToGame.GameID = OLD.GameID)
				WHERE Game.GameID = OLD.GameID;
		END; END IF;

		/* AP : If number of ratings drops below 10, set average to NULL */
		IF (SELECT NoOfRatings FROM Game WHERE GameID=OLD.GameID) < 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = NULL
				WHERE Game.GameID = OLD.GameID;
		END; END IF;
END $$
DELIMITER ; 
