/* 
QUESTION 1: 

Given a game, list all the users who own that game 

Please note that this procedure and triggers have been incorporated into the 
triggers.sql file and have been separated her for explanation purposes only.

Author: Alex Parrott
*/

DROP PROCEDURE IF EXISTS Question1;
DELIMITER $$
CREATE PROCEDURE Question1(IN gameVar INT)
BEGIN
	SELECT UserPublic.UserName 
	FROM Game,UserPublic,UserToGame
	WHERE UserPublic.UserName=UserToGame.UserName 
	AND Game.GameID=UserToGame.GameID 
	AND Game.GameID=gameVar;

END $$
DELIMITER ;

/* Example query - looks up game with GameID 4 */
CALL Question1(4);
