/* Question 11: Given a user and a game, show a leaderboard which lists just the user and their friends. */


DROP PROCEDURE if exists GetFriendsLeaderboard;
DELIMITER //
CREATE PROCEDURE GetFriendsLeaderboard(UserN VARCHAR(30), GID INT)
BEGIN 

	SET @ScoreFormat = (SELECT ScoreFormat FROM Game WHERE GameID = GID);
	DROP TABLE if exists temp;
	CREATE TABLE temp (Username VARCHAR(30) , Score INT , TimeOfScore TIMESTAMP);

	INSERT INTO temp SELECT Username, Score, TimeOfScore FROM Scores, UserToGame 
	WHERE Scores.UserToGameID = UserToGame.ID 
	AND UserToGame.GameID = GID
	AND Scores.UserToGameID IN (SELECT ID FROM UserToGame WHERE UserName IN (SELECT Friend FROM (SELECT * FROM Friends UNION SELECT * FROM Friends2) AS friendtemp WHERE AccHolder = UserN)); 

	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') THEN
		SELECT  Username, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp ORDER BY Score ASC;
	ELSE
		SELECT  Username, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;


END; //
DELIMITER ;

CALL GetFriendsLeaderboard('AlexParrott', 1);
