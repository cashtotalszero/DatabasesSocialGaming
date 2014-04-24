/* QUESTION 8 */
--Create rude word table to contain obscene/offensive terms.
CREATE TABLE RudeWord (
	word VARCHAR(50),
	CONSTRAINT pkRudeWord
		PRIMARY KEY (word)
);
--Insert a few obscene words
INSERT INTO RudeWord
	VALUES ('fuck'), ('shit'), ('bastard'), ('bitch');
INSERT INTO RudeWord
	VALUES ('cunt'), ('tosser');

/* Setup the TRIGGER on User-Public table*/
DROP TRIGGER userNameEntryCheck;
--delimiter //
CREATE TRIGGER userNameEntryCheck
BEFORE INSERT ON UserPublic
FOR EACH ROW
BEGIN
	SET @usrname = NEW.userName;
	SET @obscene = isUserNameRude(@usrname);
	IF @obscene THEN
		SET NEW.AccountStatus := 'Offline';
	END IF;
END;--//
--delimiter ;

/* Setup the FUNCTION called by the trigger. */
--It compares the username against all rows in the RudeWord table
--A return of true indicates an illegal username, and false if it's acceptable.
DROP FUNCTION isUserNameRude;
--delimiter //
CREATE FUNCTION isUserNameRude(usrname VARCHAR(50))
RETURNS INT
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE obscene INT DEFAULT FALSE;
	DECLARE cmpWord VARCHAR(50);
	DECLARE cur CURSOR FOR SELECT word FROM RudeWord;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN cur;
	compare_loop: LOOP
		FETCH cur INTO cmpWord;
		--Build search text
		SET @searchtxt ='%';
		SET @searchtxt = @searchtxt + cmpWord;
		SET @SearchText = @SearchText + '%';
		--handler check
	    IF done THEN
			LEAVE compare_loop;
	    END IF;
		--Word comparison check (Note STRCMP case insensitive by default)
		SET obscene = STRCMP(@usrname, @searchtxt);
		IF obscene THEN
			SET done := TRUE;
		END IF;
	END LOOP;
	CLOSE cur;
	RETURN obscene;
END;--//
--delimiter ;
