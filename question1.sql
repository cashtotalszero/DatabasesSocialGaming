/* QUESTION 1: Given a game, list all the users who own that game */

/* (1) Set temp variable gameVar as the Game you want to lookup (Game.GameID) */
SET @gameVar =4;

/* (2) List all user names who own that game */
SELECT UserPublic.UserName 
FROM Game,UserPublic,UserToGame
WHERE 
	UserPublic.UserName=UserToGame.UserName AND 
	Game.GameID=UserToGame.GameID AND	
	Game.GameID=@gameVar;



