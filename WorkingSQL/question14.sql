/* QUESTION 14 */
--Procedure call tests
CALL ShowStatusScreen('AlexParrott');
CALL ShowStatusScreen('JamesHamblion');
CALL ShowStatusScreen('WillWoodhead');
CALL ShowStatusScreen('Al'); --nothing happens. Correct.

/* PROCEDURE to show a users status screen */
DROP PROCEDURE IF EXISTS ShowStatusScreen;
DELIMITER //
CREATE PROCEDURE ShowStatusScreen(usrname VARCHAR(50))
BEGIN
	--User not found handler (skips query code if no usrname exists in database)
	IF ((SELECT COUNT(UserName) FROM UserPublic u WHERE u.UserName = usrname) != 0) THEN
		--User status line
		SET @status = (
			SELECT UserStatus FROM UserPublic u
			WHERE u.UserName = usrname
			);
		--Number of games owned by user
		SET @numGames = (
			SELECT COUNT(userName) FROM UserToGame u
			WHERE u.UserName = usrname
			);
		IF (@numGames IS NULL) THEN SET @numGames = 0; END IF; --prevents null output
		--Total achievement points for user
		SET @numPoints = (
			SELECT SUM(PointValue) FROM Achievement a, AchievementToUserToGame b
			WHERE b.userToGameid IN (SELECT ID FROM UserToGame u WHERE u.UserName = usrname)
				 AND a.achievementID = b.achievementID
			);
		IF (@numPoints IS NULL) THEN SET @numPoints = 0; END IF; --prevents null output
		/* Number of friends of user */
		SET @numFriends = (
			SELECT COUNT(Friend) FROM Friends f
			WHERE f.AccHolder = usrname
		);

		IF (@numFriends IS NULL) THEN SET @numFriends = 0; END IF; --prevents null output
		--create status screen table, insert values, print and then drop the the Status_Screen table
		CREATE TABLE Status_Screen (Username VARCHAR(20), Status_Line VARCHAR(100), Number_of_Games_Owned INT, 
					    Total_Number_of_Achievement_Points INT, Number_of_Friends INT);
		INSERT INTO Status_Screen
			VALUES (usrname, @status, @numGames, @numPoints, @numFriends);
		SELECT * FROM Status_Screen;
		DROP TABLE Status_Screen;
	END IF;
END	//
DELIMITER ;
