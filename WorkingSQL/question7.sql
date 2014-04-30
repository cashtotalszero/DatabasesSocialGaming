
DROP PROCEDURE if exists DayAndWeekLeaders;
DELIMITER //
CREATE PROCEDURE DayAndWeekLeaders()
BEGIN 

	SET @gameCount = (SELECT COUNT(GameID) FROM Game);
	SET @index = 1;

	WHILE( @index <= @gameCount) DO
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (@index, (SELECT SortOrder FROM Game WHERE GameID = @index), '1_week');
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (@index, (SELECT SortOrder FROM Game WHERE GameID = @index), '1_day');
		SET @index = @index + 1;
	END WHILE ;

END; //
DELIMITER ;

CALL DayAndWeekLeaders();



