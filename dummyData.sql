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

/* FRIENDS DUMMY DATA TO BE ADDED ONCE TRIGGER IS FINAL */

/* GAME INFORMATION */

/* Dummy values for Game */
INSERT INTO Game 
	VALUES(1,'18','./img.jpg','GTA V',NULL,'Rockstar','2013-1-01','A bloody mess','GTA.com',NULL
);
INSERT INTO Game 
	VALUES(2,'18','./img.jpg','The Last of Us',NULL, 'Naughty Dog','2013-12-15','The best game ever','404.net',NULL
);
INSERT INTO Game 
	VALUES(3,'3','./img.jpg','FIFA 14',NULL,'EA','2014-1-1','Football. Note: England suck','fifa.com',NULL
);

INSERT INTO Game
	VALUES (4,'7','./img.jpg','Angry Birds',NULL,'Rovio','2010-03-09','Save the angry birds!','www.angrybirds.com',1.0
); 

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

INSERT INTO UserToGame(UserName,GameID)
	VALUES('AlexParrott',2
);
INSERT INTO UserToGame(UserName,GameID)
	VALUES('AlexParrott',1
);
INSERT INTO UserToGame(UserName,GameID)
	VALUES('JamesHamblion',1
);
INSERT INTO UserToGame(UserName,GameID)
	VALUES('JamesHamblion',4
);
INSERT INTO UserToGame(UserName,GameID)
	VALUES('WillWoodhead',3
);
