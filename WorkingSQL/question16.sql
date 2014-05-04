/* QUESTION 16 */
--Test procedure call
CALL CompListGameAchievFriend('AlexParrott', 'WillWoodhead');

/* PROCEDURE */
--List the games a user and their friend own, their achievement points per game.
--At end of list add all games + achievement points owned by each user that the other does not own.
--Output example:
--Game_Title		Your_Achievement_Points	Achievement_Points_of_WillWoodhead
--GTA V			10					0
--FIFA 14			0					50
--Angry Birds		30					<null>
--Crash Bandicoot	<null>				<null>
--Bike Runner		<null>				<null>
--mission Impossible<null>				<null>
DROP PROCEDURE IF EXISTS CompListGameAchievFriend;
--DELIMITER //
CREATE PROCEDURE CompListGameAchievFriend(usrname VARCHAR(50), frndusrname VARCHAR(50))
BEGIN
	DECLARE ttl VARCHAR(30);
	DECLARE usrA VARCHAR(20);
	DECLARE usrpointsA INT;
	DECLARE usrB VARCHAR(20);
	DECLARE usrpointsB INT;
	DECLARE done INT DEFAULT FALSE;
	--Cursor for games and achiev of usrname
	DECLARE cur CURSOR FOR
	--Cursor query start
		SELECT query1.GameTitle, User_A, User_A_Points, User_B, User_B_Points
		FROM
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points	--query1
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
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points	--query2
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
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points	--query1
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
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points	--query2
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
	--Cursor query end
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	--Build statement for the temporary create comparison table screen
	--with procedure input variables in column/attribute names
	SET @userAchPoints = CONCAT('CREATE TABLE Compare_List (Game_Title VARCHAR(30), ', 
					 'Your_Achievement_Points INT, ',
					 'Achievement_Points_of_', frndusrname, ' INT, notOwned INT)');
	--Create user/friend game and achievements comparison table
	PREPARE stmnt FROM @userAchPoints;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	--Populate Compare_Screen temporary output table:
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO ttl, usrA, usrpointsA, usrB, usrpointsB;
	    	IF done THEN
			LEAVE pop_loop;
	   	END IF;
	   	--Check if game owned by both users
	   	IF ((usrA IS NOT NULL) AND (usrB IS NOT NULL)) THEN
	   		SET @owned = 1; --Set flag for sort order (1 = owned by both users)
			--Check if a user has null points for an owned game and set to 0
			IF (usrpointsA IS NULL) THEN
				SET usrpointsA = 0;
			ELSEIF (usrpointsB IS NULL) THEN
				SET usrpointsB = 0;
			END IF;
		ELSE SET @owned = 0; --Set flag for sort order (0 = not owned by one user)
	   	END IF;
	   	
	   	INSERT INTO Compare_List 
	   		VALUES (ttl, usrpointsA, usrpointsB, @owned);
	END LOOP;
	CLOSE cur;
	--Display result query string
	SET @resultStr = CONCAT('SELECT Game_Title, Your_Achievement_Points, Achievement_Points_of_',
						frndusrname, ' FROM Compare_List ORDER BY notOwned DESC');
	PREPARE stmnt FROM @resultStr;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	--SELECT * FROM Compare_List ORDER BY notOwned DESC;
	DROP TABLE Compare_List;
END //
DELIMITER ;




--Ignore this...
--Final query backup:
SELECT query1.GameTitle, User_A, User_A_Points, User_B, User_B_Points
FROM
		(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points	--query1
		 FROM
			(SELECT ID, User_A, GameTitle, achievementID 
			 FROM
				(SELECT ID, UserName AS User_A, name As GameTitle
				FROM UserToGame u, Game g
				WHERE u.UserName = 'AlexParrott' AND g.gameid = u.gameid) ug
			 LEFT OUTER JOIN
				AchievementToUserToGame atug
			 ON ug.ID = atug.userToGameID) x
		  LEFT OUTER JOIN 
			Achievement y
		 ON x.achievementID = y.achievementID
		 GROUP BY ID
		 ORDER BY x.achievementID DESC) query1 
	LEFT OUTER JOIN
		(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points	--query2
		FROM
			(SELECT ID, User_B, GameTitle, achievementID 
			 FROM
				(SELECT ID, UserName AS User_B, name As GameTitle
				FROM UserToGame u, Game g
				WHERE u.UserName = 'WillWoodhead' AND g.gameid = u.gameid) ug
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
		(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points	--query1
		 FROM
			(SELECT ID, User_A, GameTitle, achievementID 
			 FROM
				(SELECT ID, UserName AS User_A, name As GameTitle
				FROM UserToGame u, Game g
				WHERE u.UserName = 'AlexParrott' AND g.gameid = u.gameid) ug
			 LEFT OUTER JOIN
				AchievementToUserToGame atug
			 ON ug.ID = atug.userToGameID) x
		  LEFT OUTER JOIN 
			Achievement y
		 ON x.achievementID = y.achievementID
		 GROUP BY ID
		 ORDER BY x.achievementID DESC) query1 
	RIGHT OUTER JOIN
		(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points	--query2
		FROM
			(SELECT ID, User_B, GameTitle, achievementID 
			 FROM
				(SELECT ID, UserName AS User_B, name As GameTitle
				FROM UserToGame u, Game g
				WHERE u.UserName = 'WillWoodhead' AND g.gameid = u.gameid) ug
			 LEFT OUTER JOIN
				AchievementToUserToGame atug
			 ON ug.ID = atug.userToGameID) x
		  LEFT OUTER JOIN 
			Achievement y
		ON x.achievementID = y.achievementID
		GROUP BY ID
		ORDER BY x.achievementID DESC) query2
	ON query1.GameTitle = query2.GameTitle

--Best query backup:
	SELECT ID, User_A, x.GameTitle, SUM(PointValue)	--query1
	FROM
		(SELECT ID, User_A, GameTitle, achievementID 
		 FROM
			(SELECT ID, UserName AS User_A, name As GameTitle
			FROM UserToGame u, Game g
			WHERE u.UserName = 'AlexParrott' AND g.gameid = u.gameid) ug
		 LEFT OUTER JOIN
			AchievementToUserToGame atug
		 ON ug.ID = atug.userToGameID) x
	  LEFT OUTER JOIN 
		Achievement y
	ON x.achievementID = y.achievementID
	GROUP BY ID
	ORDER BY x.achievementID DESC;

--Wrong: Misses out games where user has no achievements:
	--Get all information and sum achievement point value per game.
	SELECT GameTitle, SUM(pointValue) AS User_Points
	FROM 
		(SELECT ID, atug.userToGameID, UserName AS User_A, name As GameTitle, a.achievementID, u.gameID, pointValue 
		FROM UserToGame u, Game g, AchievementToUserToGame atug, Achievement a
		WHERE u.UserName = 'WillWoodhead' AND g.gameid = u.gameid
			AND u.ID = atug.userToGameID AND a.achievementID = atug.achievementID) t
	WHERE GameTitle = 'FIFA 14';
	
	--option1:
	SELECT ID, userToGameID, User_A, GameTitle, a.achievementID, gameID, pointValue 
	FROM 
		(SELECT ID, UserName AS User_A, name As GameTitle
		 FROM UserToGame u, Game g
		 WHERE u.UserName = 'WillWoodhead' AND g.gameid = u.gameid) ug,
		 AchievementToUserToGame atug,
		 Achievement a
	WHERE ug.ID = atug.userToGameID AND a.achievementID = atug.achievementID;

	--option2:
	SELECT ID, atug.userToGameID, UserName AS User_A, name As GameTitle, a.achievementID, u.gameID, pointValue 
	FROM UserToGame u, Game g, AchievementToUserToGame atug, Achievement a
	WHERE u.UserName = 'AlexParrott' AND g.gameid = u.gameid
		 AND u.ID = atug.userToGameID AND a.achievementID = atug.achievementID;