/* QUESTION 15 */
--Procedure call tests
CALL ListUserGameAchievements('WillWoodhead', 3);

--Output:
--Title	PointValue	Description				DateGained
--Goalie Scorer	20	Scored with your goal keeper	2014-02-12
--Always Friendly	20	Crossed for a Friend to score	2013-12-13
--Fowler			10	Received 5 red cards in a game2013-04-26
--Penalty guru		50	Win 50 games through penalties<null>
--Note: 'Post and in' achievement not shown because it is hidden and not earnt.

/* PROCEDURE */
--Show achievements for a game that a user has earnt, and those that they have not
--(providing they are not hidden i.e. hiddenFlag = FALSE).
DROP PROCEDURE IF EXISTS ListUserGameAchievements;
DELIMITER //
CREATE PROCEDURE ListUserGameAchievements(usrname VARCHAR(50), gameident INT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
	--All var needed to fetch row fields
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
	--Var to determine post or pre description
	DECLARE descrpt VARCHAR(200);
	--The query to give everything needed:
	DECLARE cur CURSOR FOR 
		SELECT * FROM 
			(SELECT * FROM Achievement x WHERE x.gameid = gameident) a LEFT OUTER JOIN
			(SELECT * FROM AchievementToUserToGame y 
			 WHERE y.userToGameid IN 
				(SELECT ID FROM UserToGame u WHERE u.UserName = usrname AND u.gameID = gameident)) b
		ON a.achievementID = b.achievementID
		WHERE (b.dateGained IS NULL AND a.hiddenFlag = FALSE) OR
			(a.hiddenFlag = FALSE) OR
			(b.dateGained IS NOT NULL AND a.hiddenFlag = TRUE)
		ORDER BY b.dateGained DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
	
	--Create result table
	CREATE TABLE GameAchievementList (Title VARCHAR(50), PointValue INT, Description VARCHAR(200), DateGained DATE);
	--Populate the table by looping row by row using a cursor.
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO achID, gmid, ttl, hidFlag, icn, pointVal, poDes, preDes, a, u, dgain;
	    	IF done THEN
			LEAVE pop_loop; --if user doesn't exist or game not owned procedure ends / does nothing.
	   	END IF;
	   	--Check description to use. Earnt achievement = postDescription
	   	IF (dgain IS NULL) THEN SET descrpt = preDes; 
	   	ELSE SET descrpt = poDes;
	   	END IF;
		INSERT INTO GameAchievementList
			VALUES (ttl, pointVal, descrpt, dgain);
	END LOOP;
	CLOSE cur;
	--Display results and then drop the table as no longer needed.
	SELECT * FROM GameAchievementList;
	DROP TABLE GameAchievementList;
END;	//
DELIMITER ;


--Testing (ignore!):
--Strategy:
	--get earnt achievement table
	--get all achievement table
	--outer join earnt with all on achievement id to get all required columns
	--filter out hidden and not earnt
--Earnt achievements e.g. Will's earnt for Fifa (gameid = 3)
SELECT * FROM AchievementToUserToGame a
WHERE a.userToGameid IN (SELECT ID FROM UserToGame u WHERE u.UserName = 'WillWoodhead' AND u.gameID = 3)
--All achievements for a game
SELECT * FROM Achievement a
WHERE a.gameid = 3;
--Outer join earnt with all on achievement id to get all required columns
SELECT * FROM 
	(SELECT * FROM Achievement x WHERE x.gameid = 3) a LEFT OUTER JOIN
	(SELECT * FROM AchievementToUserToGame y 
	 WHERE y.userToGameid IN 
		(SELECT ID FROM UserToGame u WHERE u.UserName = 'WillWoodhead' AND u.gameID = 3)) b
ON a.achievementID = b.achievementID
WHERE (b.dateGained IS NULL AND a.hiddenFlag = FALSE) OR
	(a.hiddenFlag = FALSE) OR
	(b.dateGained IS NOT NULL AND a.hiddenFlag = TRUE)
ORDER BY b.dateGained DESC;
