/*question 4 */

DROP PROCEDURE if exists Question4;
DELIMITER //
CREATE PROCEDURE Question4(User VARCHAR(30), GID INT)
BEGIN 

	SET @rank=0;
	/*@count is the number of users who have registered a score in a particular game*/
	SET @count = (SELECT COUNT(*) FROM Scores WHERE UserToGameID IN (SELECT ID FROM UserToGame WHERE GameID = GID)); 

	/*check whether the scores are ascending or descending*/
	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') THEN
		SELECT @rank:=@rank+1 AS rank, (@rank/@count)*100 AS top_X_percent, UserToGameID, Score, TimeOfScore  
		FROM Scores 
		WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE UserName = User AND GameID = GID)
		ORDER BY Score ASC LIMIT 0, 1;
	ELSE 
		SELECT @rank:=@rank+1 AS rank, (@rank/@count)*100 AS top_X_percent, UserToGameID, Score, TimeOfScore  
		FROM Scores 
		WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE UserName = User AND GameID = GID)
		ORDER BY Score DESC LIMIT 0, 1;
	END IF;

	

END; //
DELIMITER ;

CALL Question4('AlexParrott', 1);

UPDATE GAME 
SET SortOrder = 'desc'
WHERE GameID = 1;



