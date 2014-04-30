
DROP PROCEDURE if exists GetLeaderboard;
DELIMITER //
CREATE PROCEDURE GetLeaderboard(LBID INT)
BEGIN 

SET @ScoreFormat = (SELECT ScoreFormat FROM Game WHERE GameID = (SELECT GameID FROM Leaderboard WHERE LeaderboardID = LBID));
SET @GID = (SELECT GameID FROM Leaderboard WHERE LeaderboardID = LBID);
CREATE TABLE temp (Username VARCHAR(30) , Score INT , TimeOfScore TIMESTAMP); 

	IF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_year') THEN
		INSERT INTO temp SELECT Username, Score, TimeOfScore FROM Scores, UserToGame  WHERE Scores.UserToGameID = UserToGame.ID AND UserToGame.GameID = @GID AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 365 DAY));
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_week') THEN
		INSERT INTO temp SELECT Username, Score, TimeOfScore FROM Scores, UserToGame  WHERE Scores.UserToGameID = UserToGame.ID AND UserToGame.GameID = @GID AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY));
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_day') THEN
		INSERT INTO temp SELECT Username, Score, TimeOfScore FROM Scores, UserToGame  WHERE Scores.UserToGameID = UserToGame.ID AND UserToGame.GameID = @GID AND  TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 1 DAY));
	ELSE
		INSERT INTO temp SELECT Username, Score, TimeOfScore FROM Scores, UserToGame  WHERE Scores.UserToGameID = UserToGame.ID AND UserToGame.GameID = @GID; 
	END IF;

	IF ((SELECT SortOrder FROM Leaderboard WHERE LeaderboardID=LBID) = 'asc') THEN
		SELECT  Username, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp ORDER BY Score ASC;
	ELSE
		SELECT  Username, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;
END; //
DELIMITER ;

CALL GetLeaderboard(5);

