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
