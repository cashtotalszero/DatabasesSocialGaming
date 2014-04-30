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

/* FUNCTION TO CATCH CHEATERS (q6) */
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


/* Triggers AFTER INSERT Game */
DELIMITER $$
CREATE TRIGGER Game_after_insert 
AFTER INSERT ON Game
FOR EACH ROW
BEGIN 
	/*Create a default leaderboard at the creation of any new game */
	INSERT INTO Leaderboard (GameID, IsDefault, SortOrder)
	VALUES ((SELECT GameID FROM Game WHERE Game.GameID = NEW.GameID), 1, (SELECT SortOrder FROM Game WHERE Game.GameID = NEW.GameID));
END $$
DELIMITER ;

/* BEFORE TRIGGERS */

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
DROP TRIGGER IF EXISTS BeforeInsertUserToGame;
DELIMITER $$
CREATE TRIGGER BeforeInsertUserToGame 
BEFORE INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	SET NEW.LastScore = (SELECT CatchCheaters(NEW.GameID,NEW.LastScore));
END $$
DELIMITER ;

/* AFTER TRIGGERS */

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


/* Triggers AFTER update to match request */
DELIMITER $$
CREATE TRIGGER matchRequest_after_update 
AFTER UPDATE ON MatchRequest
FOR EACH ROW
BEGIN 
		/* if pending flag goes off, then the userto game is added to the match*/
		IF NEW.Pending = 0 THEN BEGIN 
			INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
			VALUES(NEW.MatchID, NEW.ReceivingUTG);
		END; END IF;

END $$
DELIMITER ;

/* FRIENDS TABLES */

DELIMITER $$
CREATE TRIGGER createFriendship 
AFTER UPDATE ON FriendRequest
FOR EACH ROW
BEGIN
	IF (NEW.FriendResponse = 'Accepted')
	THEN BEGIN
		INSERT INTO Friends VALUES (
			NEW.Requester,NEW.Requestee
	);
	END; END IF;
END; $$
DELIMITER ;

/* Creates matching friendships in Friends2 */
DELIMITER $$
CREATE TRIGGER createMatchingFriend 
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
	INSERT INTO Friends2 VALUES(
		NEW.Friend,NEW.AccHolder);    
END; $$
DELIMITER ;

/* Deletes matching friendships in Friends2 */
DELIMITER $$
CREATE TRIGGER deleteMatchingFriend 
AFTER DELETE ON Friends
FOR EACH ROW 
BEGIN
	DELETE FROM Friends2 
	WHERE AccHolder = OLD.Friend 
	AND Friend = OLD.AccHolder;
END $$
DELIMITER ; 


