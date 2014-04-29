
DROP PROCEDURE if exists Hotlist;
DELIMITER //
CREATE PROCEDURE Hotlist()
BEGIN 
	CREATE TABLE Hotlist (Ranking INT NOT NULL AUTO_INCREMENT, GameID INT NOT NULL, NOPLastWeek INT,CONSTRAINT pkID PRIMARY KEY(ranking));
	INSERT INTO HotList (GameID, NOPLastWeek)
	SELECT GameID, COUNT(GameID) FROM Plays WHERE Plays.TimeOfPlay > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY GameID;
	SELECT Ranking, Name, NOPLastWeek FROM Hotlist, Game WHERE Hotlist.GameID = Game.GameID limit 10;
	DROP TABLE Hotlist;
END; //
DELIMITER ;

CALL Hotlist();



