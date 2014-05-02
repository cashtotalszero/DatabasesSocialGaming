/*
QUESTION 10:

The following procedures can be used to create Friendships via a friendship
request. A friend request can be made by calling the RequestFriendName procedure
providing the UserNames of the requesterand the requested friend:

CALL RequestFriendName('AlexParrott,'WillWoodhead');

Alternatively the requested friend's email can be used by calling the RequestFriendEmail
procedure:

CALL RequestFriendEmail('AlexParrott','Will@Woodhead.com');

To accept a friendship the AcceptFriendship procedure must be called providing
the unique ResquestID, this automatically creates the friendship in the Friends
relation:

CALL AcceptFriendship(4);

Friend requests can be declined and friendships can be deleted by calling the
DenyFriendship procedure (again providing a unique ResquestID):

CALL DenyFriendship(7);

Author: Alex Parrott
*/

/* Procedure creates a Friendship Request via UserName */
DROP PROCEDURE IF EXISTS RequestFriendName;
DELIMITER $$
CREATE PROCEDURE RequestFriendName(IN User VARCHAR(20),reqFriend VARCHAR(20))
BEGIN
	INSERT INTO FriendRequest(Requester,Requestee)
	VALUES(User,reqFriend);
END; $$
DELIMITER ;

/* Alternative procedure creates a Friendship Request via Email address */
DROP PROCEDURE IF EXISTS RequestFriendEmail;
DELIMITER $$
CREATE PROCEDURE RequestFriendEmail(IN User VARCHAR(20),reqEmail VARCHAR(30))
BEGIN
	INSERT INTO FriendRequest(Requester,Email)
	VALUES(User,reqEmail);
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS AcceptFriendship;
DELIMITER $$
CREATE PROCEDURE AcceptFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(30);

	/* Assign UserNames to friends */
	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID);
	/* If Email is used for request then get the UserName */
	IF Friend2 IS NULL
	THEN
		SET Friend2 = (
			SELECT UserName
			FROM UserPrivate
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	/* Update the friend request to Accepted */
	UPDATE FriendRequest
	SET FriendResponse = 'Accepted'
	WHERE RequestID = reqID;
 
	/* Create this friendship in the Friends table */
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend1,Friend2);
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend2,Friend1);
END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS DenyFriendship;
DELIMITER $$
CREATE PROCEDURE DenyFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(30);

	/* Assign UserNames to friends */
	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID
	);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID
	);
	/* If Email is used for request then get the UserName */
	IF Friend2 IS NULL
	THEN
		SET Friend2 = (
			SELECT UserName
			FROM UserPrivate
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	/* Update the friend request to Denied */
	UPDATE FriendRequest
	SET FriendResponse = 'Denied'
	WHERE RequestID = reqID;

	/* Delete this friendship from the Friends table */
	DELETE FROM Friends 
	WHERE AccHolder = Friend1
	AND Friend = Friend2;
	DELETE FROM Friends
	WHERE AccHolder = Friend2
	AND Friend = Friend1;
END; $$
DELIMITER ;
