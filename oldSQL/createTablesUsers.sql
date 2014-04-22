/* (1) Declaration of UserPublic relation */
CREATE TABLE UserPublic(
	UserName VARCHAR(20) NOT NULL,
	Avatar VARCHAR(50) NOT NULL,
	CreationDate DATE NOT NULL,
	AccountStatus ENUM('Online','Offline') NOT NULL DEFAULT'Offline',
	LastLogin TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UserStatus VARCHAR(100) DEFAULT NULL,

	CONSTRAINT pkUserName
		PRIMARY KEY(UserName));

/* Some dummy values for UserPublic: */
INSERT INTO UserPublic VALUES(
	'AlexParrott','./avatar.jpg',CURDATE(),'Online',NULL,'I am logged in!');
INSERT INTO UserPublic VALUES(
	'JamesHamblion','./avatar1.jpg',CURDATE(),'Offline',NULL,'Not here...');
INSERT INTO UserPublic VALUES(
	'WillWoodhead','./avatar2.jpg',CURDATE(),'Online',NULL,'I am also logged in');

/* (2) Declaration of UserPrivate relation */
CREATE TABLE UserPrivate(
	UserName VARCHAR(20) NOT NULL,
	Password VARCHAR(20) NOT NULL,
	FirstName VARCHAR(20) NOT NULL,
	LastName VARCHAR(20) NOT NULL,
	Email VARCHAR(30) NOT NULL,

	CONSTRAINT pkUserName
		PRIMARY KEY(UserName),
	CONSTRAINT fkUserName
		FOREIGN Key(UserName)
		REFERENCES UserPublic(UserName));

/* Dummy values for UserPrivate: */
INSERT INTO UserPrivate VALUES(
	'AlexParrott','12343','Alex','Parrott','Alex@Parrott.com');
INSERT INTO UserPrivate VALUES(
	'JamesHamblion','JAMES!','James','Hamblion','James@Hamblion.com');
INSERT INTO UserPrivate VALUES(
	'WillWoodhead','password','Will','Woodhead','Will@Woodhead.com');

/* (3) Declaration of Friends2 relation */
CREATE TABLE Friends2(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends2
		PRIMARY KEY(AccHolder,Friend),
	CONSTRAINT fkUser1_1
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2_1
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName));

/* (4) Declaration of Friends relation */
CREATE TABLE Friends(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends
		PRIMARY KEY(AccHolder,Friend),
	CONSTRAINT fkUser1
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName));

/* Trigger puts a matching (reverse) friendship into Friends2 with any insert
into Friends */
delimiter //
CREATE TRIGGER mirrorFriend BEFORE INSERT ON Friends
FOR EACH ROW
BEGIN
	INSERT INTO Friends2 VALUES(
	NEW.Friend,NEW.AccHolder);    
END;//
delimiter ;
