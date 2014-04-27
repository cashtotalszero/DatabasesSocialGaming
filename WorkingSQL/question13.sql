/* QUESTION 13 */
--Procedure call tests
CALL AchievementsForUserGame('WillWoodhead', 3); --game owned 1 of 2 achievements. OK.
CALL AchievementsForUserGame('JamesHamblion', 2); --game not owned. O.K
CALL AchievementsForUserGame('JamesHamblion', 1); --game owned 0 of 1 achievements. OK.
CALL AchievementsForUserGame('AlexParrott', 1); --game owned 1 of 1 achievements. OK.
--End testing

/* PROCEDURE to show achievement status for a user in a specific game. */
--Output examples: 
--16 of 80 achievements (95 points)
--0 of 1 achievements (0 points)
--If game not owned by user: 'Error: game not owned by user!'
DROP PROCEDURE IF EXISTS AchievementsForUserGame;
DELIMITER //
CREATE PROCEDURE AchievementsForUserGame(usrname VARCHAR(50), gameident INT)
BEGIN
	DECLARE totalAchiev INT;
	DECLARE userGameid INT;
	DECLARE earntAchiev INT;
	DECLARE pointVal INT;

	--Get userToGameID for the game and username. If user doesn't own game variable is null.
	SET userGameid = (
		SELECT ID FROM UserToGame utg
		WHERE utg.UserName = usrname AND utg.gameid = gameident
		);
	--Check userGameid not null and continue, else return message 'Error: game not owned by user!'
	IF (userGameid IS NOT NULL) THEN
		--Get total achievement number for game
		SET totalAchiev = (
			SELECT COUNT(achievementID) FROM Achievement a
			WHERE a.gameid = gameident
			);
		--Get earnt achievements for the user in the specified game
		SET earntAchiev = (
			SELECT COUNT(achievementID) FROM AchievementToUserToGame a
			WHERE a.userToGameID = userGameid
			);
		IF (earntAchiev IS NULL) THEN SET earntAchiev = 0; END IF; --prevents null output
		--Get point value of earnt achievements for the user in the specified game
		SET pointVal = (
			SELECT SUM(PointValue) FROM Achievement a, AchievementToUserToGame b
			WHERE b.userToGameid = userGameid AND a.achievementID = b.achievementID
				AND a.gameid = gameident
			);
		IF (pointVal IS NULL) THEN SET pointVal = 0; END IF; --prevents null output
		SELECT CONCAT(earntAchiev, ' of ', totalAchiev, ' achievements ', '(', pointVal, ' points', ')');
	ELSE
		SELECT 'Error: game not owned by user!';
	END IF;
END;	//
DELIMITER ;


--Testing
SELECT CONCAT('hELLO!', ' Bob');

SELECT COUNT(achievementID) FROM Achievement A
WHERE A.gameid = 1;

SELECT id FROM UserToGame utg
WHERE utg.UserName = 'AlexParrott' AND gameid = 1;

SELECT COUNT(achievementID) FROM AchievementToUserToGame a
WHERE a.userToGameID = 2;

SELECT SUM(PointValue) FROM Achievement a, AchievementToUserToGame b
WHERE b.userToGameid = 2 AND a.achievementID = b.achievementID
	AND a.gameid = 1;

--Null tests
SET @nulltest = 1;
SELECT @nulltest;

SET @test = NULL;
IF (@test IS NULL) THEN
	SELECT 'Error: game not owned by user!';
END IF;

SET @bal = 150;
IF (@bal < 250) THEN SET @bal = 250;
	--SELECT @bal;
END IF;

SET @nulltest = (SELECT id FROM UserToGame utg
			 WHERE utg.UserName = 'WillWoodhead' AND gameid = 3);
IF (@nulltest IS NULL) THEN
	SELECT 'Error: game not owned by user!';
END IF;
SELECT @nulltest;

SET @obscene = TRUE;
IF @obscene THEN
SET @obscene = FALSE;
END IF;
SELECT @obscene;

SET @bal = 150;
IF (@bal < 250) THEN SET @bal = 250;
	--SELECT @bal;
END IF;

SELECT VERSION();
