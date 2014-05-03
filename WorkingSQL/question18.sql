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
	CREATE TABLE SuggestedFriends(
		SELECT UserName
		FROM UserPrivate
		WHERE UserName <> User
		AND UserName NOT IN
			(SELECT Friend AS UserName
			FROM AllFriends)
	);
	ALTER TABLE SuggestedFriends
	ADD NoInCommon INT;

	OPEN cur;
	getFriends: LOOP

		FETCH cur INTO toCheck;
		IF done = TRUE
		THEN
			LEAVE getFriends;
		END IF;	

		/* Create a table of the user's friends */
		CREATE TABLE CompareFriend(
			SELECT Friend
			FROM Friends
			WHERE AccHolder = toCheck
		);
		/* Count the number in common with specified user */
		UPDATE SuggestedFriends 
		SET NoInCommon =(
			SELECT COUNT(CompareFriend.Friend) 
			FROM CompareFriend,AllFriends
			WHERE CompareFriend.Friend = AllFriends.Friend
		)
		WHERE UserName = toCheck;

		/* Display the final list
		SELECT * FROM CompareFriend;*/
		DROP TABLE CompareFriend;
		

	END LOOP getFriends;
	CLOSE cur;

	/* Display the final list */
	SELECT * FROM SuggestedFriends;
	DROP TABLE AllFriends;
	DROP TABLE AllGames;
	DROP TABLE SuggestedFriends;

	
END; $$
DELIMITER ;
