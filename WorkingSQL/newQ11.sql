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

CALL RequestFriendName('JamesHamblion','ScarlettJo');
CALL RequestFriendName('ScarlettJo','WillWoodhead');

DROP PROCEDURE IF EXISTS AcceptFriendship;
DELIMITER $$
CREATE PROCEDURE AcceptFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(20);

	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID);

	/* Update the friend request to Accepted */
	UPDATE FriendRequest
	SET FriendResponse = 'Accepted'
	WHERE RequestID = reqID;
 
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend1,Friend2);
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend2,Friend1);

END; $$
DELIMITER ;

DROP PROCEDURE IF EXISTS DenyFriendship;
DELIMITER $$
CREATE PROCEDURE DenyFriendship(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(20);

	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID);

	/* Update the friend request to Accepted */
	UPDATE FriendRequest
	SET FriendResponse = 'Denied'
	WHERE RequestID = reqID;
 
	DELETE FROM Friends 
	WHERE AccHolder = Friend1
	AND Friend = Friend2;
	DELETE FROM Friends
	WHERE AccHolder = Friend2
	AND Friend = Friend1;

	/*
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend1,Friend2);
	INSERT INTO Friends(AccHolder,Friend) VALUES (Friend2,Friend1);
	*/
END; $$
DELIMITER ;

CALL AcceptFriendShip(8);

/* Trigger to create Friendship in Friends relation if FriendRequest is accepted 
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

/* Trigger creates a matching friendship in Friends2 
DELIMITER $$
CREATE TRIGGER createMatchingFriend 
AFTER INSERT ON Friends
FOR EACH ROW
BEGIN
	INSERT INTO Friends2 VALUES(
		NEW.Friend,NEW.AccHolder);    
END; $$
DELIMITER ;

/* This query generates a table of all friendships 
SELECT * FROM(
	(SELECT * FROM Friends)
	UNION DISTINCT
	(SELECT * FROM Friends2)) 
AS AllFriends;
*/
