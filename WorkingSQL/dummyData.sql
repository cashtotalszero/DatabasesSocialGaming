/* USER INFORMATION */

/* Dummy values for UserPublic */
INSERT INTO UserPublic 
	VALUES('AlexParrott','./avatar.jpg',CURDATE(),'Online',NULL,'I am logged in!'
);
INSERT INTO UserPublic 
	VALUES('JamesHamblion','./avatar1.jpg',CURDATE(),'Offline',NULL,'Not here...'
);
INSERT INTO UserPublic 
	VALUES('WillWoodhead','./avatar2.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);
INSERT INTO UserPublic 
	VALUES('ScarlettJo','./avatar2.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);
INSERT INTO UserPublic 
	VALUES('AliceInWonderland','./avatar.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);
INSERT INTO UserPublic 
	VALUES('BobHope','./avatar3.jpg',CURDATE(),'Online',NULL,'I am logged in!'
);
INSERT INTO UserPublic 
	VALUES('BarackObama','./avatar4.jpg',CURDATE(),'Online',NULL,'logged in'
);
INSERT INTO UserPublic 
	VALUES('DavidCameron','./avatar5.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);
INSERT INTO UserPublic 
	VALUES('GeorgeClooney','./avatar6.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);
INSERT INTO UserPublic 
	VALUES('BradPitt','./avatar7.jpg',CURDATE(),'Online',NULL,'I am also logged in'
);

/* Dummy values for UserPrivate */
INSERT INTO UserPrivate 
	VALUES('AlexParrott','12343','Alex','Parrott','Alex@Parrott.com'
);
INSERT INTO UserPrivate 
	VALUES('JamesHamblion','JAMES!','James','Hamblion','James@Hamblion.com'
);
INSERT INTO UserPrivate 
	VALUES('WillWoodhead','password','Will','Woodhead','Will@Woodhead.com'
);
INSERT INTO UserPrivate 
	VALUES('ScarlettJo','???','Scarlett','Johansson','Scarlett@Hollywoodbabes.com'
);
INSERT INTO UserPrivate 
	VALUES('AliceInWonderland','maaaaaad75','Alice','Alice','Alice@Wonderland.com'
);
INSERT INTO UserPrivate 
	VALUES('BobHope','12343','Bob','Hope','bob@hope.com'
);
INSERT INTO UserPrivate 
	VALUES('BarackObama','JAMES!','Barack','Obama','barack@obama.com'
);
INSERT INTO UserPrivate 
	VALUES('DavidCameron','password','Dave','Cameron','dave@cameron.com'
);
INSERT INTO UserPrivate 
	VALUES('GeorgeClooney','???','George','Clooney','george@clooney.com'
);
INSERT INTO UserPrivate 
	VALUES('BradPitt','maaaaaad75','Brad','Pitt','Brad@Pitt.com'
);

/* FRIENDS DUMMY DATA TO BE ADDED ONCE TRIGGER IS FINAL */

/* GAME INFORMATION */

/* Dummy values for Game */
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES('18','./img.jpg','GTA V','Rockstar','2013-1-01','A bloody mess','GTA.com',1000,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('18','./img.jpg','The Last of Us', 'Naughty Dog','2013-12-15','The best game ever','404.net',1000,50);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('3','./img.jpg','FIFA 14','EA','2014-1-1','Football. Note: England suck','fifa.com', 1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES ('7','./img.jpg','Angry Birds','Rovio','2010-03-09','Save the angry birds!','www.angrybirds.com',1000, 1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES('12','./img.jpg','mission Impossible','EA','2012-4-04','Ethan Hunt','MI.com',1000,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('12','./img.jpg','James Bond', 'Naughty Dog','2014-01-02','Martini','JB.net',10000,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('3','./img.jpg','Crash Bandicoot','EA','2005-10-10','crazy bandicoot','cxb.com', 1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES ('7','./img.jpg','2048','makers','2014-03-09','get the 2048 tile!','www.2048.com',10000, 1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES('18','./img.jpg','Bike Runner','Rockstar','2013-1-01','drive a bike','bike.com',10000,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('18','./img.jpg','COD4', 'COD','2013-12-18','The best game ever 2','COD.net',1000000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('3','./img.jpg','Black ops','EA','2013-12-12','first person shooter','cool.com', 1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES ('7','./img.jpg','mash up','mash','2009-03-09','mash the potato','www.mashup.com',1000, 1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES('18','./img.jpg','carrot peel','carrot','2013-08-09','peel the carrots','peeler.com',10000,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('18','./img.jpg','bin throw', 'Naughty Dog','2013-07-07','throw paper into the bin','binthrow.net',1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('3','./img.jpg','skyroads','EA','2001-1-1','drive the sky roads','skyroads.com', 1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES ('7','./img.jpg','flick men','Rovio','2010-04-11','flick all the men','www.flickmen.com',10000, 1);

/* Dummy values for Genre */
INSERT INTO Genre 
	VALUES(1,'Horror'
);
INSERT INTO Genre 
	VALUES(2,'Adventure'
);
INSERT INTO Genre 
	VALUES(3,'Sport'
);
INSERT INTO Genre 
	VALUES(4,'Mutliplayer'
);

/* Dummy values for GameToGenre */
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(3,3
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(3,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(1,2
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(1,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(2,1
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(2,2
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(2,3
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(4,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(5,2
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(6,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(7,1
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(8,2
);
	INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(9,3
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(10,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(11,2
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(12,4
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(13,1
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(14,2
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(15,1
);
INSERT INTO GameToGenre(GameID,GenreID) 
	VALUES(16,2
);

/* USER/GAME LINKING RELATION */

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore,LastPlayDate)
	VALUES('AlexParrott',4,1,35,'2014-12-30');

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore,LastPlayDate)
	VALUES('AlexParrott',3,3,15,'2014-12-31');

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AlexParrott',1,9.4);

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore,LastPlayDate)
	VALUES('JamesHamblion',2,10,5,'2015-4-15');

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore,LastPlayDate)
	VALUES('JamesHamblion',4,55.9,18,'2015-8-15');

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('JamesHamblion',1,5.6);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',1,3.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',3,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',5,3);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',7,5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',9,9);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('ScarlettJo',1,5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('ScarlettJo',2,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('ScarlettJo',5,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('ScarlettJo',10,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',1,4.2);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',16,5.3);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',14,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',8,9.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',6,3.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BobHope',1,4.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BobHope',7,2.1);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BobHope',5,3.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BobHope',8,3.6);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BobHope',12,2.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BarackObama',1,6.8);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BarackObama',10,2.7);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BarackObama',11,9.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BarackObama',14,5.6);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('DavidCameron',1,3.9);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('DavidCameron',2,4.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('DavidCameron',3,1.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('DavidCameron',4,8.2);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('DavidCameron',5,3.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',1,8.0);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',6,9.0);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',7,2.3);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',8,2.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',9,1.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('GeorgeClooney',10,5.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',1,6.0);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',11,7.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',12,6.6);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',13,6.2);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',14,6.3);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',15,6.4);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('BradPitt',16,6.1);

/* Dummy values for Achievement table */
INSERT INTO Achievement
	VALUES (1, 1, 'I wish I was a policeman!', 0, 0, 10, 'You stole 100 police cars', 'Steal 100 police cars');
INSERT INTO Achievement
	VALUES (2, 2, 'Up close and personal', 0, 0, 60, 'You killed 80 creatures with a melee weapon', 'Kill 80 creatures with a melee weapon');
INSERT INTO Achievement
	VALUES (3, 3, 'Penalty guru', 0, 0, 50, 'Won 50 games through penalties', 'Win 50 games through penalties');
INSERT INTO Achievement
	VALUES (4, 3, 'Fowler', 1, 0, 10, 'Received 5 red cards in a game', 'Get 5 red cards in a game');
INSERT INTO Achievement
	VALUES (5, 4, 'Score obsessed', 0, 0, 30, 'Achieved a score of 3000000', 'Achieve a score of 3000000');
INSERT INTO Achievement
	VALUES (6, 3, 'Always Friendly', 0, 0, 20, 'Crossed for a Friend to score', 'Cross for a Friend to score');
INSERT INTO Achievement
	VALUES (7, 3, 'Goalie Scorer', 0, 0, 20, 'Scored with your goal keeper', 'Score with your goal keeper');
INSERT INTO Achievement
	VALUES (8, 3, 'Post and in', 1, 0, 20, 'Scored off the post or cross bar in a match', 'Score off the post or cross bar in a match');

/* Dummy values for AchievementToUserToGame table */
INSERT INTO AchievementToUserToGame
	VALUES (1, 2, '2014-1-1');
INSERT INTO AchievementToUserToGame
	VALUES (2, 1, '2013-4-26');
INSERT INTO AchievementToUserToGame
	VALUES (4, 5, '2013-4-26');
INSERT INTO AchievementToUserToGame
	VALUES (5, 4, '2013-11-14');
INSERT INTO AchievementToUserToGame
	VALUES (6, 5, '2013-12-13');
INSERT INTO AchievementToUserToGame
	VALUES (7, 5, '2014-02-12');

/* Insert a few obscene words (for question 8) */
INSERT INTO RudeWord
	VALUES ('fuck'), ('shit'), ('bastard'), ('bitch');

INSERT INTO RudeWord
	VALUES ('cunt'), ('tosser');

/* Creating friendships */
/* (1) Create requests */
CALL RequestFriendName('AlexParrott', 'ScarlettJo',FALSE);
CALL RequestFriendName('AlexParrott', 'WillWoodhead',FALSE);
CALL RequestFriendName('AlexParrott', 'JamesHamblion',FALSE);
CALL RequestFriendName('BobHope', 'JamesHamblion',FALSE);
CALL RequestFriendName('JamesHamblion', 'BarackObama',FALSE);
CALL RequestFriendName('ScarlettJo', 'GeorgeClooney',FALSE);
CALL RequestFriendName('ScarlettJo', 'WillWoodhead',FALSE);
CALL RequestFriendName('ScarlettJo', 'BradPitt',FALSE);
CALL RequestFriendName('BradPitt', 'BobHope',FALSE);
CALL RequestFriendName('BradPitt', 'GeorgeClooney',FALSE);
CALL RequestFriendName('DavidCameron', 'WillWoodhead',FALSE);
CALL RequestFriendName('DavidCameron', 'AlexParrott',FALSE);
CALL RequestFriendName('AliceInWonderland', 'GeorgeClooney',FALSE);

/* (2) Accept all requests */
UPDATE FriendRequest
SET Response = 'Accepted';

/* (3) Action requests */
CALL ProcessRequest(1);
CALL ProcessRequest(2);
CALL ProcessRequest(3);
CALL ProcessRequest(4);
CALL ProcessRequest(5);
CALL ProcessRequest(6);
CALL ProcessRequest(7);
CALL ProcessRequest(8);
CALL ProcessRequest(9);
CALL ProcessRequest(10);
CALL ProcessRequest(11);
CALL ProcessRequest(12);
CALL ProcessRequest(13);

/* Populate plays & scores relations */
DROP PROCEDURE if exists populatePlays;
DELIMITER //
CREATE PROCEDURE populatePlays()
BEGIN 

	SET @num = 1;
	WHILE @num <= 200 DO
		UPDATE UserToGame
		SET GameInProgress='yes'
		WHERE ID=FLOOR(RAND() * 44) + 1;
		UPDATE UserToGame
		SET GameInProgress='no'
		WHERE ID=FLOOR(RAND() * 44) + 1;
		SET @num = @num + 1;
	END WHILE ;


END //
DELIMITER ;
CALL populatePlays();

DROP PROCEDURE if exists populateScores;
DELIMITER //
CREATE PROCEDURE populateScores()
BEGIN 

	SET @num2 = 1; 
	WHILE @num2 <= 200 DO
		UPDATE UserToGame
		SET LastScore = (FLOOR(RAND() * 100) + 1)
		WHERE ID = (FLOOR(RAND() * 44) + 1);
		SET @num2 = @num2 + 1;
	END WHILE ;
	

END //
DELIMITER ;

CALL populateScores();





