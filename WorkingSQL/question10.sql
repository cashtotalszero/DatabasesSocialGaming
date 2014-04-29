/* QUESTION 10 */

/*
Please note that this SQL code is already included in the createTablesAll.sql and
triggers.sql files. They has been separated here for explanation purposes only.

CREATING FRIENDSHIPS:
Friends can only be made by creating a tuple in the FriendRequest table. If the 
other user accepts the request then the FriendResponse attribute must be updated
which fires a trigger to update the Friends tables. This in turn fires a trigger
to create the matching (reverse) friendship in Friends2. To obtain a complete 
Friends list Friends and Friends2 must be merged using a NATURAL JOIN.

INVITING TO GAMES:
An optional GameInvite attribute is also included in the FriendRequest relation.
This can be used at the time of the initial friendship request or at a later date.
*/

CREATE TABLE Friends(
	AccHolder VARCHAR(20) NOT NULL,
	Friend VARCHAR(20) NOT NULL,

	CONSTRAINT pkFriends
		PRIMARY KEY(AccHolder, Friend),
	CONSTRAINT fkUser
		FOREIGN Key(AccHolder)
		REFERENCES UserPublic(UserName),
	CONSTRAINT fkUser2
		FOREIGN Key(Friend)
		REFERENCES UserPublic(UserName)
);

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
		REFERENCES UserPublic(UserName)
);

CREATE TABLE FriendRequest(
	RequestID INT NOT NULL AUTO_INCREMENT,
	Requester VARCHAR(20) NOT NULL,
	Requestee VARCHAR(20) DEFAULT NULL,
	Email VARCHAR(30) DEFAULT NULL,
	FriendResponse ENUM('Accepted','Denied', 'Pending') NOT NULL DEFAULT'Pending',
	GameInvite INT DEFAULT NULL,
	InviteResponse ENUM('Accepted','Denied', 'Pending') NOT NULL DEFAULT'Pending',
	
	CONSTRAINT pkFriendReq
		PRIMARY KEY(RequestID),
	CONSTRAINT fkRequester
		FOREIGN Key(Requester)
		REFERENCES UserPrivate(UserName),
	CONSTRAINT fkRequestee
		FOREIGN Key(Requestee)
		REFERENCES UserPrivate(UserName),
	CONSTRAINT fkReqEmail
		FOREIGN Key(Email)
		REFERENCES UserPrivate(Email),
	CONSTRAINT fkGameInvite
		FOREIGN Key(GameInvite)
		REFERENCES Game(GameID)
);

/* Trigger to create Friendship in Friends relation if FriendRequest is accepted */
DELIMITER $$
CREATE TRIGGER createFriendship 
AFTER UPDATE ON FriendRequest
FOR EACH ROW
BEGIN
	IF (NEW.FriendResponse = 'Accepted')
	THEN BEGIN
		INSERT INTO Friends VALUES (
			NEW.Requester,NEW.Requestee
	);
	END; END IF;
END; $$
DELIMITER ;

/* Trigger creates a matching friendship in Friends2 */
DELIMITER $$
CREATE TRIGGER createMatchingFriend 
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
	INSERT INTO Friends2 VALUES(
		NEW.Friend,NEW.AccHolder);    
END; $$
DELIMITER ;

