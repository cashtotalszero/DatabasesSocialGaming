/*Question3 -  This SQL Code is pulled out of other files to serve as a highlight of the changes made for question 3*/


/*This question is solved by the modification of triggers
Consideration has to be given to inserts, updates and deletes on usertogame.
*/

/* PROCEDURE TO UPDATE AVERAGE RATING OF GAMES (q2 & q3) */
DROP PROCEDURE IF EXISTS UpdateAverage;
DELIMITER $$
CREATE PROCEDURE UpdateAverage(IN updated INT)
BEGIN
	UPDATE Game
		/* Set new rating count for new rated Game */
		SET NoOfRatings = (
			SELECT COUNT(UserRating) 
			FROM UserToGame
			WHERE UserToGame.GameID = Game.GameID
			AND UserToGame.GameID = updated)
		WHERE Game.GameID = updated;

		/* If new rating count is over 10, update the average */
		IF (SELECT NoOfRatings FROM Game WHERE GameID = updated) >= 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = (
					SELECT AVG(UserRating) 
					FROM UserToGame 
					WHERE UserToGame.GameID = Game.GameID
					AND UserToGame.GameID = updated)
				WHERE Game.GameID = updated;
		END; END IF;

END $$
DELIMITER ; 

/* Triggers AFTER INSERT to UserToGame */
DELIMITER $$
CREATE TRIGGER AfterInsertUserToGame 
AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(NEW.GameID);
END $$
DELIMITER ; 

/* Triggers AFTER UPDATE on UserToGame */
DELIMITER $$
CREATE TRIGGER AfterUpdateUserToGame 
AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(NEW.GameID);	
	
	/* WW  when a user starts playing a game, this 'play' is logged in the PLays table
	This plays table is queried to find out the Hotlist */
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

	/* WW when a user gets a new score in any game, it is recorded in the lastScore attribute in UserToGame table
	This score is also logged in LeaderboardToUserToGame. THis table holds the record of every score on every game
	at a certain time. This table can therefore be used to create all of the leaderboards for any game.*/
	IF NEW.LastScore != OLD.LastScore THEN BEGIN 
		INSERT INTO Scores (UserToGameID, Score, TimeOfScore)
		VALUES(
			(SELECT ID FROM UserToGame WHERE UserToGame.ID = NEW.ID),
			(SELECT LastScore FROM UserToGame WHERE UserToGame.ID = NEW.ID),
			NOW()
		);
	END; END IF;
END $$
DELIMITER ; 
	
/* Triggers AFTER DELETE on UserToGame */
DELIMITER $$
CREATE TRIGGER AfterDeleteUserToGame 
AFTER DELETE ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(OLD.GameID);

	/* AP : If number of ratings drops below 10, set average to NULL */
	IF (SELECT NoOfRatings FROM Game WHERE GameID = OLD.GameID) < 10 
	THEN BEGIN
		UPDATE Game
			SET AverageRating = NULL
			WHERE Game.GameID = OLD.GameID;
	END; END IF;
END $$
DELIMITER ; 
