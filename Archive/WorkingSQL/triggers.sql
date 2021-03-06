/* 
PROCEDURES, FUNCTIONS & TRIGGERS

Included are the relevant procedures and functions for the specified coursework
questions. Where appropriate triggers to activate them are listed afterward.

Examples of all procedure and function calls and full explanations of their 
purpose are provided in the client report.
*/

/* 
QUESTION 1: 

Given a game, list all the users who own that game 

Author: Alex Parrott
*/
DROP PROCEDURE IF EXISTS ListGameOwners;
DELIMITER $$
CREATE PROCEDURE ListGameOwners(IN gameVar INT)
BEGIN
	/* Looks up the Game with the ID provided as parameter */
	SELECT UserPublic.UserName AS Owners 
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

Author: Will Woodhead
*/
DROP PROCEDURE IF EXISTS RankLeaderboards;
DELIMITER $$
CREATE PROCEDURE RankLeaderboards(User VARCHAR(30), GID INT)
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
		) AS temp WHERE UserToGameID = (
				SELECT ID 
				FROM UserToGame 
				WHERE Username = User 
				AND GameID = GID )
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
		) AS temp WHERE UserToGameID = (
				SELECT ID 
				FROM UserToGame 
				WHERE Username = User 
				AND GameID = GID  ) 
		ORDER BY BestScore DESC LIMIT 1;
	END IF;
END; $$
DELIMITER ;

/* 
QUESTION 5:

This procedure creates a list of the top 10 rated games in each genre/category.

Author: Will Woodhead
*/
DROP PROCEDURE if exists TopTens;
DELIMITER $$
CREATE PROCEDURE TopTens()
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

SEE Game_after_insert TRIGGER below.

Author: Will Woodhead
*/

/*
QUESTION 8:

Function compares the username against all rows in the RudeWord table.
A return of true indicates an illegal username, and false if it's acceptable.

This function is called by a trigger:
- Before INSERT on UserPublic (which holds user names)

Author: James Hamblion
*/
DROP FUNCTION IF EXISTS isUserNameRude;
DELIMITER $$
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
		/* Build search text */
		SET @searchtxt ='%';
		SET @searchtxt = @searchtxt + cmpWord;
		SET @SearchText = @SearchText + '%';
		/* Handler check */
	    IF done THEN
			LEAVE compare_loop;
	    END IF;
		/* Word comparison check (Note STRCMP case insensitive by default) */ 
		SET obscene = STRCMP(@usrname, @searchtxt);
		IF obscene 
		THEN
			SET done := TRUE;
		END IF;
	END LOOP;
	CLOSE cur;
	RETURN obscene;
END; $$
DELIMITER ;

/*
QUESTION 9:

Procedure creates a 'Hot List' showing 10 games which have been played most
often in the last week.

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

Procedures to create & delete friendships.

NOTE: Game invites are dealt with by the Matches relations (see question 20) 
and are therefore not included here.

Author: Alex Parrott
*/

/* Procedure creates a Friendship Request - used to create & delete friendships */
DROP PROCEDURE IF EXISTS CreateRequest;
DELIMITER $$
CREATE PROCEDURE CreateRequest(IN User VARCHAR(20),reqFriend VARCHAR(30),deleteFlag INT,emailFlag INT)
BEGIN
	/* Action friendships to delete */
	IF (deleteFlag)
	THEN
		IF (emailFlag)
		THEN
			INSERT INTO FriendRequest(Requester,Email,Response)
			VALUES(User,reqFriend,'Declined');
		ELSE
			INSERT INTO FriendRequest(Requester,Requestee,Response)
			VALUES(User,reqFriend,'Declined');
		END IF;
	/* Action new friendship requests */
	ELSE
		IF (emailFlag)
		THEN
			INSERT INTO FriendRequest(Requester,Email)
			VALUES(User,reqFriend);
		ELSE
			INSERT INTO FriendRequest(Requester,Requestee)
			VALUES(User,reqFriend);
		END IF;
	END IF;
END; $$
DELIMITER ;

/* Procedure processes all FriendRequests */
DROP PROCEDURE IF EXISTS ProcessRequest;
DELIMITER $$
CREATE PROCEDURE ProcessRequest(IN reqID INT)
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
			FROM Email
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	/* Delete any completed requests */
	DELETE FROM FriendRequest
	WHERE Response = 'Completed';

	/* Delete any friendships for unwanted friendships */
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) = 'Declined'
	THEN	
		DELETE FROM Friends 
		WHERE AccHolder = Friend1
		AND Friend = Friend2;
		DELETE FROM Friends
		WHERE AccHolder = Friend2
		AND Friend = Friend1;
	END IF;
	/* Create new friendship for any accepted friend requests */
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) = 'Accepted'
	THEN	
		INSERT INTO Friends(AccHolder,Friend) 
		VALUES (Friend1,Friend2);
		INSERT INTO Friends(AccHolder,Friend) 
		VALUES (Friend2,Friend1);
	END IF;
	/* Change response status to complete for all actioned requests */
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) <> 'Pending'
	THEN
		UPDATE FriendRequest
		SET Response = 'Completed'
		WHERE RequestID = reqID;
	END IF;
END; $$
DELIMITER ;

/*
QUESTION 11:

When given a user and a game this procedure shows a leaderboard which lists 
just the user and their friends. 

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
			WHERE AccHolder = UserN
		 UNION SELECT UserN 
		)
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
		SELECT CONCAT(earntAchiev,' of ',totalAchiev,' achievements ','(',pointVal,' points', ')') AS 'Your_Achievements';
	ELSE
		SELECT 'Error: game not owned by user!' AS 'Your_Achievements';
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
		!= 0)
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
		/* Number of friends of user */
		SET @numFriends = (
			SELECT COUNT(Friend) FROM Friends f
			WHERE f.AccHolder = usrname
		);
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
			WHERE x.gameid = gameident) a 
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
QUESTION 16:

List the games a user and their friend own, their achievement points per game.
At end of list add all games + achievement points owned by each user that the other does not own.

Author: James Hamblion
*/
DROP PROCEDURE IF EXISTS CompListGameAchievFriend;
DELIMITER $$
CREATE PROCEDURE CompListGameAchievFriend(usrname VARCHAR(50), frndusrname VARCHAR(50))
BEGIN
	DECLARE ttl VARCHAR(30);
	DECLARE usrA VARCHAR(20);
	DECLARE usrpointsA VARCHAR(20);
	DECLARE usrB VARCHAR(20);
	DECLARE usrpointsB VARCHAR(20);
	DECLARE done INT DEFAULT FALSE;
	/*Cursor for games and achiev of usrname*/
	DECLARE cur CURSOR FOR
	/*Cursor query start*/
		SELECT query1.GameTitle, User_A, User_A_Points, User_B, User_B_Points
		FROM
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points
				 FROM
					(SELECT ID, User_A, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_A, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = usrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				 ON x.achievementID = y.achievementID
				 GROUP BY ID
				 ORDER BY x.achievementID DESC) query1 
			LEFT OUTER JOIN
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points
				FROM
					(SELECT ID, User_B, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_B, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = frndusrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				ON x.achievementID = y.achievementID
				GROUP BY ID
				ORDER BY x.achievementID DESC) query2
			ON query1.GameTitle = query2.GameTitle 
			
		UNION
		
		SELECT query2.GameTitle, User_A, User_A_Points, User_B, User_B_Points
		FROM
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points
				 FROM
					(SELECT ID, User_A, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_A, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = usrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				 ON x.achievementID = y.achievementID
				 GROUP BY ID
				 ORDER BY x.achievementID DESC) query1 
			RIGHT OUTER JOIN
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points
				FROM
					(SELECT ID, User_B, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_B, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = frndusrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				ON x.achievementID = y.achievementID
				GROUP BY ID
				ORDER BY x.achievementID DESC) query2
			ON query1.GameTitle = query2.GameTitle;
	/*Cursor query end*/
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	/*Build statement for the temporary create comparison table screen
	with procedure input variables in column/attribute names*/
	SET @userAchPoints = CONCAT('CREATE TABLE Compare_List (Game_Title VARCHAR(30), ', 
					 'Your_Achievement_Points VARCHAR(20), ',
					 'Achievement_Points_of_', frndusrname, ' VARCHAR(20), notOwned INT)');
	/*Create user/friend game and achievements comparison table*/
	PREPARE stmnt FROM @userAchPoints;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	/*Populate Compare_Screen temporary output table:*/
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO ttl, usrA, usrpointsA, usrB, usrpointsB;
	    	IF done THEN
			LEAVE pop_loop;
	   	END IF;
	   	/*Check if game owned by both users*/
	   	IF ((usrA IS NOT NULL) AND (usrB IS NOT NULL)) THEN
	   		SET @owned = 1; /*Set flag for sort order (1 = owned by both users)*/
			/*Check if a user has null points for an owned game and set to 0*/
			IF (usrpointsA IS NULL) THEN
				SET usrpointsA = '0';
			ELSEIF (usrpointsB IS NULL) THEN
				SET usrpointsB = '0';
			END IF;
		ELSE /*only owned by one user*/
			SET @owned = 0; /*Set flag for sort order (0 = not owned by one user)*/
			IF (usrA IS NULL AND usrB IS NOT NULL) THEN /*owned by usrB not usrA*/
				SET usrpointsA = '';
				SET usrpointsB = '0';
			ELSEIF (usrA IS NOT NULL AND usrB IS NULL) THEN /*owned by usrA not usrB*/
				SET usrpointsA = '0';
				SET usrpointsB = '';
			END IF;
	   	END IF;
	   	/*Insert results into temporary output table*/
	   	INSERT INTO Compare_List 
	   		VALUES (ttl, usrpointsA, usrpointsB, @owned);
	END LOOP;
	CLOSE cur;
	/*Display result query string*/
	SET @resultStr = CONCAT('SELECT Game_Title, Your_Achievement_Points, Achievement_Points_of_',
						frndusrname, ' FROM Compare_List ORDER BY notOwned DESC');
	PREPARE stmnt FROM @resultStr;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	DROP TABLE Compare_List;
END; $$
DELIMITER ;


/*
QUESTION 17:

Creates leaderboards.

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
QUESTION 18:

Suggests friends to any user which are not already friends and have more than one 
friend or game in common with the specified user.

Author: Alex Parrott 
*/
DROP PROCEDURE IF EXISTS SuggestFriends;
DELIMITER $$
CREATE PROCEDURE SuggestFriends(IN User VARCHAR(20))
BEGIN
	DECLARE toCheck VARCHAR(20);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR 
		SELECT UserName FROM SuggestedFriends;
	DECLARE CONTINUE HANDLER FOR
		NOT FOUND SET done = TRUE;

	/* Create a table of all specified user's friends... */
	CREATE TABLE AllFriends(
		SELECT Friend 
		FROM Friends
		WHERE AccHolder = User
	);
	/* ...and one of all of their games */
	CREATE TABLE AllGames(
		SELECT GameID
		FROM UserToGame
		WHERE UserName = User
	);
	/* Create a table to hold non friends to make suggestions */
	CREATE TABLE SuggestedFriends(
		SELECT UserName
		FROM UserPrivate
		WHERE UserName <> User
		AND UserName NOT IN
			(SELECT Friend AS UserName
			FROM AllFriends)
	);
	ALTER TABLE SuggestedFriends
	ADD FriendsInCommon INT;
	ALTER TABLE SuggestedFriends
	ADD GamesInCommon INT;

	/* Loop cycles through all users who are not already friends with provided user */
	OPEN cur;
	getFriends: LOOP

		FETCH cur INTO toCheck;
		IF done = TRUE
		THEN
			LEAVE getFriends;
		END IF;	

		/* Create a table of the current user's friends */
		CREATE TABLE CompareFriend(
			SELECT Friend
			FROM Friends
			WHERE AccHolder = toCheck
		);
		/* Count the friends in common with specified user */
		UPDATE SuggestedFriends 
		SET FriendsInCommon =(
			SELECT COUNT(CompareFriend.Friend) 
			FROM CompareFriend,AllFriends
			WHERE CompareFriend.Friend = AllFriends.Friend
		)
		WHERE UserName = toCheck;

		/* Create a table of the current user's games */
		CREATE TABLE CompareGame(
			SELECT GameID
			FROM UserToGame
			WHERE UserName = toCheck
		);
		/* Count the games in common with specified user */
		UPDATE SuggestedFriends 
		SET GamesInCommon =(
			SELECT COUNT(CompareGame.GameID) 
			FROM CompareGame,AllGames
			WHERE CompareGame.GameID = AllGames.GameID
		)
		WHERE UserName = toCheck;
		/* Drop tables ready for next iteration of the loop */
		DROP TABLE CompareFriend;
		DROP TABLE CompareGame;
		

	END LOOP getFriends;
	CLOSE cur;

	/* Display any users with more than one friend or game in common */
	SELECT * FROM SuggestedFriends
	WHERE FriendsInCommon > 1
	OR GamesInCommon > 1;

	DROP TABLE AllFriends;
	DROP TABLE AllGames;
	DROP TABLE SuggestedFriends;	
END; $$
DELIMITER ;


/* Question 20 

Allows for users to invite each other to play games and have matches against 
each other.

Author: Will Woodhead
*/

DROP PROCEDURE if exists CreateMatch;
DELIMITER //
CREATE PROCEDURE CreateMatch(UTGID INT, minPlayer INT, maxPlayer INT, matchnm VARCHAR(30))
BEGIN 

INSERT INTO Matches (Initiator, MinPlayers, MaxPlayers, MatchName)
VALUES (UTGID, minPlayer, maxPlayer, matchnm);

INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
VALUES (
	(SELECT MatchID FROM Matches WHERE Initiator=UTGID AND MatchName=matchnm),
	UTGID
	);
END; //
DELIMITER ;


DROP PROCEDURE if exists MatchRequesting;
DELIMITER //
CREATE PROCEDURE MatchRequesting(Sending INT, Receiving INT, mID INT)
BEGIN 
	INSERT INTO MatchRequest (SendingUTG, ReceivingUTG, MatchID)
	VALUES (Sending, Receiving, mID);
END; //
DELIMITER ;

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
	INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			NEW.GameID, 
			(SELECT SortOrder FROM Game WHERE GameID = NEW.GameID),
			'1_week'
		);
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			NEW.GameID, 
			(SELECT SortOrder FROM Game WHERE GameID = NEW.GameID),
			'1_day'
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
	SET @num = (SELECT NoOfPlayer FROM Matches WHERE Matches.MatchID = NEW.MatchID);
	IF NEW.Response = 'Accepted' 
	THEN BEGIN 
		INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
		VALUES(NEW.MatchID, NEW.ReceivingUTG);
		UPDATE Matches 
		SET NoOfPlayer = @num + 1
		WHERE MatchID = New.MatchID;
	END; END IF;

END $$
DELIMITER ;

/* AFTER UPDATE on UserTogametomatch */
DELIMITER $$
CREATE TRIGGER matchtousertogame_after_update 
AFTER UPDATE ON MatchToUserToGame
FOR EACH ROW
BEGIN 
	
	SET @num = (SELECT NoOfPlayer FROM Matches WHERE Matches.MatchID = NEW.MatchID);
	IF NEW.PlayerStatus = 'Quit' 
	THEN BEGIN
		UPDATE Matches
		SET NoOfPlayer =  @num - 1
		WHERE MatchID = NEW.MatchID;
	END; END IF;

END $$
DELIMITER ;

/* Setup the TRIGGER on User-Public table*/
DROP TRIGGER IF EXISTS userNameEntryCheck;
DELIMITER $$
CREATE TRIGGER userNameEntryCheck
BEFORE INSERT ON UserPublic
FOR EACH ROW
BEGIN
	SET @usrname = NEW.userName;
	SET @obscene = isUserNameRude(@usrname);
	IF @obscene THEN
		SET NEW.AccountStatus := 'Locked';
	END IF;
END; $$
DELIMITER ;

