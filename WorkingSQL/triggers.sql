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
DELIMITER $$
CREATE TRIGGER checkScoreInsert 
BEFORE INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	/* Get max and min scores for the updated Game */
	SET @minimum = (
		SELECT MinScore 
		FROM Game
		WHERE Game.GameID = NEW.GameID);
	SET @maximum = (
		SELECT MaxScore 
		FROM Game
		WHERE Game.GameID = NEW.GameID);
	
	/* AP: If new score is < minScore or > maxScore, set to the minScore (q6). 
	NOTE: If no minScore is provided, it defaults to NULL. Therefore, cheaters
	will get no score! */
	IF(
		NEW.LastScore < @minimum
		OR 
		NEW.LastScore > @maximum
	) 
	THEN
		SET NEW.LastScore = @minimum;
	END IF;
END $$
DELIMITER ;

/* Triggers BEFORE UPDATE to UserToGame */

DELIMITER $$
CREATE TRIGGER checkScoreUpdate 
BEFORE UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	/* NOTE: This code is identical to checkScoreInsert but triggers for UPDATES */
	SET @minimum = (
		SELECT MinScore 
		FROM Game
		WHERE Game.GameID = NEW.GameID);
	SET @maximum = (
		SELECT MaxScore 
		FROM Game
		WHERE Game.GameID = NEW.GameID);
	IF(
		NEW.LastScore < @minimum
		OR 
		NEW.LastScore > @maximum
	) 
	THEN
		SET NEW.LastScore = @minimum;
	END IF;	
END $$
DELIMITER ;

/* AFTER TRIGGERS */

/* Triggers AFTER INSERT to UserToGame */
DELIMITER $$
CREATE TRIGGER InsertUserToGame 
AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	CALL UpdateAverage(NEW.GameID);
END $$
DELIMITER ; 

/* Triggers AFTER UPDATE on UserToGame */
DELIMITER $$
CREATE TRIGGER UpdateUserToGame 
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
CREATE TRIGGER DeleteUserToGame 
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



