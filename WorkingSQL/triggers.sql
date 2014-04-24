/*
QUESTION 2: Automatically update a gameÕs average rating whenever a user adds 
or updates their rating for that game 
*/

DELIMITER $$
CREATE TRIGGER Game_after_insert AFTER INSERT ON Game
FOR EACH ROW
BEGIN 
	INSERT INTO Leaderboard (GameID, IsDefault)
	VALUES ((SELECT GameID FROM Game WHERE Game.GameID = NEW.GameID), 1);
END $$
DELIMITER ;

/* Trigger to change average on INSERT */
DELIMITER $$
CREATE TRIGGER AvgOnInsert AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	UPDATE Game
		SET NoOfRatings = (SELECT COUNT(UserRating) from UserToGame);

	IF (SELECT COUNT(UserRating) from UserToGame) >= 10 THEN BEGIN
		UPDATE Game
				SET AverageRating = (SELECT AVG(UserRating) from UserToGame 
				where UserToGame.GameID=Game.GameID
				and UserToGame.GameID=NEW.GameID)
			WHERE Game.GameID=NEW.GameID;
		END; END IF;
			
END $$
DELIMITER ; 

/* Trigger to change average on UPDATE */
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


