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


/* FRIENDS DUMMY DATA TO BE ADDED ONCE TRIGGER IS FINAL */

/* GAME INFORMATION */

/* Dummy values for Game */
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore, MinScore)
	VALUES('18','./img.jpg','GTA V','Rockstar','2013-1-01','A bloody mess','GTA.com',10,1);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('18','./img.jpg','The Last of Us', 'Naughty Dog','2013-12-15','The best game ever','404.net',100,50);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url,MaxScore, MinScore)
	VALUES('3','./img.jpg','FIFA 14','EA','2014-1-1','Football. Note: England suck','fifa.com', 1000,0);
INSERT INTO Game (AgeRating, DefaultImage, Name, Publisher, ReleaseDate, TextDescription, url, MaxScore)
	VALUES ('7','./img.jpg','Angry Birds','Rovio','2010-03-09','Save the angry birds!','www.angrybirds.com',17);



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

/* USER/GAME LINKING RELATION */

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore)
	VALUES('AlexParrott',2,1,49);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AlexParrott',1,3);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('JamesHamblion',1,10);

INSERT INTO UserToGame(UserName,GameID,UserRating,LastScore)
	VALUES('JamesHamblion',4,55.9,18);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('WillWoodhead',3,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('ScarlettJo',1,2.5);

INSERT INTO UserToGame(UserName,GameID,UserRating)
	VALUES('AliceInWonderland',3,5.5);

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

UPDATE UserToGame
SET GameInProgress='yes'
WHERE ID=1;

UPDATE UserToGame
SET GameInProgress='yes'
WHERE ID=2;

UPDATE UserToGame
SET GameInProgress='yes'
WHERE ID=1;

UPDATE UserToGame
SET LastScore=18
WHERE ID=3;

UPDATE Leaderboard
SET SortOrder='desc'
WHERE LeaderboardID=1;



