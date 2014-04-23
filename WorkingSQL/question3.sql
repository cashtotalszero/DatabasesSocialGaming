/*Question3 - This applies changes to Alex's triggers*/

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