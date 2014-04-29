
DROP PROCEDURE if exists GetLeaderboard;
DELIMITER //
CREATE PROCEDURE GetLeaderboard(LBID INT)
BEGIN 
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
		SELECT * FROM temp WHERE LeaderboardID = LBID ORDER BY Score ASC;
	ELSE
		SELECT * FROM temp WHERE LeaderboardID = LBID ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;
END; //
DELIMITER ;

CALL GetLeaderboard(1);


update Scores
	SET TimeOfScore='2013-05-20 14:41:26'
	WHERE Score=9 AND UserToGameID=3;

update Leaderboard 
	SET TimePeriod='1_year'
	WHERE LeaderboardID=1;
