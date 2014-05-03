
/* PROCEDURES, FUNCTIONS & TRIGGERS */

/*
Listed first are the relevant procedures and functions for the specified coursework
questions. Where appropriate triggers to activate them are listed afterward.

All questions have been separated out into their own .sql files for clarity.
*/

/* 
QUESTION 1: 

Given a game, list all the users who own that game 

Example query - looks up game with GameID 4:
CALL Question1(4);

Author: Alex Parrott
*/
DROP PROCEDURE IF EXISTS Question1;
DELIMITER $$
CREATE PROCEDURE Question1(IN gameVar INT)
BEGIN
	SELECT UserPublic.UserName 
	FROM Game,UserPublic,UserToGame
	WHERE UserPublic.UserName=UserToGame.UserName 
	AND Game.GameID=UserToGame.GameID 
	AND Game.GameID=gameVar;

END $$
DELIMITER ;

/* 
QUESTION 2 & QUESTION 3:

When a game recieves a user rating this procedure updates its average average 
rating.

This procedure is called by triggers:
- After any UPDATE or INSERT to the UserToGame relation (which holds the UserRating
attribute).

Author: Alex Parrott
*/
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

/*
QUESTION 4:

Given a game and user this procedure displays the user's score, rank on the 
game's leaderboard and their relative position to the average score. 
See question4.sql for an example query.

Author: Will Woodhead
*/
DROP PROCEDURE IF EXISTS Question4;
DELIMITER $$
CREATE PROCEDURE Question4(User VARCHAR(30), GID INT)
BEGIN 
	SET @rank=0;
	/* @count is the number of users who have registered a score in a particular game */
	SET @count = (
		SELECT COUNT(*) 
		FROM Scores 
		WHERE UserToGameID IN (
			SELECT ID 
			FROM UserToGame 
			WHERE GameID = GID)
	); 

	/* Check whether the scores are ascending or descending */
	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') 
	THEN
		SELECT r AS rank, topXP AS top_x_percent, scor AS BestScore FROM (
			SELECT @rank:=@rank+1 AS r, (@rank/@count)*100 AS topXP ,UserToGameID,Score AS scor  
			FROM Scores 
			WHERE UserToGameID IN (
				SELECT ID 
				FROM UserToGame 
				WHERE GameID = GID)
			ORDER BY Score ASC
		) AS temp WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE Username = User AND GameID = GID )
		ORDER BY BestScore ASC LIMIT 1;
	ELSE 
		SELECT r AS rank, topXP AS top_x_percent, scor AS BestScore FROM (
			SELECT @rank:=@rank+1 AS r,(@rank/@count)*100 AS topXP, UserToGameID, Score AS scor
			FROM Scores 
			WHERE UserToGameID IN (
				SELECT ID 
				FROM UserToGame 
				WHERE GameID = GID)
			ORDER BY Score DESC
		) AS temp WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE Username = User AND GameID = GID  ) 
		ORDER BY BestScore DESC LIMIT 1;
	END IF;
END; $$
DELIMITER ;

/* 
QUESTION 5:

This procedure creates a list of the top 10 rated games in each genre/category.
See question5.sql for example query.

Author: Will Woodhead
*/
DROP PROCEDURE if exists Question5;
DELIMITER $$
CREATE PROCEDURE Question5()
BEGIN 
	SET @row:=0;
	SET @prev:=null;
	SELECT genre,name,AverageRating
	FROM (
		SELECT Genre.Name AS genre,
	  	Game.Name AS name,
	  	AverageRating,
	  	@row:= IF(@prev = Genre.Name, @row + 1, 1) AS row_number,       
	  	@prev:= Genre.Name
	  	FROM Game, Genre, GameToGenre 
		WHERE Game.GameID = GameToGenre.GameID 
		AND Genre.GenreID = GameToGenre.GenreID
	  	ORDER BY Genre.Name, AverageRating DESC) 
	AS src
	WHERE row_number <= 10
	ORDER BY genre, AverageRating DESC;
END; $$
DELIMITER ;

/* 
QUESTION 6:

This function is designed to catch cheaters. An optional max and min score value
is stored in the Game relation. If a user's score is outside of these values
the score is reset to the min score value.

This function is called by a triggers: 
- Before any UPDATE or INSERT on the UserToGame relation (which holds the LastScore attribute) 

Author: Alex Parrott
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

/*  
QUESTION 7:

Procedure adds daily and weekly leaderboards for each game showing the best scores
acheived.

See question7.sql for an example query.

Author: Will Woodhead

*/
DROP PROCEDURE IF EXISTS DayAndWeekLeaders;
DELIMITER $$
CREATE PROCEDURE DayAndWeekLeaders()
BEGIN 

	SET @gameCount = (SELECT COUNT(GameID) FROM Game);
	SET @index = 1;

	WHILE( @index <= @gameCount) 
	DO
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			@index, 
			(SELECT SortOrder FROM Game WHERE GameID = @index),'1_week'
		);
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			@index, 
			(SELECT SortOrder FROM Game WHERE GameID = @index),'1_day'
		);
		SET @index = @index + 1;
	END WHILE ;

END; $$
DELIMITER ;

/* JAMES THIS PROCEDURE DOES NOT WORK AT PRESENT 
linked trigger below has also been commented out for this reason
*/

/*
QUESTION 8:

Function compares the username against all rows in the RudeWord table.
A return of true indicates an illegal username, and false if it's acceptable.

This function is called by a trigger:
- Before INSERT on UserPublic (which holds user names)

See question8.sql for an exmple query.

Author: James Hamblion
*/
/*
DROP FUNCTION IF EXISTS isUserNameRude;
CREATE FUNCTION isUserNameRude(usrname VARCHAR(50))
RETURNS INT
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE obscene INT DEFAULT FALSE;
	DECLARE cmpWord VARCHAR(50);
	DECLARE cur CURSOR FOR SELECT word FROM RudeWord;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN cur;
	compare_loop: LOOP
		FETCH cur INTO cmpWord;
		-- Build search text 
		SET @searchtxt ='%';
		SET @searchtxt = @searchtxt + cmpWord;
		SET @SearchText = @SearchText + '%';
		-- Handler check  
	    IF done THEN
			LEAVE compare_loop;
	    END IF;
		-- Word comparison check (Note STRCMP case insensitive by default) 
		SET obscene = STRCMP(@usrname, @searchtxt);
		IF obscene 
		THEN
			SET done := TRUE;
		END IF;
	END LOOP;
	CLOSE cur;
	RETURN obscene;
END;
*/

/*
QUESTION 9:

Procedure creates a 'Hot List' showing 10 games which have been played most
often in the last week.

See question9.sql for an example query.

Author: Will Woodhead

*/
DROP PROCEDURE IF EXISTS Hotlist;
DELIMITER $$
CREATE PROCEDURE Hotlist()
BEGIN 
	CREATE TABLE Hotlist (
		Ranking INT NOT NULL AUTO_INCREMENT, 
		GameID INT NOT NULL, 
		NOPLastWeek INT,
		CONSTRAINT pkID PRIMARY KEY(ranking)
	);

	INSERT INTO HotList (GameID, NOPLastWeek)
	SELECT GameID, COUNT(GameID) AS count
	FROM Plays 
	WHERE Plays.TimeOfPlay > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY GameID 
	ORDER BY count DESC;

	SELECT Ranking,Name, NOPLastWeek 
	FROM Hotlist, Game 
	WHERE Hotlist.GameID = Game.GameID ORDER BY NOPLastWeek DESC limit 10;
	DROP TABLE Hotlist;
END; $$
DELIMITER ;

/*
QUESTION 10:

The following procedures can be used to create Friendships via a friendship
request. A friend request can be made by calling the RequestFriendName procedure
providing the UserNames of the requesterand the requested friend:

CALL RequestFriendName('AlexParrott,'WillWoodhead');

Alternatively the requested friend's email can be used by calling the RequestFriendEmail
procedure:

CALL RequestFriendEmail('AlexParrott','Will@Woodhead.com');

To accept a friendship the AcceptFriendship procedure must be called providing
the unique ResquestID, this automatically creates the friendship in the Friends
relation:

CALL AcceptFriendship(4);

Friend requests can be declined and friendships can be deleted by calling the
DenyFriendship procedure (again providing a unique ResquestID):

CALL DenyFriendship(7);

Author: Alex Parrott
*/

/* Procedure creates a Friendship Request via UserName */
DROP PROCEDURE IF EXISTS RequestFriendName;
DELIMITER $$
CREATE PROCEDURE RequestFriendName(IN User VARCHAR(20),reqFriend VARCHAR(20))
BEGIN
	INSERT INTO FriendRequest(Requester,Requestee)
	VALUES(User,reqFriend);
END; $$
DELIMITER ;

/* Alternative procedure creates a Friendship Request via Email address */
DROP PROCEDURE IF EXISTS RequestFriendEmail;
DELIMITER $$
CREATE PROCEDURE RequestFriendEmail(IN User VARCHAR(20),reqEmail VARCHAR(30))
BEGIN
	INSERT INTO FriendRequest(Requester,Email)
	VALUES(User,reqEmail);
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS AcceptFriendship;
DELIMITER $$
CREATE PROCEDURE AcceptFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(30);

	/* Assign UserNames to friends */
	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID);
	/* If Email is used for request then get the UserName */
	IF Friend2 IS NULL
	THEN
		SET Friend2 = (
			SELECT UserName
			FROM UserPrivate
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	/* Update the friend request to Accepted */
	UPDATE FriendRequest
	SET FriendResponse = 'Accepted'
	WHERE RequestID = reqID;
 
	/* Create this friendship in the Friends table */
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend1,Friend2);
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend2,Friend1);
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS DenyFriendship;
DELIMITER $$
CREATE PROCEDURE DenyFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(30);

	/* Assign UserNames to friends */
	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID
	);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID
	);
	/* If Email is used for request then get the UserName */
	IF Friend2 IS NULL
	THEN
		SET Friend2 = (
			SELECT UserName
			FROM UserPrivate
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	/* Update the friend request to Denied */
	UPDATE FriendRequest
	SET FriendResponse = 'Denied'
	WHERE RequestID = reqID;

	/* Delete this friendship from the Friends table */
	DELETE FROM Friends 
	WHERE AccHolder = Friend1
	AND Friend = Friend2;
	DELETE FROM Friends
	WHERE AccHolder = Friend2
	AND Friend = Friend1;
END; $$
DELIMITER ;

/*
QUESTION 11:

When given a user and a game this procedure shows a leaderboard which lists 
just the user and their friends. 

See question11.sql for an example query.

Author: Will Woodhead
*/
DROP PROCEDURE IF EXISTS GetFriendsLeaderboard;
DELIMITER $$
CREATE PROCEDURE GetFriendsLeaderboard(UserN VARCHAR(30), GID INT)
BEGIN 

	SET @ScoreFormat = (SELECT ScoreFormat FROM Game WHERE GameID = GID);
	
	DROP TABLE IF EXISTS temp;
	CREATE TABLE temp (
		Username VARCHAR(30), 
		Score INT , 
		TimeOfScore TIMESTAMP
	);

	INSERT INTO temp 
	SELECT Username, Score, TimeOfScore 
	FROM Scores, UserToGame 
	WHERE Scores.UserToGameID = UserToGame.ID 
	AND UserToGame.GameID = GID
	AND Scores.UserToGameID IN (
		SELECT ID 
		FROM UserToGame 
		WHERE UserName IN (
			SELECT Friend 
			FROM Friends
			AS friendtemp 
			WHERE AccHolder = UserN)
		); 

	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') 
	THEN
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS units
		FROM temp 
		ORDER BY Score ASC;
	ELSE
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS units
		FROM temp 
		ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;
END; $$
DELIMITER ;

/*
QUESTION 12:

When given a UserName (passed as a parameter), this procedure lists all the User's
online friends. All offline friends are also listed with their last login time 
and the name of the last game they played.

An exmaple query (lists all of AlexParrott's friends): 
CALL ShowFriends('AlexParrott');

Author: Alex Parrott

*/
DROP PROCEDURE IF EXISTS ShowFriends;
DELIMITER $$
CREATE PROCEDURE ShowFriends(IN User VARCHAR(20))
BEGIN
	/* Create a table of all specified user's friends */
	CREATE TABLE AllFriends(
		SELECT Friend 
		FROM Friends
		WHERE AccHolder = User
	);
	/* Create a table of last games played by each friend */
	/* (1) Get the date of the last play */
	CREATE TABLE LastDate(	
		SELECT UserName,MAX(LastPlayDate) AS LastPlay 
		FROM UserToGame
		GROUP BY UserName
		ORDER BY LastPlayDate DESC
	);
	/* (2) Get the unique ID and name of the game played on this date */
	CREATE TABLE LastGame(
		SELECT UserToGame.UserName,Game.GameID,Name
		FROM UserToGame
		JOIN LastDate ON LastDate.UserName = UserToGame.UserName
		JOIN Game ON UserToGame.GameID = Game.GameID
		WHERE LastPlay = LastPlayDate
	);

	/* Display list of all online friends */
	SELECT UserName,AccountStatus 
	FROM UserPublic,AllFriends
	WHERE UserPublic.UserName = AllFriends.Friend
	AND AccountStatus = 'Online';

	/* Display list of offline friends with last login and last game played */
	SELECT UserPublic.UserName,AccountStatus,LastLogin,Name AS LastPlayed
	FROM UserPublic,AllFriends,LastGame
	WHERE UserPublic.UserName = AllFriends.Friend
	AND UserPublic.UserName = LastGame.UserName
	AND AccountStatus = 'Offline';

	DROP TABLE AllFriends;
	DROP TABLE LastGame;
	DROP TABLE LastDate;

END; $$
DELIMITER ;

/*
QUESTION 13:

PROCEDURE to show achievement status for a user in a specific game. 
-Output examples: 
-16 of 80 achievements (95 points)
-0 of 1 achievements (0 points)
-If game not owned by user: 'Error: game not owned by user!'

See question13.sql for test examples and example queries.

Author: James Hamblion

*/
DROP PROCEDURE IF EXISTS AchievementsForUserGame;
DELIMITER $$
CREATE PROCEDURE AchievementsForUserGame(usrname VARCHAR(50),gameident INT)
BEGIN
	DECLARE totalAchiev INT;
	DECLARE userGameid INT;
	DECLARE earntAchiev INT;
	DECLARE pointVal INT;

	/* Get userToGameID for the game and username. If user doesn't own game variable is null. */
	SET userGameid = (
		SELECT ID 
		FROM UserToGame utg
		WHERE utg.UserName = usrname 
		AND utg.gameid = gameident
	);
	/* Check userGameid not null and continue, else return message 'Error: game not owned by user!' */
	IF (userGameid IS NOT NULL) 
	THEN
		/* Get total achievement number for game */
		SET totalAchiev = (
			SELECT COUNT(achievementID) 
			FROM Achievement a
			WHERE a.gameid = gameident
		);
		/* Get earnt achievements for the user in the specified game */
		SET earntAchiev = (
			SELECT COUNT(achievementID) 
			FROM AchievementToUserToGame a
			WHERE a.userToGameID = userGameid
		);
		IF (earntAchiev IS NULL) 
		THEN 
			SET earntAchiev = 0; 
		END IF; /* prevents null output */
		/* Get point value of earnt achievements for the user in the specified game */
		SET pointVal = (
			SELECT SUM(PointValue) 
			FROM Achievement a, AchievementToUserToGame b
			WHERE b.userToGameid = userGameid 
			AND a.achievementID = b.achievementID
			AND a.gameid = gameident
		);
		IF (pointVal IS NULL) 
		THEN 
			SET pointVal = 0; 
		END IF; /*prevents null output*/
		SELECT CONCAT(earntAchiev,' of ',totalAchiev,' achievements ','(',pointVal,' points', ')');
	ELSE
		SELECT 'Error: game not owned by user!';
	END IF;
END; $$
DELIMITER ;

/*
QUESTION 14:

PROCEDURE to show a users status screen 

See question14.sql for example queries and tests.

Author: James Hamblion
*/
DROP PROCEDURE IF EXISTS ShowStatusScreen;
DELIMITER $$
CREATE PROCEDURE ShowStatusScreen(usrname VARCHAR(50))
BEGIN
	/* User not found handler (skips query code if no usrname exists in database) */
	IF (
		(SELECT COUNT(UserName) 
		FROM UserPublic u 
		WHERE u.UserName = usrname) 
		IS NOT NULL) 
	THEN
		/* User status line */
		SET @status = (
			SELECT UserStatus 
			FROM UserPublic u
			WHERE u.UserName = usrname
		);
		/* Number of games owned by user */
		SET @numGames = (
			SELECT COUNT(userName) 
			FROM UserToGame u
			WHERE u.UserName = usrname
		);
		IF (@numGames IS NULL) 
		THEN 
			SET @numGames = 0; 
		END IF; /* prevents null output */
		/* Total achievement points for user */
		SET @numPoints = (
			SELECT SUM(PointValue) 
			FROM Achievement a,AchievementToUserToGame b
			WHERE b.userToGameid IN (
				SELECT ID 
				FROM UserToGame u 
				WHERE u.UserName = usrname)
			AND a.achievementID = b.achievementID
		);
		IF (@numPoints IS NULL) 
		THEN 
			SET @numPoints = 0; 
		END IF; /* prevents null output */
		/* Cumber of friends of user (TBC) */
		SET @numFriends = 4;
		/*
		SET @numFriends = (
			SELECT COUNT(Friend) FROM 
			WHERE 
			);
		*/
		IF (@numFriends IS NULL) 
		THEN 
			SET @numFriends = 0; 
		END IF; /* prevents null output */
		
		/* 
		Create status screen table, insert values, print and then drop 
		the the Status_Screen table 
		*/
		CREATE TABLE Status_Screen (
			Username VARCHAR(20), 
			Status_Line VARCHAR(100), 
			Number_of_Games_Owned INT, 
			Total_Number_of_Achievement_Points INT, 
			Number_of_Friends INT
		);
		INSERT INTO Status_Screen
		VALUES (usrname,@status,@numGames,@numPoints,@numFriends);
		SELECT * FROM Status_Screen;
		DROP TABLE Status_Screen;
	END IF;
END; $$
DELIMITER ;

/* 
QUESTION 15:

PROCEDURE shows achievements for a game that a user has earnt, and those that they have not
(providing they are not hidden i.e. hiddenFlag = FALSE).

See question15.sql for example query and testing.

Author: James Hamblion
*/
DROP PROCEDURE IF EXISTS ListUserGameAchievements;
DELIMITER $$
CREATE PROCEDURE ListUserGameAchievements(usrname VARCHAR(50),gameident INT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
	/* All var needed to fetch row fields */
	DECLARE achID INT;
	DECLARE gmid INT;
	DECLARE ttl VARCHAR(50);
	DECLARE hidFlag BIT;
	DECLARE icn INT;
	DECLARE pointVal INT;
	DECLARE poDes VARCHAR(200);
	DECLARE preDes VARCHAR(200);
	DECLARE a INT;
	DECLARE u INT;
	DECLARE dgain DATE;
	/* Var to determine post or pre description */
	DECLARE descrpt VARCHAR(200);
	/*The query to give everything needed: */
	DECLARE cur CURSOR FOR 
		SELECT * FROM 
			(SELECT * 
			FROM Achievement x 
			WHERE x.gameid = 3) a 
			LEFT OUTER JOIN
			(SELECT * 
			FROM AchievementToUserToGame y 
			 WHERE y.userToGameid IN 
				(SELECT ID 
				FROM UserToGame u 
				WHERE u.UserName = usrname 
				AND u.gameID = gameident)) b
			ON a.achievementID = b.achievementID
		WHERE (b.dateGained IS NULL 
		AND a.hiddenFlag = FALSE) 
		OR(a.hiddenFlag = FALSE) 
		OR(b.dateGained IS NOT NULL AND a.hiddenFlag = TRUE)
		ORDER BY b.dateGained DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	/* Create result table */
	CREATE TABLE GameAchievementList (
		Title VARCHAR(50),
		PointValue INT,
		Description VARCHAR(200),
		DateGained DATE
	);
	
	/* Populate the table by looping row by row using a cursor. */
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO achID, gmid, ttl, hidFlag, icn, pointVal, poDes, preDes, a, u, dgain;
	    	IF done 
		THEN
			LEAVE pop_loop; /* If user doesn't exist or game not owned procedure ends/does nothing. */
	   	END IF;
	   	/* Check description to use. Earnt achievement = postDescription */
	   	IF (dgain IS NULL) 
		THEN 
			SET descrpt = preDes; 
	   	ELSE 
			SET descrpt = poDes;
	   	END IF;
		
		INSERT INTO GameAchievementList
		VALUES (ttl, pointVal, descrpt, dgain);
	END LOOP;
	CLOSE cur;
	
	/* Display results and then drop the table as no longer needed. */
	SELECT * FROM GameAchievementList;
	DROP TABLE GameAchievementList;
END; $$
DELIMITER ;

/*
QUESTION 17:

See question17.sql for example query.

Author: Will Woodhead

*/
DROP PROCEDURE IF EXISTS GetLeaderboard;
DELIMITER $$
CREATE PROCEDURE GetLeaderboard(LBID INT)
BEGIN 

	SET @ScoreFormat = (
		SELECT ScoreFormat 
		FROM Game 
		WHERE GameID = (
			SELECT GameID 
			FROM Leaderboard 
			WHERE LeaderboardID = LBID)
	);
	SET @GID = (
		SELECT GameID 
		FROM Leaderboard 
		WHERE LeaderboardID = LBID
	);

	DROP TABLE if exists temp;
	CREATE TABLE temp (
		Username VARCHAR(30), 
		Score INT, 
		TimeOfScore TIMESTAMP
	); 

	IF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_year') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 365 DAY)
		);
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_week') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY)
		);
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_day') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND  TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)
		);
	ELSE
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID; 
	END IF;

	IF ((SELECT SortOrder FROM Leaderboard WHERE LeaderboardID=LBID) = 'asc') 
	THEN
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS Units, TimeOfScore 
		FROM temp 
		ORDER BY Score ASC;
	ELSE
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS Units, TimeOfScore 
		FROM temp 
		ORDER BY Score DESC;
	END IF;

	DROP TABLE temp;
END; $$
DELIMITER ;

/*
UserPublic triggers
*/

/* JAMES THIS TRIGGER DOES NOT WORK AT PRESENT linked to inoperative q8 procedure */
/*
DROP TRIGGER IF EXISTS userNameEntryCheck;
CREATE TRIGGER userNameEntryCheck
BEFORE INSERT ON UserPublic
FOR EACH ROW
BEGIN
	SET @usrname = NEW.userName;
	SET @obscene = isUserNameRude(@usrname);
	IF @obscene THEN
		SET NEW.AccountStatus := 'Locked';
	END IF;
END;
*/

/* TRIGGERS */

/* Triggers for Game relation  */
DELIMITER $$
CREATE TRIGGER Game_after_insert 
AFTER INSERT ON Game
FOR EACH ROW
BEGIN 
	/* Create a default leaderboard at the creation of any new game */
	INSERT INTO Leaderboard (GameID, IsDefault, SortOrder)
	VALUES (
		(SELECT GameID 
		FROM Game 
		WHERE Game.GameID = NEW.GameID), 1, (
			SELECT SortOrder 
			FROM Game 
			WHERE Game.GameID = NEW.GameID)
	);
END $$
DELIMITER ;

/* TRIGGERS FOR UserToGame RELATION */

/* BEFORE INSERT on UserToGame */
DROP TRIGGER IF EXISTS BeforeInsertUserToGame;
DELIMITER $$
CREATE TRIGGER BeforeInsertUserToGame 
BEFORE INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	/* QUESTION 6 */
	SET NEW.LastScore = (
		SELECT CatchCheaters(NEW.GameID, NEW.LastScore));
END $$
DELIMITER ;

/* BEFORE UPDATE on UserToGame */
DROP TRIGGER IF EXISTS BeforeUpdateUserToGame;
DELIMITER $$
CREATE TRIGGER BeforeUpdateUserToGame 
BEFORE UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	/* QUESTION 6 */
	SET NEW.LastScore = (
		SELECT CatchCheaters(NEW.GameID, NEW.LastScore));

END $$
DELIMITER ;

/* AFTER INSERT on UserToGame */
DELIMITER $$
CREATE TRIGGER AfterInsertUserToGame 
AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	/* QUESTION 2 & QUESTION 3 */
	CALL UpdateAverage(NEW.GameID);
END $$
DELIMITER ;

/* AFTER UPDATE on UserToGame */
DELIMITER $$
CREATE TRIGGER AfterUpdateUserToGame 
AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	/* QUESTION 2 & QUESTION 3 */
	CALL UpdateAverage(NEW.GameID);	
	
	/* QUESTION 9: When a user starts playing a game, this 'play' is logged in the PLays table
	This plays table is queried to find out the Hotlist */
	IF NEW.GameInProgress = 'yes' 
	AND OLD.GameInProgress = 'no' 
	THEN BEGIN
		INSERT INTO Plays (GameID,UserName,TimeOfPlay)
		VALUES (
			(SELECT GameID 
			FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			(SELECT UserName 
			FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			NOW()
		);
		END; 
	END IF;

	/* QUESTION 7: When a user gets a new score in any game, it is recorded in the lastScore attribute in UserToGame table
	This score is also logged in LeaderboardToUserToGame. THis table holds the record of every score on every game
	at a certain time. This table can therefore be used to create all of the leaderboards for any game.*/
	IF NEW.LastScore != OLD.LastScore 
	THEN BEGIN 
		INSERT INTO Scores (UserToGameID, Score, TimeOfScore)
		VALUES(
			(SELECT ID 
			FROM UserToGame 
			WHERE UserToGame.ID = NEW.ID),
			(SELECT LastScore 
			FROM UserToGame 
			WHERE UserToGame.ID = NEW.ID),
			NOW()
		);
		END; 
	END IF;
END $$
DELIMITER ;

/* AFTER DELETE on UserToGame */
DELIMITER $$
CREATE TRIGGER AfterDeleteUserToGame 
AFTER DELETE ON UserToGame
FOR EACH ROW 
BEGIN
	/* QUESTION 2 & QUESTION 3 */ 
	CALL UpdateAverage(OLD.GameID);

	/* QUESTION 3: If number of ratings drops below 10, set average to NULL */
	IF (SELECT NoOfRatings FROM Game WHERE GameID = OLD.GameID) < 10 
	THEN BEGIN
		UPDATE Game
			SET AverageRating = NULL
			WHERE Game.GameID = OLD.GameID;
	END; END IF;
END $$
DELIMITER ; 

/* TRIGGERS FOR MatchRequest RELATION */

/* AFTER UPDATE on MatchRequest */
DELIMITER $$
CREATE TRIGGER matchRequest_after_update 
AFTER UPDATE ON MatchRequest
FOR EACH ROW
BEGIN 
	/* if response is accepted, then the usertogame is added to the match*/
	IF NEW.Response = 'Accepted' 
	THEN BEGIN 
		INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
		VALUES(NEW.MatchID, NEW.ReceivingUTG);
		UPDATE Matches 
		SET NoOfPlayer = (SELECT NoOfPlayer FROM Matches WHERE MatchID = NEW.MatchID) + 1
		WHERE MatchID = New.MatchID;
	END; END IF;

END $$
DELIMITER ;

