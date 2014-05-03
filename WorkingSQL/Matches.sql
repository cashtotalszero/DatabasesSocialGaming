
/* someone creates a match */
CALL CreateMatch (3, 2, 4, "Family round robin");
SELECT * FROM Matches;

/*request other users who play the game to join the game*/
CALL MatchRequesting(3, 6, 1);
CALL MatchRequesting(3, 7, 1);
CALL MatchRequesting(3, 12, 1);
SELECT * FROM MatchRequest;

/* the other users accept the request*/
UPDATE MatchRequest
SET Response = 'Accepted'
WHERE MatchRequestID = 1;

UPDATE MatchRequest
SET Response = 'Accepted'
WHERE MatchRequestID = 2;

UPDATE MatchRequest
SET Response = 'Accepted'
WHERE MatchRequestID = 3;

SELECT * FROM Matches;
SELECT * FROM MatchToUserToGame;

/* one of the players quits the game*/
UPDATE MatchToUserToGame
SET PlayerStatus = 'Quit'
WHERE MatchID = 1 AND UserToGameID = 6;

SELECT * FROM Matches;




