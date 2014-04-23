/* Question 9 */

/* This table is used to record every play of every game and the timestamp*/
CREATE TABLE Plays(
	GameID INT NOT NULL,
	UserName VARCHAR(20) NOT NULL,
	TimeOfPlay TIMESTAMP,
	CONSTRAINT pkNoOfPlaysID
		PRIMARY KEY(GameId, UserName, TimeOfPlay)
);

/* This table is the most played games in the last week*/
CREATE TABLE HotList(
	Ranking INT NOT NULL AUTO_INCREMENT,
	GameID INT NOT NULL,
	NOPLastWeek INT,
	CONSTRAINT pkID
		PRIMARY KEY(ranking)
);

/* Trigger to update hotlist when a new Play is inserted */
DELIMITER $$
CREATE TRIGGER playCount_After_Insert After INSERT ON Plays
FOR EACH ROW 
BEGIN
	DELETE FROM HotList;
	INSERT INTO HotList (GameID, NOPLastWeek)
	SELECT GameID, COUNT(GameID) FROM Plays WHERE Plays.TimeOfPlay > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY GameID;
END $$
DELIMITER ;