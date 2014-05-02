DROP PROCEDURE if exists CreateMatch;
DELIMITER //
CREATE PROCEDURE CreateMatch(UTGID INT, minPlayer INT, maxPlayer INT, matchnm VARCHAR(30))
BEGIN 

INSERT INTO Matches (Initiator, MinPlayers, MaxPlayers, MatchName)
VALUES (UTGID, minPlayer, maxPlayer, matchnm);

INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
VALUES (
	(SELECT MatchID FROM Matches WHERE Initiator=UTGID AND MatchName=matchnm),
	UTGID
	);
END; //
DELIMITER ;

DROP PROCEDURE if exists MatchRequesting;
DELIMITER //
CREATE PROCEDURE MatchRequesting(Sending INT, Receiving INT, mID INT)
BEGIN 
	INSERT INTO MatchRequest (SendingUTG, ReceivingUTG, MatchID)
	VALUES (Sending, Receiving, mID);
END; //
DELIMITER ;



/* AFTER UPDATE on UserTogametomatch */
DELIMITER $$
CREATE TRIGGER matchtousertogame_after_update 
AFTER UPDATE ON MatchToUserToGame
FOR EACH ROW
BEGIN 
	
	IF NEW.status = 'Quit' 
	THEN BEGIN
		UPDATE Matches
		SET NoOfPlayers = (SELECT NoOfPlayers FROM Matches WHERE MatchID = NEW.MatchID) - 1
		WHERE MatchID = NEW.MatchID;
	END; END IF;

END $$
DELIMITER ;




CALL CreateMatch (1, 2, 4, "Family round robin");
CALL MatchRequesting(1, 2, 1);
UPDATE MatchRequest
SET Response = 'Accepted'
WHERE MatchRequestID = 1;




