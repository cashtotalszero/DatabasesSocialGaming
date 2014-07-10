/*
QUESTION 12:

Please note that this procedure has been incorporated into the triggers.sql file 
and have been separated her for explanation purposes only.

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
		SELECT Friend FROM(
			(SELECT * FROM Friends) 
			UNION DISTINCT 
			(SELECT * FROM Friends2)) 
		AS CombinedFriends 
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

CALL ShowFriends('AlexParrott');
