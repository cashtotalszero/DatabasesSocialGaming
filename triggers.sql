

/*
--THIS WORKS
CREATE TRIGGER q2insert 
AFTER INSERT ON UserToGame 
FOR EACH ROW
	UPDATE Game
	SET AverageRating=99.0
	WHERE GameID=NEW.GameID;
*/

CREATE TRIGGER q2insert 
AFTER INSERT ON UserToGame 
FOR EACH ROW
	UPDATE Game
	SET AverageRating=(
		SELECT AVG(UserRating)FROM Game,UserToGame,UserPublic
		WHERE 
			UserPublic.UserName=UserToGame.UserName AND 
			Game.GameID=UserToGame.GameID AND
			Game.GameID=NEW.GameID)
	WHERE GameID=NEW.GameID;


/*
SET AverageRating=(
		SELECT AVG(Rating)
		FROM Game,UserPublic,UserToGame
		WHERE 
			UserPublic.UserName=NEW.UserName AND 
			UserPublic.UserName=UserToGame.UserName AND 
			Game.GameID=UserToGame.GameID)
*/

/*	

INSERT INTO UserToGame(UserName,GameID)
	VALUES('AlexParrott',3
);
*/

/*
BELOW WORKS:

SELECT AVG(UserRating)FROM Game,UserToGame,UserPublic
WHERE 
	UserPublic.UserName=UserToGame.UserName AND 
	Game.GameID=UserToGame.GameID AND
	Game.GameId=4;
*/

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AlexParrott',4,5);	
