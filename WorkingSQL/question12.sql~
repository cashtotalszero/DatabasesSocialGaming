/* QUESTION 12 - incomplete. Does not show last game played */ 

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
DROP TABLE IF EXISTS LastDate;
CREATE TEMPORARY TABLE LastDate(	
	SELECT UserName,MAX(LastPlayDate) AS LastPlay 
	FROM UserToGame
	GROUP BY UserName
	ORDER BY LastPlayDate DESC);

/* Display list of all online friends */
SELECT UserName,AccountStatus 
FROM UserPublic,AllFriends
WHERE UserPublic.UserName = AllFriends.Friend
AND AccountStatus = 'Online';

/* Display list of offline friends with last login time */
SELECT UserPublic.UserName,AccountStatus,LastLogin
FROM UserPublic,AllFriends
WHERE UserPublic.UserName = AllFriends.Friend
AND AccountStatus = 'Offline';
$$
DELIMITER ;

