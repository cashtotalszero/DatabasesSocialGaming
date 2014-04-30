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

CALL CreateMatch (1, 2, 4, "Family round robin");
CALL MatchRequesting(1, 2, 1);
UPDATE MatchRequest
SET Pending = 0
WHERE MatchRequestID = 1;