/*
QUESTION 2: Automatically update a game’s average rating whenever a user adds 
or updates their rating for that game 
*/

/* Trigger to change average on INSERT */
CREATE TRIGGER AvgOnInsert AFTER 
INSERT ON UserToGame
FOR EACH ROW 
	UPDATE Game
		SET AverageRating = (SELECT AVG(UserRating) from UserToGame 
		where UserToGame.GameID=Game.GameID
		and UserToGame.GameID=NEW.GameID)
	WHERE Game.GameID=NEW.GameID;

/* Trigger to change average on UPDATE */
CREATE TRIGGER AvgOnUpdate AFTER 
UPDATE ON UserToGame
FOR EACH ROW 
	UPDATE Game
		SET AverageRating = (SELECT AVG(UserRating) from UserToGame 
		where UserToGame.GameID=Game.GameID
		and UserToGame.GameID=NEW.GameID)
	WHERE Game.GameID=NEW.GameID;
