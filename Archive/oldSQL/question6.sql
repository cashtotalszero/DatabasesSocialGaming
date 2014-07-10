/* QUESTION 6 */

/*
Please note that this function and triggers have been incorporated into the 
triggers.sql file and have been separated her for explanation purposes only.
*/

DROP FUNCTION IF EXISTS CatchCheaters;
DELIMITER $$
CREATE FUNCTION CatchCheaters(game INT,score INT)
RETURNS INT
BEGIN
	DECLARE checkedScore INT;
	DECLARE minimum INT;
	DECLARE maximum INT;

	/* Initialise the score to return */
	SELECT score
	INTO checkedScore;
	
	/* Get max and min scores for the Game being updated */	
	SELECT MinScore 
	INTO minimum	
	FROM Game
	WHERE Game.GameID = game;
	
	SELECT MaxScore
	INTO maximum 
	FROM Game
	WHERE Game.GameID = game;
	
	/* 
	If the new score is < min or > max score, set it to the minimum for that Game. 
	NOTE: If no minScore is provided, it defaults to NULL. Therefore, cheaters
	will get no score! 
	*/
	IF(
		score < minimum
		OR 
		score > maximum
	) 
	THEN
		SET checkedScore = minimum;
	END IF;

	/* Return the final checked score */
	RETURN checkedScore;
END $$
DELIMITER ;

/* Triggers BEFORE INSERT to UserToGame */
DROP TRIGGER IF EXISTS BeforeInsertUserToGame;
DELIMITER $$
CREATE TRIGGER BeforeInsertUserToGame 
BEFORE INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	SET NEW.LastScore = (SELECT CatchCheaters(NEW.GameID,NEW.LastScore));
END $$
DELIMITER ;

/* Triggers BEFORE UPDATE to UserToGame */
DROP TRIGGER IF EXISTS BeforeUpdateUserToGame;
DELIMITER $$
CREATE TRIGGER BeforeUpdateUserToGame 
BEFORE UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	SET NEW.LastScore = (SELECT CatchCheaters(NEW.GameID,NEW.LastScore));
END $$
DELIMITER ;

