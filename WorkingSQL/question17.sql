
DROP PROCEDURE if exists GetLeaderboard;
DELIMITER //
CREATE PROCEDURE GetLeaderboard(LBID INT)
BEGIN 

SET @ScoreFormat = (SELECT ScoreFormat FROM Game WHERE GameID = (SELECT GameID FROM Leaderboard WHERE LeaderboardID = LBID));
CREATE TABLE temp (LeaderboardID INT , UserToGameID INT , Score INT , TimeOfScore TIMESTAMP);

	IF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_year') THEN
		INSERT INTO temp SELECT LeaderboardID, UserToGameID, Score, TimeOfScore FROM LeaderboardToUserToGame WHERE LeaderboardID=LBID AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 365 DAY));
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_week') THEN
		INSERT INTO temp SELECT LeaderboardID, UserToGameID, Score, TimeOfScore FROM LeaderboardToUserToGame WHERE LeaderboardID=LBID AND  TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY));
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_day') THEN
		INSERT INTO temp SELECT LeaderboardID, UserToGameID, Score, TimeOfScore FROM LeaderboardToUserToGame WHERE LeaderboardID=LBID AND  TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 1 DAY));
	ELSE
		INSERT INTO temp SELECT LeaderboardID, UserToGameID, Score, TimeOfScore FROM LeaderboardToUserToGame WHERE LeaderboardID=LBID; 
	END IF;

	IF ((SELECT SortOrder FROM Leaderboard WHERE LeaderboardID=LBID) = 'asc') THEN
		SELECT LeaderboardID, UserToGameID, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp WHERE LeaderboardID = LBID ORDER BY Score ASC;

	ELSE
		SELECT LeaderboardID, UserToGameID, CONCAT(Score,' ', @ScoreFormat) As Score, TimeOfScore FROM temp WHERE LeaderboardID = LBID ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;
END; //
DELIMITER ;

CALL GetLeaderboard(1);

