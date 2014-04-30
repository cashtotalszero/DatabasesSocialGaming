/* QUESTION 12 */

/*
This is an example query. To look up another user's list of friends information
the AccHolder will need to be changed in the AllFriends table. In this example
the user AlexParrott's friends are looked up.
*/ 

DELIMITER $$
/* Create a temp table of all specified user's friends */
DROP TABLE IF EXISTS AllFriends;
CREATE TEMPORARY TABLE AllFriends(
	SELECT Friend FROM(
		(SELECT * FROM Friends) 
		UNION DISTINCT 
		(SELECT * FROM Friends2)) 
	AS CombinedFriends 
	WHERE AccHolder = 'AlexParrott');

/* Create a temp table of last games played by each friend */
/* (1) Get the date of the last play */
DROP TABLE IF EXISTS LastDate;
CREATE TEMPORARY TABLE LastDate(	
	SELECT UserName,MAX(LastPlayDate) AS LastPlay 
	FROM UserToGame
	GROUP BY UserName
	ORDER BY LastPlayDate DESC);
/* (2) Get the unique ID and name of the game played on this date */
DROP TABLE IF EXISTS LastGame;
CREATE TEMPORARY TABLE LastGame(
	SELECT UserToGame.UserName,Game.GameID,Name
	FROM UserToGame
	JOIN LastDate ON LastDate.UserName = UserToGame.UserName
	JOIN Game ON UserToGame.GameID = Game.GameID
	WHERE LastPlay = LastPlayDate);


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
$$
DELIMITER ;

