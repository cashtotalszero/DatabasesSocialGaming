/* QUESTIONS 2 & 3 */

/*
Please note that this procedure and triggers have been incorporated into the 
triggers.sql file and have been separated her for explanation purposes only.
*/

/* PROCEDURE TO UPDATE AVERAGE RATING OF GAMES */
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
DROP TRIGGER IF EXISTS AvgOnInsert; 
DELIMITER $$
CREATE TRIGGER AvgOnInsert 
AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN 
	CALL UpdateAverage(NEW.GameID);
END $$
DELIMITER ; 

/* Triggers AFTER UPDATE on UserToGame */
DROP TRIGGER IF EXISTS AvgOnUpdate;
DELIMITER $$
CREATE TRIGGER AvgOnUpdate 
AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(NEW.GameID);	
END $$
DELIMITER ; 
	
/* Triggers AFTER DELETE on UserToGame */
DROP TRIGGER IF EXISTS AvgOnDelete;
DELIMITER $$
CREATE TRIGGER AvgOnDelete 
AFTER DELETE ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(OLD.GameID);

	/* If number of ratings drops below 10, reset average to NULL */
	IF (SELECT NoOfRatings FROM Game WHERE GameID = OLD.GameID) < 10 
	THEN BEGIN
		UPDATE Game
			SET AverageRating = NULL
			WHERE Game.GameID = OLD.GameID;
	END; END IF;
END $$
DELIMITER ; 
