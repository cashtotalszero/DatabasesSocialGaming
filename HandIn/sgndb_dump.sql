-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sgndb
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Achievement`
--

DROP TABLE IF EXISTS `Achievement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Achievement` (
  `achievementID` int(11) NOT NULL AUTO_INCREMENT,
  `gameID` int(11) NOT NULL,
  `title` varchar(50) NOT NULL,
  `hiddenFlag` bit(1) NOT NULL DEFAULT b'0',
  `icon` int(11) DEFAULT '0',
  `pointValue` int(11) NOT NULL DEFAULT '1',
  `postDescription` varchar(200) DEFAULT NULL,
  `preDescription` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`achievementID`),
  KEY `fkAchievToGame` (`gameID`),
  CONSTRAINT `fkAchievToGame` FOREIGN KEY (`gameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Achievement`
--

LOCK TABLES `Achievement` WRITE;
/*!40000 ALTER TABLE `Achievement` DISABLE KEYS */;
INSERT INTO `Achievement` VALUES (1,1,'I wish I was a policeman!','\0',0,10,'You stole 100 police cars','Steal 100 police cars'),(2,2,'Up close and personal','\0',0,60,'You killed 80 creatures with a melee weapon','Kill 80 creatures with a melee weapon'),(3,3,'Penalty guru','\0',0,50,'Won 50 games through penalties','Win 50 games through penalties'),(4,3,'Fowler','',0,10,'Received 5 red cards in a game','Get 5 red cards in a game'),(5,4,'Score obsessed','\0',0,30,'Achieved a score of 3000000','Achieve a score of 3000000'),(6,3,'Always Friendly','\0',0,20,'Crossed for a Friend to score','Cross for a Friend to score'),(7,3,'Goalie Scorer','\0',0,20,'Scored with your goal keeper','Score with your goal keeper'),(8,3,'Post and in','',0,20,'Scored off the post or cross bar in a match','Score off the post or cross bar in a match');
/*!40000 ALTER TABLE `Achievement` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AchievementToUserToGame`
--

DROP TABLE IF EXISTS `AchievementToUserToGame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `AchievementToUserToGame` (
  `achievementID` int(11) NOT NULL DEFAULT '0',
  `userToGameID` int(11) NOT NULL DEFAULT '0',
  `dateGained` date NOT NULL,
  PRIMARY KEY (`userToGameID`,`achievementID`),
  CONSTRAINT `fk` FOREIGN KEY (`userToGameID`) REFERENCES `UserToGame` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AchievementToUserToGame`
--

LOCK TABLES `AchievementToUserToGame` WRITE;
/*!40000 ALTER TABLE `AchievementToUserToGame` DISABLE KEYS */;
INSERT INTO `AchievementToUserToGame` VALUES (5,1,'2013-11-14'),(1,3,'2014-01-01'),(2,4,'2013-04-26'),(4,8,'2013-04-26'),(6,8,'2013-12-13'),(7,8,'2014-02-12');
/*!40000 ALTER TABLE `AchievementToUserToGame` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Email`
--

DROP TABLE IF EXISTS `Email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Email` (
  `UserName` varchar(20) NOT NULL,
  `Email` varchar(30) NOT NULL,
  PRIMARY KEY (`UserName`),
  UNIQUE KEY `Email` (`Email`),
  CONSTRAINT `fkUserNameEmail` FOREIGN KEY (`UserName`) REFERENCES `UserPublic` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Email`
--

LOCK TABLES `Email` WRITE;
/*!40000 ALTER TABLE `Email` DISABLE KEYS */;
INSERT INTO `Email` VALUES ('AlexParrott','Alex@Parrott.com'),('AliceInWonderland','Alice@Wonderland.com'),('BarackObama','barack@obama.com'),('BobHope','bob@hope.com'),('BradPitt','Brad@Pitt.com'),('DavidCameron','dave@cameron.com'),('GeorgeClooney','george@clooney.com'),('JamesHamblion','James@Hamblion.com'),('ScarlettJo','Scarlett@Hollywoodbabes.com'),('WillWoodhead','Will@Woodhead.com');
/*!40000 ALTER TABLE `Email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `FriendRequest`
--

DROP TABLE IF EXISTS `FriendRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `FriendRequest` (
  `RequestID` int(11) NOT NULL AUTO_INCREMENT,
  `Requester` varchar(20) NOT NULL,
  `Requestee` varchar(20) DEFAULT NULL,
  `Email` varchar(30) DEFAULT NULL,
  `Response` enum('Pending','Accepted','Declined','Completed') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`RequestID`),
  KEY `fkRequester` (`Requester`),
  KEY `fkRequestee` (`Requestee`),
  KEY `fkReqEmail` (`Email`),
  CONSTRAINT `fkRequester` FOREIGN KEY (`Requester`) REFERENCES `UserPrivate` (`UserName`),
  CONSTRAINT `fkRequestee` FOREIGN KEY (`Requestee`) REFERENCES `UserPrivate` (`UserName`),
  CONSTRAINT `fkReqEmail` FOREIGN KEY (`Email`) REFERENCES `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `FriendRequest`
--

LOCK TABLES `FriendRequest` WRITE;
/*!40000 ALTER TABLE `FriendRequest` DISABLE KEYS */;
INSERT INTO `FriendRequest` VALUES (13,'AliceInWonderland','GeorgeClooney',NULL,'Completed');
/*!40000 ALTER TABLE `FriendRequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Friends`
--

DROP TABLE IF EXISTS `Friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Friends` (
  `AccHolder` varchar(20) NOT NULL,
  `Friend` varchar(20) NOT NULL,
  PRIMARY KEY (`AccHolder`,`Friend`),
  KEY `fkUser2` (`Friend`),
  CONSTRAINT `fkUser` FOREIGN KEY (`AccHolder`) REFERENCES `UserPublic` (`UserName`),
  CONSTRAINT `fkUser2` FOREIGN KEY (`Friend`) REFERENCES `UserPublic` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Friends`
--

LOCK TABLES `Friends` WRITE;
/*!40000 ALTER TABLE `Friends` DISABLE KEYS */;
INSERT INTO `Friends` VALUES ('DavidCameron','AlexParrott'),('JamesHamblion','AlexParrott'),('ScarlettJo','AlexParrott'),('WillWoodhead','AlexParrott'),('GeorgeClooney','AliceInWonderland'),('JamesHamblion','BarackObama'),('BradPitt','BobHope'),('JamesHamblion','BobHope'),('BobHope','BradPitt'),('GeorgeClooney','BradPitt'),('ScarlettJo','BradPitt'),('AlexParrott','DavidCameron'),('WillWoodhead','DavidCameron'),('AliceInWonderland','GeorgeClooney'),('BradPitt','GeorgeClooney'),('ScarlettJo','GeorgeClooney'),('AlexParrott','JamesHamblion'),('BarackObama','JamesHamblion'),('BobHope','JamesHamblion'),('AlexParrott','ScarlettJo'),('BradPitt','ScarlettJo'),('GeorgeClooney','ScarlettJo'),('WillWoodhead','ScarlettJo'),('AlexParrott','WillWoodhead'),('DavidCameron','WillWoodhead'),('ScarlettJo','WillWoodhead');
/*!40000 ALTER TABLE `Friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Game`
--

DROP TABLE IF EXISTS `Game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Game` (
  `GameID` int(11) NOT NULL AUTO_INCREMENT,
  `AgeRating` enum('3','7','12','16','18') NOT NULL,
  `DefaultImage` varchar(50) NOT NULL,
  `Name` varchar(30) NOT NULL,
  `AverageRating` float DEFAULT NULL,
  `NoOfRatings` int(11) DEFAULT NULL,
  `Publisher` varchar(20) NOT NULL,
  `ScoreFormat` varchar(20) NOT NULL DEFAULT 'points',
  `SortOrder` enum('asc','desc') NOT NULL DEFAULT 'desc',
  `ReleaseDate` date NOT NULL,
  `TextDescription` varchar(50) NOT NULL,
  `Url` varchar(100) DEFAULT NULL,
  `Version` decimal(4,2) DEFAULT '1.00',
  `MaxScore` int(11) DEFAULT NULL,
  `MinScore` int(11) DEFAULT NULL,
  PRIMARY KEY (`GameID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Game`
--

LOCK TABLES `Game` WRITE;
/*!40000 ALTER TABLE `Game` DISABLE KEYS */;
INSERT INTO `Game` VALUES (1,'18','./img.jpg','GTA V',5.68,10,'Rockstar','points','desc','2013-01-01','A bloody mess','GTA.com',1.00,1000,1),(2,'18','./img.jpg','The Last of Us',NULL,3,'Naughty Dog','points','desc','2013-12-15','The best game ever','404.net',1.00,1000,50),(3,'3','./img.jpg','FIFA 14',NULL,3,'EA','points','desc','2014-01-01','Football. Note: England suck','fifa.com',1.00,1000,0),(4,'7','./img.jpg','Angry Birds',NULL,3,'Rovio','points','desc','2010-03-09','Save the angry birds!','www.angrybirds.com',1.00,1000,1),(5,'12','./img.jpg','mission Impossible',NULL,4,'EA','points','desc','2012-04-04','Ethan Hunt','MI.com',1.00,1000,1),(6,'12','./img.jpg','James Bond',NULL,2,'Naughty Dog','points','desc','2014-01-02','Martini','JB.net',1.00,10000,1),(7,'3','./img.jpg','Crash Bandicoot',NULL,3,'EA','points','desc','2005-10-10','crazy bandicoot','cxb.com',1.00,1000,0),(8,'7','./img.jpg','2048',NULL,3,'makers','points','desc','2014-03-09','get the 2048 tile!','www.2048.com',1.00,10000,1),(9,'18','./img.jpg','Bike Runner',NULL,2,'Rockstar','points','desc','2013-01-01','drive a bike','bike.com',1.00,10000,1),(10,'18','./img.jpg','COD4',NULL,3,'COD','points','desc','2013-12-18','The best game ever 2','COD.net',1.00,1000000,0),(11,'3','./img.jpg','Black ops',NULL,2,'EA','points','desc','2013-12-12','first person shooter','cool.com',1.00,1000,0),(12,'7','./img.jpg','mash up',NULL,2,'mash','points','desc','2009-03-09','mash the potato','www.mashup.com',1.00,1000,1),(13,'18','./img.jpg','carrot peel',NULL,1,'carrot','points','desc','2013-08-09','peel the carrots','peeler.com',1.00,10000,1),(14,'18','./img.jpg','bin throw',NULL,3,'Naughty Dog','points','desc','2013-07-07','throw paper into the bin','binthrow.net',1.00,1000,0),(15,'3','./img.jpg','skyroads',NULL,1,'EA','points','desc','2001-01-01','drive the sky roads','skyroads.com',1.00,1000,0),(16,'7','./img.jpg','flick men',NULL,2,'Rovio','points','desc','2010-04-11','flick all the men','www.flickmen.com',1.00,10000,1);
/*!40000 ALTER TABLE `Game` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER Game_after_insert 
AFTER INSERT ON Game
FOR EACH ROW
BEGIN 
	
	INSERT INTO Leaderboard (GameID, IsDefault, SortOrder)
	VALUES (
		(SELECT GameID 
		FROM Game 
		WHERE Game.GameID = NEW.GameID), 1, (
			SELECT SortOrder 
			FROM Game 
			WHERE Game.GameID = NEW.GameID)
	);
	INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			NEW.GameID, 
			(SELECT SortOrder FROM Game WHERE GameID = NEW.GameID),
			'1_week'
		);
		INSERT INTO Leaderboard (GameID, SortOrder, TimePeriod)
		VALUES (
			NEW.GameID, 
			(SELECT SortOrder FROM Game WHERE GameID = NEW.GameID),
			'1_day'
		);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `GameImage`
--

DROP TABLE IF EXISTS `GameImage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GameImage` (
  `GameImageID` int(11) NOT NULL,
  `GameID` int(11) NOT NULL,
  `FilePath` varchar(100) DEFAULT NULL,
  `DefaultImage` enum('True','False') NOT NULL,
  PRIMARY KEY (`GameImageID`),
  KEY `fkGameID2` (`GameID`),
  CONSTRAINT `fkGameID2` FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GameImage`
--

LOCK TABLES `GameImage` WRITE;
/*!40000 ALTER TABLE `GameImage` DISABLE KEYS */;
/*!40000 ALTER TABLE `GameImage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GameToGenre`
--

DROP TABLE IF EXISTS `GameToGenre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GameToGenre` (
  `GameID` int(11) NOT NULL,
  `GenreID` int(11) NOT NULL,
  PRIMARY KEY (`GameID`,`GenreID`),
  KEY `fkGenreID` (`GenreID`),
  CONSTRAINT `fkGameID` FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`),
  CONSTRAINT `fkGenreID` FOREIGN KEY (`GenreID`) REFERENCES `Genre` (`GenreID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GameToGenre`
--

LOCK TABLES `GameToGenre` WRITE;
/*!40000 ALTER TABLE `GameToGenre` DISABLE KEYS */;
INSERT INTO `GameToGenre` VALUES (2,1),(7,1),(13,1),(15,1),(1,2),(2,2),(5,2),(8,2),(11,2),(14,2),(16,2),(2,3),(3,3),(9,3),(1,4),(3,4),(4,4),(6,4),(10,4),(12,4);
/*!40000 ALTER TABLE `GameToGenre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genre`
--

DROP TABLE IF EXISTS `Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Genre` (
  `GenreID` int(11) NOT NULL,
  `Name` varchar(20) NOT NULL,
  PRIMARY KEY (`GenreID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
INSERT INTO `Genre` VALUES (1,'Horror'),(2,'Adventure'),(3,'Sport'),(4,'Mutliplayer');
/*!40000 ALTER TABLE `Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Leaderboard`
--

DROP TABLE IF EXISTS `Leaderboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Leaderboard` (
  `LeaderboardID` int(11) NOT NULL AUTO_INCREMENT,
  `GameID` int(11) NOT NULL,
  `SortOrder` enum('asc','desc') NOT NULL DEFAULT 'desc',
  `TimePeriod` enum('forever','1_year','1_week','1_day') NOT NULL DEFAULT 'forever',
  `IsDefault` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`LeaderboardID`),
  KEY `fk_ldbd_GameID` (`GameID`),
  CONSTRAINT `fk_ldbd_GameID` FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Leaderboard`
--

LOCK TABLES `Leaderboard` WRITE;
/*!40000 ALTER TABLE `Leaderboard` DISABLE KEYS */;
INSERT INTO `Leaderboard` VALUES (1,1,'desc','forever',1),(2,1,'desc','1_week',0),(3,1,'desc','1_day',0),(4,2,'desc','forever',1),(5,2,'desc','1_week',0),(6,2,'desc','1_day',0),(7,3,'desc','forever',1),(8,3,'desc','1_week',0),(9,3,'desc','1_day',0),(10,4,'desc','forever',1),(11,4,'desc','1_week',0),(12,4,'desc','1_day',0),(13,5,'desc','forever',1),(14,5,'desc','1_week',0),(15,5,'desc','1_day',0),(16,6,'desc','forever',1),(17,6,'desc','1_week',0),(18,6,'desc','1_day',0),(19,7,'desc','forever',1),(20,7,'desc','1_week',0),(21,7,'desc','1_day',0),(22,8,'desc','forever',1),(23,8,'desc','1_week',0),(24,8,'desc','1_day',0),(25,9,'desc','forever',1),(26,9,'desc','1_week',0),(27,9,'desc','1_day',0),(28,10,'desc','forever',1),(29,10,'desc','1_week',0),(30,10,'desc','1_day',0),(31,11,'desc','forever',1),(32,11,'desc','1_week',0),(33,11,'desc','1_day',0),(34,12,'desc','forever',1),(35,12,'desc','1_week',0),(36,12,'desc','1_day',0),(37,13,'desc','forever',1),(38,13,'desc','1_week',0),(39,13,'desc','1_day',0),(40,14,'desc','forever',1),(41,14,'desc','1_week',0),(42,14,'desc','1_day',0),(43,15,'desc','forever',1),(44,15,'desc','1_week',0),(45,15,'desc','1_day',0),(46,16,'desc','forever',1),(47,16,'desc','1_week',0),(48,16,'desc','1_day',0);
/*!40000 ALTER TABLE `Leaderboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MatchRequest`
--

DROP TABLE IF EXISTS `MatchRequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MatchRequest` (
  `MatchRequestID` int(11) NOT NULL AUTO_INCREMENT,
  `SendingUTG` int(11) NOT NULL,
  `ReceivingUTG` int(11) NOT NULL,
  `MatchID` int(11) NOT NULL,
  `Response` enum('Accepted','Denied','Pending') NOT NULL DEFAULT 'Pending',
  PRIMARY KEY (`MatchRequestID`),
  KEY `fkmatchrequest` (`SendingUTG`),
  KEY `fkmatchrequest2` (`ReceivingUTG`),
  CONSTRAINT `fkmatchrequest` FOREIGN KEY (`SendingUTG`) REFERENCES `UserToGame` (`ID`),
  CONSTRAINT `fkmatchrequest2` FOREIGN KEY (`ReceivingUTG`) REFERENCES `UserToGame` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MatchRequest`
--

LOCK TABLES `MatchRequest` WRITE;
/*!40000 ALTER TABLE `MatchRequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `MatchRequest` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER matchRequest_after_update 
AFTER UPDATE ON MatchRequest
FOR EACH ROW
BEGIN 
	
	SET @num = (SELECT NoOfPlayer FROM Matches WHERE Matches.MatchID = NEW.MatchID);
	IF NEW.Response = 'Accepted' 
	THEN BEGIN 
		INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
		VALUES(NEW.MatchID, NEW.ReceivingUTG);
		UPDATE Matches 
		SET NoOfPlayer = @num + 1
		WHERE MatchID = New.MatchID;
	END; END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `MatchToUserToGame`
--

DROP TABLE IF EXISTS `MatchToUserToGame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `MatchToUserToGame` (
  `MatchID` int(11) NOT NULL,
  `UserToGameID` int(11) NOT NULL,
  `PlayerStatus` enum('playing','paused','quit') NOT NULL DEFAULT 'playing',
  PRIMARY KEY (`MatchID`,`UserToGameID`),
  KEY `fkmtutg2` (`UserToGameID`),
  CONSTRAINT `fkMTUTG1` FOREIGN KEY (`MatchID`) REFERENCES `Matches` (`MatchID`),
  CONSTRAINT `fkmtutg2` FOREIGN KEY (`UserToGameID`) REFERENCES `UserToGame` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MatchToUserToGame`
--

LOCK TABLES `MatchToUserToGame` WRITE;
/*!40000 ALTER TABLE `MatchToUserToGame` DISABLE KEYS */;
/*!40000 ALTER TABLE `MatchToUserToGame` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER matchtousertogame_after_update 
AFTER UPDATE ON MatchToUserToGame
FOR EACH ROW
BEGIN 
	
	SET @num = (SELECT NoOfPlayer FROM Matches WHERE Matches.MatchID = NEW.MatchID);
	IF NEW.PlayerStatus = 'Quit' 
	THEN BEGIN
		UPDATE Matches
		SET NoOfPlayer =  @num - 1
		WHERE MatchID = NEW.MatchID;
	END; END IF;

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Matches`
--

DROP TABLE IF EXISTS `Matches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Matches` (
  `MatchID` int(11) NOT NULL AUTO_INCREMENT,
  `MatchName` varchar(30) NOT NULL,
  `Initiator` int(11) NOT NULL,
  `MinPlayers` int(11) NOT NULL DEFAULT '2',
  `MaxPlayers` int(11) NOT NULL DEFAULT '2',
  `NoOfPlayer` int(11) NOT NULL DEFAULT '1',
  `Status` enum('not_started','in_play','ended') NOT NULL DEFAULT 'not_started',
  PRIMARY KEY (`MatchID`),
  KEY `fkmatch1` (`Initiator`),
  CONSTRAINT `fkmatch1` FOREIGN KEY (`Initiator`) REFERENCES `UserToGame` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Matches`
--

LOCK TABLES `Matches` WRITE;
/*!40000 ALTER TABLE `Matches` DISABLE KEYS */;
/*!40000 ALTER TABLE `Matches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Plays`
--

DROP TABLE IF EXISTS `Plays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Plays` (
  `PlayID` int(11) NOT NULL AUTO_INCREMENT,
  `GameID` int(11) NOT NULL,
  `UserName` varchar(20) NOT NULL,
  `TimeOfPlay` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`PlayID`)
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Plays`
--

LOCK TABLES `Plays` WRITE;
/*!40000 ALTER TABLE `Plays` DISABLE KEYS */;
INSERT INTO `Plays` VALUES (1,7,'WillWoodhead','2014-05-08 14:41:57'),(2,1,'ScarlettJo','2014-05-08 14:41:57'),(3,10,'ScarlettJo','2014-05-08 14:41:57'),(4,7,'GeorgeClooney','2014-05-08 14:41:57'),(5,1,'GeorgeClooney','2014-05-08 14:41:57'),(6,5,'ScarlettJo','2014-05-08 14:41:57'),(7,10,'GeorgeClooney','2014-05-08 14:41:57'),(8,1,'WillWoodhead','2014-05-08 14:41:57'),(9,2,'DavidCameron','2014-05-08 14:41:57'),(10,7,'BobHope','2014-05-08 14:41:58'),(11,4,'JamesHamblion','2014-05-08 14:41:58'),(12,3,'WillWoodhead','2014-05-08 14:41:58'),(13,2,'ScarlettJo','2014-05-08 14:41:58'),(14,1,'DavidCameron','2014-05-08 14:41:58'),(15,13,'BradPitt','2014-05-08 14:41:58'),(16,5,'BobHope','2014-05-08 14:41:58'),(17,1,'BobHope','2014-05-08 14:41:58'),(18,12,'BradPitt','2014-05-08 14:41:58'),(19,6,'GeorgeClooney','2014-05-08 14:41:58'),(20,1,'BradPitt','2014-05-08 14:41:58'),(21,3,'AlexParrott','2014-05-08 14:41:59'),(22,1,'ScarlettJo','2014-05-08 14:41:59'),(23,16,'AliceInWonderland','2014-05-08 14:41:59'),(24,12,'BobHope','2014-05-08 14:41:59'),(25,7,'WillWoodhead','2014-05-08 14:41:59'),(26,7,'GeorgeClooney','2014-05-08 14:41:59'),(27,2,'JamesHamblion','2014-05-08 14:41:59'),(28,1,'BarackObama','2014-05-08 14:41:59'),(29,1,'BradPitt','2014-05-08 14:41:59'),(30,1,'JamesHamblion','2014-05-08 14:41:59'),(31,4,'DavidCameron','2014-05-08 14:41:59'),(32,9,'GeorgeClooney','2014-05-08 14:41:59'),(33,1,'BobHope','2014-05-08 14:41:59'),(34,12,'BradPitt','2014-05-08 14:41:59'),(35,11,'BradPitt','2014-05-08 14:41:59'),(36,9,'WillWoodhead','2014-05-08 14:41:59'),(37,8,'GeorgeClooney','2014-05-08 14:41:59'),(38,1,'WillWoodhead','2014-05-08 14:41:59'),(39,1,'DavidCameron','2014-05-08 14:42:00'),(40,1,'ScarlettJo','2014-05-08 14:42:00'),(41,3,'DavidCameron','2014-05-08 14:42:00'),(42,5,'DavidCameron','2014-05-08 14:42:00'),(43,9,'GeorgeClooney','2014-05-08 14:42:00'),(44,1,'GeorgeClooney','2014-05-08 14:42:00'),(45,5,'ScarlettJo','2014-05-08 14:42:00'),(46,8,'BobHope','2014-05-08 14:42:00'),(47,16,'AliceInWonderland','2014-05-08 14:42:01'),(48,3,'WillWoodhead','2014-05-08 14:42:01'),(49,6,'GeorgeClooney','2014-05-08 14:42:01'),(50,1,'AlexParrott','2014-05-08 14:42:01'),(51,2,'DavidCameron','2014-05-08 14:42:01'),(52,10,'ScarlettJo','2014-05-08 14:42:01'),(53,8,'AliceInWonderland','2014-05-08 14:42:01'),(54,3,'DavidCameron','2014-05-08 14:42:01'),(55,1,'BarackObama','2014-05-08 14:42:01'),(56,1,'GeorgeClooney','2014-05-08 14:42:02'),(57,3,'AlexParrott','2014-05-08 14:42:02'),(58,3,'WillWoodhead','2014-05-08 14:42:02'),(59,7,'GeorgeClooney','2014-05-08 14:42:02'),(60,1,'JamesHamblion','2014-05-08 14:42:02'),(61,1,'AlexParrott','2014-05-08 14:42:02'),(62,1,'AliceInWonderland','2014-05-08 14:42:02'),(63,8,'GeorgeClooney','2014-05-08 14:42:02'),(64,7,'WillWoodhead','2014-05-08 14:42:03'),(65,1,'GeorgeClooney','2014-05-08 14:42:03'),(66,2,'ScarlettJo','2014-05-08 14:42:03'),(67,1,'DavidCameron','2014-05-08 14:42:03'),(68,14,'AliceInWonderland','2014-05-08 14:42:03'),(69,1,'BarackObama','2014-05-08 14:42:03'),(70,10,'BarackObama','2014-05-08 14:42:03'),(71,14,'BarackObama','2014-05-08 14:42:03'),(72,7,'BobHope','2014-05-08 14:42:03'),(73,1,'AlexParrott','2014-05-08 14:42:03'),(74,7,'GeorgeClooney','2014-05-08 14:42:04'),(75,13,'BradPitt','2014-05-08 14:42:04'),(76,11,'BradPitt','2014-05-08 14:42:04'),(77,1,'DavidCameron','2014-05-08 14:42:04'),(78,5,'ScarlettJo','2014-05-08 14:42:04'),(79,5,'DavidCameron','2014-05-08 14:42:04'),(80,4,'AlexParrott','2014-05-08 14:42:04'),(81,1,'WillWoodhead','2014-05-08 14:42:04'),(82,11,'BradPitt','2014-05-08 14:42:04'),(83,6,'AliceInWonderland','2014-05-08 14:42:04'),(84,8,'AliceInWonderland','2014-05-08 14:42:04'),(85,16,'AliceInWonderland','2014-05-08 14:42:04'),(86,2,'JamesHamblion','2014-05-08 14:42:05'),(87,4,'JamesHamblion','2014-05-08 14:42:05'),(88,10,'BarackObama','2014-05-08 14:42:05'),(89,8,'GeorgeClooney','2014-05-08 14:42:05'),(90,16,'AliceInWonderland','2014-05-08 14:42:05'),(91,1,'JamesHamblion','2014-05-08 14:42:05'),(92,11,'BarackObama','2014-05-08 14:42:05'),(93,6,'GeorgeClooney','2014-05-08 14:42:05'),(94,12,'BobHope','2014-05-08 14:42:05'),(95,5,'BobHope','2014-05-08 14:42:05'),(96,9,'GeorgeClooney','2014-05-08 14:42:05'),(97,1,'AliceInWonderland','2014-05-08 14:42:06'),(98,16,'AliceInWonderland','2014-05-08 14:42:06'),(99,8,'GeorgeClooney','2014-05-08 14:42:06'),(100,8,'BobHope','2014-05-08 14:42:06'),(101,1,'WillWoodhead','2014-05-08 14:42:06'),(102,16,'AliceInWonderland','2014-05-08 14:42:06'),(103,6,'AliceInWonderland','2014-05-08 14:42:06'),(104,1,'AliceInWonderland','2014-05-08 14:42:06'),(105,1,'BradPitt','2014-05-08 14:42:06'),(106,1,'BobHope','2014-05-08 14:42:06'),(107,2,'DavidCameron','2014-05-08 14:42:06'),(108,1,'BarackObama','2014-05-08 14:42:06'),(109,5,'WillWoodhead','2014-05-08 14:42:06'),(110,13,'BradPitt','2014-05-08 14:42:06'),(111,4,'JamesHamblion','2014-05-08 14:42:07'),(112,10,'BarackObama','2014-05-08 14:42:07');
/*!40000 ALTER TABLE `Plays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RudeWord`
--

DROP TABLE IF EXISTS `RudeWord`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `RudeWord` (
  `word` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`word`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RudeWord`
--

LOCK TABLES `RudeWord` WRITE;
/*!40000 ALTER TABLE `RudeWord` DISABLE KEYS */;
INSERT INTO `RudeWord` VALUES ('bastard'),('bitch'),('cunt'),('fuck'),('shit'),('tosser');
/*!40000 ALTER TABLE `RudeWord` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Scores`
--

DROP TABLE IF EXISTS `Scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `Scores` (
  `ScoreID` int(11) NOT NULL AUTO_INCREMENT,
  `UserToGameID` int(11) NOT NULL,
  `Score` int(11) NOT NULL,
  `TimeOfScore` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ScoreID`)
) ENGINE=InnoDB AUTO_INCREMENT=207 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Scores`
--

LOCK TABLES `Scores` WRITE;
/*!40000 ALTER TABLE `Scores` DISABLE KEYS */;
INSERT INTO `Scores` VALUES (1,2,55,'2014-05-08 14:42:07'),(2,21,70,'2014-05-08 14:42:07'),(3,36,52,'2014-05-08 14:42:07'),(4,36,34,'2014-05-08 14:42:07'),(5,14,96,'2014-05-08 14:42:07'),(6,8,5,'2014-05-08 14:42:07'),(7,16,83,'2014-05-08 14:42:07'),(8,27,25,'2014-05-08 14:42:07'),(9,39,69,'2014-05-08 14:42:07'),(10,24,21,'2014-05-08 14:42:07'),(11,9,87,'2014-05-08 14:42:07'),(12,30,20,'2014-05-08 14:42:07'),(13,14,95,'2014-05-08 14:42:07'),(14,42,18,'2014-05-08 14:42:07'),(15,1,22,'2014-05-08 14:42:07'),(16,2,54,'2014-05-08 14:42:07'),(17,40,37,'2014-05-08 14:42:07'),(18,18,27,'2014-05-08 14:42:07'),(19,44,44,'2014-05-08 14:42:07'),(20,33,46,'2014-05-08 14:42:07'),(21,19,26,'2014-05-08 14:42:07'),(22,5,2,'2014-05-08 14:42:07'),(23,40,87,'2014-05-08 14:42:07'),(24,36,41,'2014-05-08 14:42:07'),(25,12,17,'2014-05-08 14:42:07'),(26,29,88,'2014-05-08 14:42:07'),(27,35,60,'2014-05-08 14:42:07'),(28,10,80,'2014-05-08 14:42:07'),(29,27,11,'2014-05-08 14:42:07'),(30,18,82,'2014-05-08 14:42:07'),(31,29,16,'2014-05-08 14:42:07'),(32,36,85,'2014-05-08 14:42:07'),(33,10,66,'2014-05-08 14:42:07'),(34,18,55,'2014-05-08 14:42:07'),(35,22,19,'2014-05-08 14:42:07'),(36,25,92,'2014-05-08 14:42:07'),(37,33,21,'2014-05-08 14:42:08'),(38,24,46,'2014-05-08 14:42:08'),(39,21,27,'2014-05-08 14:42:08'),(40,15,36,'2014-05-08 14:42:08'),(41,29,78,'2014-05-08 14:42:08'),(42,10,61,'2014-05-08 14:42:08'),(43,5,24,'2014-05-08 14:42:08'),(44,42,24,'2014-05-08 14:42:08'),(45,12,69,'2014-05-08 14:42:08'),(46,28,82,'2014-05-08 14:42:08'),(47,12,43,'2014-05-08 14:42:08'),(48,40,99,'2014-05-08 14:42:08'),(49,19,78,'2014-05-08 14:42:08'),(50,4,92,'2014-05-08 14:42:08'),(51,28,37,'2014-05-08 14:42:08'),(52,27,82,'2014-05-08 14:42:08'),(53,21,39,'2014-05-08 14:42:08'),(54,22,34,'2014-05-08 14:42:08'),(55,38,92,'2014-05-08 14:42:08'),(56,30,42,'2014-05-08 14:42:08'),(57,6,79,'2014-05-08 14:42:08'),(58,4,50,'2014-05-08 14:42:08'),(59,6,37,'2014-05-08 14:42:08'),(60,8,15,'2014-05-08 14:42:08'),(61,9,57,'2014-05-08 14:42:08'),(62,32,50,'2014-05-08 14:42:08'),(63,14,45,'2014-05-08 14:42:08'),(64,34,77,'2014-05-08 14:42:08'),(65,3,65,'2014-05-08 14:42:08'),(66,4,79,'2014-05-08 14:42:08'),(67,41,73,'2014-05-08 14:42:08'),(68,3,47,'2014-05-08 14:42:08'),(69,41,19,'2014-05-08 14:42:08'),(70,1,39,'2014-05-08 14:42:08'),(71,32,74,'2014-05-08 14:42:08'),(72,29,79,'2014-05-08 14:42:08'),(73,18,49,'2014-05-08 14:42:08'),(74,25,58,'2014-05-08 14:42:08'),(75,15,20,'2014-05-08 14:42:09'),(76,23,67,'2014-05-08 14:42:09'),(77,37,24,'2014-05-08 14:42:09'),(78,15,49,'2014-05-08 14:42:09'),(79,40,13,'2014-05-08 14:42:09'),(80,33,68,'2014-05-08 14:42:09'),(81,39,95,'2014-05-08 14:42:09'),(82,16,25,'2014-05-08 14:42:09'),(83,2,72,'2014-05-08 14:42:09'),(84,15,5,'2014-05-08 14:42:09'),(85,10,67,'2014-05-08 14:42:09'),(86,13,66,'2014-05-08 14:42:09'),(87,41,69,'2014-05-08 14:42:09'),(88,30,25,'2014-05-08 14:42:09'),(89,18,23,'2014-05-08 14:42:09'),(90,10,90,'2014-05-08 14:42:09'),(91,17,46,'2014-05-08 14:42:09'),(92,35,99,'2014-05-08 14:42:09'),(93,36,22,'2014-05-08 14:42:09'),(94,6,61,'2014-05-08 14:42:09'),(95,11,13,'2014-05-08 14:42:09'),(96,23,34,'2014-05-08 14:42:09'),(97,43,29,'2014-05-08 14:42:09'),(98,13,84,'2014-05-08 14:42:09'),(99,11,6,'2014-05-08 14:42:09'),(100,42,80,'2014-05-08 14:42:09'),(101,20,74,'2014-05-08 14:42:09'),(102,40,93,'2014-05-08 14:42:09'),(103,18,94,'2014-05-08 14:42:09'),(104,9,42,'2014-05-08 14:42:09'),(105,12,86,'2014-05-08 14:42:09'),(106,5,61,'2014-05-08 14:42:09'),(107,18,56,'2014-05-08 14:42:09'),(108,15,59,'2014-05-08 14:42:09'),(109,1,59,'2014-05-08 14:42:09'),(110,11,74,'2014-05-08 14:42:09'),(111,33,27,'2014-05-08 14:42:09'),(112,13,50,'2014-05-08 14:42:09'),(113,34,28,'2014-05-08 14:42:10'),(114,16,40,'2014-05-08 14:42:10'),(115,32,66,'2014-05-08 14:42:10'),(116,3,94,'2014-05-08 14:42:10'),(117,11,65,'2014-05-08 14:42:10'),(118,5,100,'2014-05-08 14:42:10'),(119,14,36,'2014-05-08 14:42:10'),(120,8,10,'2014-05-08 14:42:10'),(121,25,10,'2014-05-08 14:42:10'),(122,11,45,'2014-05-08 14:42:10'),(123,37,68,'2014-05-08 14:42:10'),(124,16,100,'2014-05-08 14:42:10'),(125,26,97,'2014-05-08 14:42:10'),(126,40,27,'2014-05-08 14:42:10'),(127,10,36,'2014-05-08 14:42:10'),(128,13,83,'2014-05-08 14:42:10'),(129,18,40,'2014-05-08 14:42:10'),(130,29,99,'2014-05-08 14:42:10'),(131,1,36,'2014-05-08 14:42:10'),(132,9,89,'2014-05-08 14:42:10'),(133,19,44,'2014-05-08 14:42:10'),(134,31,88,'2014-05-08 14:42:10'),(135,5,59,'2014-05-08 14:42:10'),(136,31,50,'2014-05-08 14:42:10'),(137,29,95,'2014-05-08 14:42:10'),(138,24,57,'2014-05-08 14:42:10'),(139,43,76,'2014-05-08 14:42:10'),(140,5,28,'2014-05-08 14:42:10'),(141,19,29,'2014-05-08 14:42:10'),(142,6,17,'2014-05-08 14:42:10'),(143,10,86,'2014-05-08 14:42:10'),(144,40,38,'2014-05-08 14:42:10'),(145,30,54,'2014-05-08 14:42:10'),(146,32,62,'2014-05-08 14:42:10'),(147,3,46,'2014-05-08 14:42:10'),(148,20,53,'2014-05-08 14:42:10'),(149,44,71,'2014-05-08 14:42:10'),(150,1,15,'2014-05-08 14:42:11'),(151,35,73,'2014-05-08 14:42:11'),(152,31,73,'2014-05-08 14:42:11'),(153,14,35,'2014-05-08 14:42:11'),(154,29,55,'2014-05-08 14:42:11'),(155,33,24,'2014-05-08 14:42:11'),(156,21,54,'2014-05-08 14:42:11'),(157,38,88,'2014-05-08 14:42:11'),(158,1,8,'2014-05-08 14:42:11'),(159,9,27,'2014-05-08 14:42:11'),(160,21,80,'2014-05-08 14:42:11'),(161,12,18,'2014-05-08 14:42:11'),(162,40,70,'2014-05-08 14:42:11'),(163,32,15,'2014-05-08 14:42:11'),(164,4,52,'2014-05-08 14:42:11'),(165,2,100,'2014-05-08 14:42:11'),(166,40,44,'2014-05-08 14:42:12'),(167,41,31,'2014-05-08 14:42:12'),(168,5,1,'2014-05-08 14:42:12'),(169,18,29,'2014-05-08 14:42:12'),(170,3,71,'2014-05-08 14:42:12'),(171,40,99,'2014-05-08 14:42:12'),(172,17,93,'2014-05-08 14:42:12'),(173,21,51,'2014-05-08 14:42:12'),(174,3,3,'2014-05-08 14:42:12'),(175,12,77,'2014-05-08 14:42:12'),(176,23,72,'2014-05-08 14:42:12'),(177,2,24,'2014-05-08 14:42:12'),(178,10,31,'2014-05-08 14:42:12'),(179,34,86,'2014-05-08 14:42:12'),(180,26,2,'2014-05-08 14:42:12'),(181,12,83,'2014-05-08 14:42:12'),(182,9,22,'2014-05-08 14:42:12'),(183,2,11,'2014-05-08 14:42:12'),(184,33,85,'2014-05-08 14:42:12'),(185,36,31,'2014-05-08 14:42:12'),(186,5,39,'2014-05-08 14:42:12'),(187,30,50,'2014-05-08 14:42:12'),(188,23,77,'2014-05-08 14:42:12'),(189,20,32,'2014-05-08 14:42:12'),(190,6,68,'2014-05-08 14:42:12'),(191,34,16,'2014-05-08 14:42:12'),(192,16,45,'2014-05-08 14:42:12'),(193,8,75,'2014-05-08 14:42:12'),(194,15,61,'2014-05-08 14:42:12'),(195,17,81,'2014-05-08 14:42:12'),(196,16,13,'2014-05-08 14:42:12'),(197,28,44,'2014-05-08 14:42:12'),(198,14,47,'2014-05-08 14:42:12'),(199,27,85,'2014-05-08 14:42:12'),(200,42,9,'2014-05-08 14:42:12'),(201,42,89,'2014-05-08 14:42:12'),(202,12,11,'2014-05-08 14:42:12'),(203,22,62,'2014-05-08 14:42:12'),(204,26,91,'2014-05-08 14:42:12'),(205,7,38,'2014-05-08 14:42:12'),(206,38,16,'2014-05-08 14:42:12');
/*!40000 ALTER TABLE `Scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserPrivate`
--

DROP TABLE IF EXISTS `UserPrivate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserPrivate` (
  `UserName` varchar(20) NOT NULL,
  `Password` varchar(20) NOT NULL,
  `FirstName` varchar(20) NOT NULL,
  `LastName` varchar(20) NOT NULL,
  PRIMARY KEY (`UserName`),
  CONSTRAINT `fkUserName` FOREIGN KEY (`UserName`) REFERENCES `UserPublic` (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserPrivate`
--

LOCK TABLES `UserPrivate` WRITE;
/*!40000 ALTER TABLE `UserPrivate` DISABLE KEYS */;
INSERT INTO `UserPrivate` VALUES ('AlexParrott','12343','Alex','Parrott'),('AliceInWonderland','maaaaaad75','Alice','Alice'),('BarackObama','JAMES!','Barack','Obama'),('BobHope','12343','Bob','Hope'),('BradPitt','maaaaaad75','Brad','Pitt'),('DavidCameron','password','Dave','Cameron'),('GeorgeClooney','???','George','Clooney'),('JamesHamblion','JAMES!','James','Hamblion'),('ScarlettJo','???','Scarlett','Johansson'),('WillWoodhead','password','Will','Woodhead');
/*!40000 ALTER TABLE `UserPrivate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserPublic`
--

DROP TABLE IF EXISTS `UserPublic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserPublic` (
  `UserName` varchar(20) NOT NULL,
  `Avatar` varchar(50) NOT NULL,
  `CreationDate` date NOT NULL,
  `AccountStatus` enum('Online','Offline','Locked') NOT NULL DEFAULT 'Offline',
  `LastLogin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UserStatus` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`UserName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserPublic`
--

LOCK TABLES `UserPublic` WRITE;
/*!40000 ALTER TABLE `UserPublic` DISABLE KEYS */;
INSERT INTO `UserPublic` VALUES ('AlexParrott','./avatar.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am logged in!'),('AliceInWonderland','./avatar.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in'),('BarackObama','./avatar4.jpg','2014-05-08','Online','2014-05-08 14:41:50','logged in'),('BobHope','./avatar3.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am logged in!'),('BradPitt','./avatar7.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in'),('DavidCameron','./avatar5.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in'),('GeorgeClooney','./avatar6.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in'),('JamesHamblion','./avatar1.jpg','2014-05-08','Offline','2014-05-08 14:41:50','Not here...'),('ScarlettJo','./avatar2.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in'),('WillWoodhead','./avatar2.jpg','2014-05-08','Online','2014-05-08 14:41:50','I am also logged in');
/*!40000 ALTER TABLE `UserPublic` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER userNameEntryCheck
BEFORE INSERT ON UserPublic
FOR EACH ROW
BEGIN
	SET @usrname = NEW.userName;
	SET @obscene = isUserNameRude(@usrname);
	IF @obscene THEN
		SET NEW.AccountStatus := 'Locked';
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `UserToGame`
--

DROP TABLE IF EXISTS `UserToGame`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `UserToGame` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `UserName` varchar(20) NOT NULL,
  `GameID` int(11) NOT NULL,
  `GameInProgress` enum('Yes','No') NOT NULL DEFAULT 'No',
  `InMatch` enum('Yes','No') NOT NULL DEFAULT 'No',
  `HighestScore` int(11) NOT NULL DEFAULT '0',
  `LastScore` int(11) DEFAULT '0',
  `LastPlayDate` date DEFAULT NULL,
  `UserRating` float NOT NULL DEFAULT '0',
  `AgeRating` enum('Unrated','1','2','3','4','5') NOT NULL DEFAULT 'Unrated',
  `Comments` varchar(100) NOT NULL DEFAULT 'No comments',
  PRIMARY KEY (`ID`),
  KEY `fk_U2G_UserName` (`UserName`),
  KEY `fk_U2G_GameID` (`GameID`),
  CONSTRAINT `fk_U2G_UserName` FOREIGN KEY (`UserName`) REFERENCES `UserPublic` (`UserName`),
  CONSTRAINT `fk_U2G_GameID` FOREIGN KEY (`GameID`) REFERENCES `Game` (`GameID`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserToGame`
--

LOCK TABLES `UserToGame` WRITE;
/*!40000 ALTER TABLE `UserToGame` DISABLE KEYS */;
INSERT INTO `UserToGame` VALUES (1,'AlexParrott',4,'No','No',0,8,'2014-12-30',1,'Unrated','No comments'),(2,'AlexParrott',3,'No','No',0,11,'2014-12-31',3,'Unrated','No comments'),(3,'AlexParrott',1,'No','No',0,3,NULL,9.4,'Unrated','No comments'),(4,'JamesHamblion',2,'Yes','No',0,52,'2015-04-15',10,'Unrated','No comments'),(5,'JamesHamblion',4,'Yes','No',0,39,'2015-08-15',55.9,'Unrated','No comments'),(6,'JamesHamblion',1,'Yes','No',0,68,NULL,5.6,'Unrated','No comments'),(7,'WillWoodhead',1,'Yes','No',0,38,NULL,3.4,'Unrated','No comments'),(8,'WillWoodhead',3,'No','No',0,75,NULL,2.5,'Unrated','No comments'),(9,'WillWoodhead',5,'Yes','No',0,22,NULL,3,'Unrated','No comments'),(10,'WillWoodhead',7,'Yes','No',0,31,NULL,5,'Unrated','No comments'),(11,'WillWoodhead',9,'No','No',0,45,NULL,9,'Unrated','No comments'),(12,'ScarlettJo',1,'No','No',0,11,NULL,5,'Unrated','No comments'),(13,'ScarlettJo',2,'Yes','No',0,83,NULL,2.5,'Unrated','No comments'),(14,'ScarlettJo',5,'Yes','No',0,47,NULL,2.5,'Unrated','No comments'),(15,'ScarlettJo',10,'No','No',0,61,NULL,2.5,'Unrated','No comments'),(16,'AliceInWonderland',1,'Yes','No',0,13,NULL,4.2,'Unrated','No comments'),(17,'AliceInWonderland',16,'No','No',0,81,NULL,5.3,'Unrated','No comments'),(18,'AliceInWonderland',14,'Yes','No',0,29,NULL,2.5,'Unrated','No comments'),(19,'AliceInWonderland',8,'No','No',0,29,NULL,9.4,'Unrated','No comments'),(20,'AliceInWonderland',6,'Yes','No',0,32,NULL,3.4,'Unrated','No comments'),(21,'BobHope',1,'Yes','No',0,51,NULL,4.5,'Unrated','No comments'),(22,'BobHope',7,'No','No',0,62,NULL,2.1,'Unrated','No comments'),(23,'BobHope',5,'Yes','No',0,77,NULL,3.5,'Unrated','No comments'),(24,'BobHope',8,'Yes','No',0,57,NULL,3.6,'Unrated','No comments'),(25,'BobHope',12,'Yes','No',0,10,NULL,2.4,'Unrated','No comments'),(26,'BarackObama',1,'Yes','No',0,91,NULL,6.8,'Unrated','No comments'),(27,'BarackObama',10,'Yes','No',0,85,NULL,2.7,'Unrated','No comments'),(28,'BarackObama',11,'No','No',0,44,NULL,9.4,'Unrated','No comments'),(29,'BarackObama',14,'No','No',0,55,NULL,5.6,'Unrated','No comments'),(30,'DavidCameron',1,'Yes','No',0,50,NULL,3.9,'Unrated','No comments'),(31,'DavidCameron',2,'Yes','No',0,73,NULL,4.5,'Unrated','No comments'),(32,'DavidCameron',3,'No','No',0,15,NULL,1.4,'Unrated','No comments'),(33,'DavidCameron',4,'No','No',0,85,NULL,8.2,'Unrated','No comments'),(34,'DavidCameron',5,'Yes','No',0,16,NULL,3.4,'Unrated','No comments'),(35,'GeorgeClooney',1,'Yes','No',0,73,NULL,8,'Unrated','No comments'),(36,'GeorgeClooney',6,'Yes','No',0,31,NULL,9,'Unrated','No comments'),(37,'GeorgeClooney',7,'No','No',0,68,NULL,2.3,'Unrated','No comments'),(38,'GeorgeClooney',8,'Yes','No',0,16,NULL,2.4,'Unrated','No comments'),(39,'GeorgeClooney',9,'Yes','No',0,95,NULL,1.4,'Unrated','No comments'),(40,'GeorgeClooney',10,'No','No',0,99,NULL,5.4,'Unrated','No comments'),(41,'BradPitt',1,'Yes','No',0,31,NULL,6,'Unrated','No comments'),(42,'BradPitt',11,'Yes','No',0,89,NULL,7.5,'Unrated','No comments'),(43,'BradPitt',12,'No','No',0,76,NULL,6.6,'Unrated','No comments'),(44,'BradPitt',13,'Yes','No',0,71,NULL,6.2,'Unrated','No comments'),(45,'BradPitt',14,'No','No',0,0,NULL,6.3,'Unrated','No comments'),(46,'BradPitt',15,'No','No',0,0,NULL,6.4,'Unrated','No comments'),(47,'BradPitt',16,'No','No',0,1,NULL,6.1,'Unrated','No comments');
/*!40000 ALTER TABLE `UserToGame` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER BeforeInsertUserToGame 
BEFORE INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	
	SET NEW.LastScore = (
		SELECT CatchCheaters(NEW.GameID, NEW.LastScore));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER AfterInsertUserToGame 
AFTER INSERT ON UserToGame
FOR EACH ROW 
BEGIN
	
	CALL UpdateAverage(NEW.GameID);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER BeforeUpdateUserToGame 
BEFORE UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	
	SET NEW.LastScore = (
		SELECT CatchCheaters(NEW.GameID, NEW.LastScore));

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER AfterUpdateUserToGame 
AFTER UPDATE ON UserToGame
FOR EACH ROW 
BEGIN
	
	CALL UpdateAverage(NEW.GameID);	
	
	
	IF NEW.GameInProgress = 'yes' 
	AND OLD.GameInProgress = 'no' 
	THEN BEGIN
		INSERT INTO Plays (GameID,UserName,TimeOfPlay)
		VALUES (
			(SELECT GameID 
			FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			(SELECT UserName 
			FROM UserToGame 
			WHERE UserToGame.GameID = NEW.GameID 
			AND UserToGame.UserName = NEW.UserName),
			NOW()
		);
		END; 
	END IF;

	
	IF NEW.LastScore != OLD.LastScore 
	THEN BEGIN 
		INSERT INTO Scores (UserToGameID, Score, TimeOfScore)
		VALUES(
			(SELECT ID 
			FROM UserToGame 
			WHERE UserToGame.ID = NEW.ID),
			(SELECT LastScore 
			FROM UserToGame 
			WHERE UserToGame.ID = NEW.ID),
			NOW()
		);
		END; 
	END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`james`@`localhost`*/ /*!50003 TRIGGER AfterDeleteUserToGame 
AFTER DELETE ON UserToGame
FOR EACH ROW 
BEGIN
	 
	CALL UpdateAverage(OLD.GameID);

	
	IF (SELECT NoOfRatings FROM Game WHERE GameID = OLD.GameID) < 10 
	THEN BEGIN
		UPDATE Game
			SET AverageRating = NULL
			WHERE Game.GameID = OLD.GameID;
	END; END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'sgndb'
--
/*!50003 DROP FUNCTION IF EXISTS `CatchCheaters` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` FUNCTION `CatchCheaters`(game INT,score INT) RETURNS int(11)
BEGIN
	DECLARE checkedScore INT;
	DECLARE minimum INT;
	DECLARE maximum INT;

	
	SELECT score
	INTO checkedScore;
		
	SELECT MinScore 
	INTO minimum	
	FROM Game
	WHERE Game.GameID = game;
	
	SELECT MaxScore
	INTO maximum 
	FROM Game
	WHERE Game.GameID = game;
	
	
	IF(
		score < minimum
		OR 
		score > maximum
	) 
	THEN
		SET checkedScore = minimum;
	END IF;

	
	RETURN checkedScore;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `isUserNameRude` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` FUNCTION `isUserNameRude`(usrname VARCHAR(50)) RETURNS int(11)
BEGIN
	DECLARE done INT DEFAULT FALSE;
	DECLARE obscene INT DEFAULT FALSE;
	DECLARE cmpWord VARCHAR(50);
	DECLARE cur CURSOR FOR SELECT word FROM RudeWord;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	OPEN cur;
	compare_loop: LOOP
		FETCH cur INTO cmpWord;
		
		SET @searchtxt ='%';
		SET @searchtxt = @searchtxt + cmpWord;
		SET @SearchText = @SearchText + '%';
		
	    IF done THEN
			LEAVE compare_loop;
	    END IF;
		 
		SET obscene = STRCMP(@usrname, @searchtxt);
		IF obscene 
		THEN
			SET done := TRUE;
		END IF;
	END LOOP;
	CLOSE cur;
	RETURN obscene;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AchievementsForUserGame` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `AchievementsForUserGame`(usrname VARCHAR(50),gameident INT)
BEGIN
	DECLARE totalAchiev INT;
	DECLARE userGameid INT;
	DECLARE earntAchiev INT;
	DECLARE pointVal INT;

	
	SET userGameid = (
		SELECT ID 
		FROM UserToGame utg
		WHERE utg.UserName = usrname 
		AND utg.gameid = gameident
	);
	
	IF (userGameid IS NOT NULL) 
	THEN
		
		SET totalAchiev = (
			SELECT COUNT(achievementID) 
			FROM Achievement a
			WHERE a.gameid = gameident
		);
		
		SET earntAchiev = (
			SELECT COUNT(achievementID) 
			FROM AchievementToUserToGame a
			WHERE a.userToGameID = userGameid
		);
		IF (earntAchiev IS NULL) 
		THEN 
			SET earntAchiev = 0; 
		END IF; 
		
		SET pointVal = (
			SELECT SUM(PointValue) 
			FROM Achievement a, AchievementToUserToGame b
			WHERE b.userToGameid = userGameid 
			AND a.achievementID = b.achievementID
			AND a.gameid = gameident
		);
		IF (pointVal IS NULL) 
		THEN 
			SET pointVal = 0; 
		END IF; 
		SELECT CONCAT(earntAchiev,' of ',totalAchiev,' achievements ','(',pointVal,' points', ')') AS 'Your_Achievements';
	ELSE
		SELECT 'Error: game not owned by user!' AS 'Your_Achievements';
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CompListGameAchievFriend` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `CompListGameAchievFriend`(usrname VARCHAR(50), frndusrname VARCHAR(50))
BEGIN
	DECLARE ttl VARCHAR(30);
	DECLARE usrA VARCHAR(20);
	DECLARE usrpointsA VARCHAR(20);
	DECLARE usrB VARCHAR(20);
	DECLARE usrpointsB VARCHAR(20);
	DECLARE done INT DEFAULT FALSE;
	
	DECLARE cur CURSOR FOR
	
		SELECT query1.GameTitle, User_A, User_A_Points, User_B, User_B_Points
		FROM
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points
				 FROM
					(SELECT ID, User_A, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_A, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = usrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				 ON x.achievementID = y.achievementID
				 GROUP BY ID
				 ORDER BY x.achievementID DESC) query1 
			LEFT OUTER JOIN
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points
				FROM
					(SELECT ID, User_B, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_B, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = frndusrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				ON x.achievementID = y.achievementID
				GROUP BY ID
				ORDER BY x.achievementID DESC) query2
			ON query1.GameTitle = query2.GameTitle 
			
		UNION
		
		SELECT query2.GameTitle, User_A, User_A_Points, User_B, User_B_Points
		FROM
				(SELECT ID, User_A, GameTitle, SUM(PointValue) AS User_A_Points
				 FROM
					(SELECT ID, User_A, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_A, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = usrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				 ON x.achievementID = y.achievementID
				 GROUP BY ID
				 ORDER BY x.achievementID DESC) query1 
			RIGHT OUTER JOIN
				(SELECT ID, User_B, GameTitle, SUM(PointValue) AS User_B_Points
				FROM
					(SELECT ID, User_B, GameTitle, achievementID 
					 FROM
						(SELECT ID, UserName AS User_B, name As GameTitle
						FROM UserToGame u, Game g
						WHERE u.UserName = frndusrname AND g.gameid = u.gameid) ug
					 LEFT OUTER JOIN
						AchievementToUserToGame atug
					 ON ug.ID = atug.userToGameID) x
				  LEFT OUTER JOIN 
					Achievement y
				ON x.achievementID = y.achievementID
				GROUP BY ID
				ORDER BY x.achievementID DESC) query2
			ON query1.GameTitle = query2.GameTitle;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	
	SET @userAchPoints = CONCAT('CREATE TABLE Compare_List (Game_Title VARCHAR(30), ', 
					 'Your_Achievement_Points VARCHAR(20), ',
					 'Achievement_Points_of_', frndusrname, ' VARCHAR(20), notOwned INT)');
	
	PREPARE stmnt FROM @userAchPoints;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO ttl, usrA, usrpointsA, usrB, usrpointsB;
	    	IF done THEN
			LEAVE pop_loop;
	   	END IF;
	   	
	   	IF ((usrA IS NOT NULL) AND (usrB IS NOT NULL)) THEN
	   		SET @owned = 1; 
			
			IF (usrpointsA IS NULL) THEN
				SET usrpointsA = '0';
			ELSEIF (usrpointsB IS NULL) THEN
				SET usrpointsB = '0';
			END IF;
		ELSE 
			SET @owned = 0; 
			IF (usrA IS NULL AND usrB IS NOT NULL) THEN 
				SET usrpointsA = '';
				SET usrpointsB = '0';
			ELSEIF (usrA IS NOT NULL AND usrB IS NULL) THEN 
				SET usrpointsA = '0';
				SET usrpointsB = '';
			END IF;
	   	END IF;
	   	
	   	INSERT INTO Compare_List 
	   		VALUES (ttl, usrpointsA, usrpointsB, @owned);
	END LOOP;
	CLOSE cur;
	
	SET @resultStr = CONCAT('SELECT Game_Title, Your_Achievement_Points, Achievement_Points_of_',
						frndusrname, ' FROM Compare_List ORDER BY notOwned DESC');
	PREPARE stmnt FROM @resultStr;
	EXECUTE stmnt;
	DEALLOCATE PREPARE stmnt;
	DROP TABLE Compare_List;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateMatch` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `CreateMatch`(UTGID INT, minPlayer INT, maxPlayer INT, matchnm VARCHAR(30))
BEGIN 

INSERT INTO Matches (Initiator, MinPlayers, MaxPlayers, MatchName)
VALUES (UTGID, minPlayer, maxPlayer, matchnm);

INSERT INTO MatchToUserToGame (MatchID, UserToGameID)
VALUES (
	(SELECT MatchID FROM Matches WHERE Initiator=UTGID AND MatchName=matchnm),
	UTGID
	);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `CreateRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `CreateRequest`(IN User VARCHAR(20),reqFriend VARCHAR(30),deleteFlag INT,emailFlag INT)
BEGIN
	
	IF (deleteFlag)
	THEN
		IF (emailFlag)
		THEN
			INSERT INTO FriendRequest(Requester,Email,Response)
			VALUES(User,reqFriend,'Declined');
		ELSE
			INSERT INTO FriendRequest(Requester,Requestee,Response)
			VALUES(User,reqFriend,'Declined');
		END IF;
	
	ELSE
		IF (emailFlag)
		THEN
			INSERT INTO FriendRequest(Requester,Email)
			VALUES(User,reqFriend);
		ELSE
			INSERT INTO FriendRequest(Requester,Requestee)
			VALUES(User,reqFriend);
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetFriendsLeaderboard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `GetFriendsLeaderboard`(UserN VARCHAR(30), GID INT)
BEGIN 

	SET @ScoreFormat = (SELECT ScoreFormat FROM Game WHERE GameID = GID);
	
	DROP TABLE IF EXISTS temp;
	CREATE TABLE temp (
		Username VARCHAR(30), 
		Score INT , 
		TimeOfScore TIMESTAMP
	);

	INSERT INTO temp 
	SELECT Username, Score, TimeOfScore 
	FROM Scores, UserToGame 
	WHERE Scores.UserToGameID = UserToGame.ID 
	AND UserToGame.GameID = GID
	AND Scores.UserToGameID IN (
		SELECT ID 
		FROM UserToGame 
		WHERE UserName IN (
			SELECT Friend 
			FROM Friends
			AS friendtemp 
			WHERE AccHolder = UserN
		 UNION SELECT UserN 
		)
	);

	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') 
	THEN
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS units
		FROM temp 
		ORDER BY Score ASC;
	ELSE
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS units
		FROM temp 
		ORDER BY Score DESC;
	END IF;
	DROP TABLE temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GetLeaderboard` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `GetLeaderboard`(LBID INT)
BEGIN 

	SET @ScoreFormat = (
		SELECT ScoreFormat 
		FROM Game 
		WHERE GameID = (
			SELECT GameID 
			FROM Leaderboard 
			WHERE LeaderboardID = LBID)
	);
	SET @GID = (
		SELECT GameID 
		FROM Leaderboard 
		WHERE LeaderboardID = LBID
	);

	DROP TABLE if exists temp;
	CREATE TABLE temp (
		Username VARCHAR(30), 
		Score INT, 
		TimeOfScore TIMESTAMP
	); 

	IF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_year') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 365 DAY)
		);
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_week') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY)
		);
	ELSEIF ((SELECT TimePeriod FROM Leaderboard WHERE LeaderboardID=LBID) = '1_day') 
	THEN
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID 
			AND  TimeOfScore > DATE(DATE_SUB(NOW(), INTERVAL 1 DAY)
		);
	ELSE
		INSERT INTO temp 
			SELECT Username, Score, TimeOfScore 
			FROM Scores, UserToGame  
			WHERE Scores.UserToGameID = UserToGame.ID 
			AND UserToGame.GameID = @GID; 
	END IF;

	IF ((SELECT SortOrder FROM Leaderboard WHERE LeaderboardID=LBID) = 'asc') 
	THEN
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS Units, TimeOfScore 
		FROM temp 
		ORDER BY Score ASC;
	ELSE
		SELECT  Username, Score, CONCAT(' ', @ScoreFormat) AS Units, TimeOfScore 
		FROM temp 
		ORDER BY Score DESC;
	END IF;

	DROP TABLE temp;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `Hotlist` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `Hotlist`()
BEGIN 
	CREATE TABLE Hotlist (
		Ranking INT NOT NULL AUTO_INCREMENT, 
		GameID INT NOT NULL, 
		NOPLastWeek INT,
		CONSTRAINT pkID PRIMARY KEY(ranking)
	);

	INSERT INTO HotList (GameID, NOPLastWeek)
	SELECT GameID, COUNT(GameID) AS count
	FROM Plays 
	WHERE Plays.TimeOfPlay > DATE(DATE_SUB(NOW(), INTERVAL 7 DAY))
	GROUP BY GameID 
	ORDER BY count DESC;

	SELECT Ranking,Name, NOPLastWeek 
	FROM Hotlist, Game 
	WHERE Hotlist.GameID = Game.GameID ORDER BY NOPLastWeek DESC limit 10;
	DROP TABLE Hotlist;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListGameOwners` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `ListGameOwners`(IN gameVar INT)
BEGIN
	
	SELECT UserPublic.UserName AS Owners 
	FROM Game,UserPublic,UserToGame
	WHERE UserPublic.UserName=UserToGame.UserName 
	AND Game.GameID=UserToGame.GameID 
	AND Game.GameID=gameVar;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ListUserGameAchievements` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `ListUserGameAchievements`(usrname VARCHAR(50),gameident INT)
BEGIN
	DECLARE done INT DEFAULT FALSE;
	
	DECLARE achID INT;
	DECLARE gmid INT;
	DECLARE ttl VARCHAR(50);
	DECLARE hidFlag BIT;
	DECLARE icn INT;
	DECLARE pointVal INT;
	DECLARE poDes VARCHAR(200);
	DECLARE preDes VARCHAR(200);
	DECLARE a INT;
	DECLARE u INT;
	DECLARE dgain DATE;
	
	DECLARE descrpt VARCHAR(200);
	
	DECLARE cur CURSOR FOR 
		SELECT * FROM 
			(SELECT * 
			FROM Achievement x 
			WHERE x.gameid = gameident) a 
			LEFT OUTER JOIN
			(SELECT * 
			FROM AchievementToUserToGame y 
			 WHERE y.userToGameid IN 
				(SELECT ID 
				FROM UserToGame u 
				WHERE u.UserName = usrname 
				AND u.gameID = gameident)) b
			ON a.achievementID = b.achievementID
		WHERE (b.dateGained IS NULL 
		AND a.hiddenFlag = FALSE) 
		OR(a.hiddenFlag = FALSE) 
		OR(b.dateGained IS NOT NULL AND a.hiddenFlag = TRUE)
		ORDER BY b.dateGained DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

	
	CREATE TABLE GameAchievementList (
		Title VARCHAR(50),
		PointValue INT,
		Description VARCHAR(200),
		DateGained DATE
	);
	
	
	OPEN cur;
	pop_loop: LOOP
		FETCH cur INTO achID, gmid, ttl, hidFlag, icn, pointVal, poDes, preDes, a, u, dgain;
	    	IF done 
		THEN
			LEAVE pop_loop; 
	   	END IF;
	   	
	   	IF (dgain IS NULL) 
		THEN 
			SET descrpt = preDes; 
	   	ELSE 
			SET descrpt = poDes;
	   	END IF;
		
		INSERT INTO GameAchievementList
		VALUES (ttl, pointVal, descrpt, dgain);
	END LOOP;
	CLOSE cur;
	
	
	SELECT * FROM GameAchievementList;
	DROP TABLE GameAchievementList;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `MatchRequesting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `MatchRequesting`(Sending INT, Receiving INT, mID INT)
BEGIN 
	INSERT INTO MatchRequest (SendingUTG, ReceivingUTG, MatchID)
	VALUES (Sending, Receiving, mID);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `populatePlays` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `populatePlays`()
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


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `populateScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `populateScores`()
BEGIN 

	SET @num2 = 1; 
	WHILE @num2 <= 200 DO
		UPDATE UserToGame
		SET LastScore = (FLOOR(RAND() * 100) + 1)
		WHERE ID = (FLOOR(RAND() * 44) + 1);
		SET @num2 = @num2 + 1;
	END WHILE ;
	

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ProcessRequest` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `ProcessRequest`(IN reqID INT)
BEGIN
	DECLARE Friend1 VARCHAR(20);
	DECLARE Friend2 VARCHAR(30);

	
	SET Friend1 = (
		SELECT Requester
		FROM FriendRequest
		WHERE RequestID = reqID);
	SET Friend2 = (
		SELECT Requestee
		FROM FriendRequest
		WHERE RequestID = reqID);
	
	IF Friend2 IS NULL
	THEN
		SET Friend2 = (
			SELECT UserName
			FROM Email
			WHERE Email = (
				SELECT Email
				FROM FriendRequest
				WHERE RequestID = reqID)
		);
	END IF;

	
	DELETE FROM FriendRequest
	WHERE Response = 'Completed';

	
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) = 'Declined'
	THEN	
		DELETE FROM Friends 
		WHERE AccHolder = Friend1
		AND Friend = Friend2;
		DELETE FROM Friends
		WHERE AccHolder = Friend2
		AND Friend = Friend1;
	END IF;
	
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) = 'Accepted'
	THEN	
		INSERT INTO Friends(AccHolder,Friend) 
		VALUES (Friend1,Friend2);
		INSERT INTO Friends(AccHolder,Friend) 
		VALUES (Friend2,Friend1);
	END IF;
	
	IF (SELECT Response FROM FriendRequest WHERE RequestID = reqID) <> 'Pending'
	THEN
		UPDATE FriendRequest
		SET Response = 'Completed'
		WHERE RequestID = reqID;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `RankLeaderboards` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `RankLeaderboards`(User VARCHAR(30), GID INT)
BEGIN 
	SET @rank=0;
	
	SET @count = (
		SELECT COUNT(*) 
		FROM Scores 
		WHERE UserToGameID IN (
			SELECT ID 
			FROM UserToGame 
			WHERE GameID = GID)
	); 

	
	IF ((SELECT SortOrder FROM Game WHERE GameID=GID) = 'asc') 
	THEN
		SELECT r AS rank, topXP AS top_x_percent, scor AS BestScore FROM (
			SELECT @rank:=@rank+1 AS r, (@rank/@count)*100 AS topXP ,UserToGameID,Score AS scor  
			FROM Scores 
			WHERE UserToGameID IN (
				SELECT ID 
				FROM UserToGame 
				WHERE GameID = GID)
			ORDER BY Score ASC
		) AS temp WHERE UserToGameID = (
				SELECT ID 
				FROM UserToGame 
				WHERE Username = User 
				AND GameID = GID )
		ORDER BY BestScore ASC LIMIT 1;
	ELSE 
		SELECT r AS rank, topXP AS top_x_percent, scor AS BestScore FROM (
			SELECT @rank:=@rank+1 AS r,(@rank/@count)*100 AS topXP, UserToGameID, Score AS scor
			FROM Scores 
			WHERE UserToGameID IN (
				SELECT ID 
				FROM UserToGame 
				WHERE GameID = GID)
			ORDER BY Score DESC
		) AS temp WHERE UserToGameID = (
				SELECT ID 
				FROM UserToGame 
				WHERE Username = User 
				AND GameID = GID  ) 
		ORDER BY BestScore DESC LIMIT 1;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ShowFriends` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `ShowFriends`(IN User VARCHAR(20))
BEGIN
	
	CREATE TABLE AllFriends(
		SELECT Friend 
		FROM Friends
		WHERE AccHolder = User
	);
	
	
	CREATE TABLE LastDate(	
		SELECT UserName,MAX(LastPlayDate) AS LastPlay 
		FROM UserToGame
		GROUP BY UserName
		ORDER BY LastPlayDate DESC
	);
	
	CREATE TABLE LastGame(
		SELECT UserToGame.UserName,Game.GameID,Name
		FROM UserToGame
		JOIN LastDate ON LastDate.UserName = UserToGame.UserName
		JOIN Game ON UserToGame.GameID = Game.GameID
		WHERE LastPlay = LastPlayDate
	);

	
	SELECT UserName,AccountStatus 
	FROM UserPublic,AllFriends
	WHERE UserPublic.UserName = AllFriends.Friend
	AND AccountStatus = 'Online';

	
	SELECT UserPublic.UserName,AccountStatus,LastLogin,Name AS LastPlayed
	FROM UserPublic,AllFriends,LastGame
	WHERE UserPublic.UserName = AllFriends.Friend
	AND UserPublic.UserName = LastGame.UserName
	AND AccountStatus = 'Offline';

	DROP TABLE AllFriends;
	DROP TABLE LastGame;
	DROP TABLE LastDate;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `ShowStatusScreen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `ShowStatusScreen`(usrname VARCHAR(50))
BEGIN
	
	IF (
		(SELECT COUNT(UserName) 
		FROM UserPublic u 
		WHERE u.UserName = usrname) 
		!= 0)
	THEN
		
		SET @status = (
			SELECT UserStatus 
			FROM UserPublic u
			WHERE u.UserName = usrname
		);
		
		SET @numGames = (
			SELECT COUNT(userName) 
			FROM UserToGame u
			WHERE u.UserName = usrname
		);
		IF (@numGames IS NULL) 
		THEN 
			SET @numGames = 0; 
		END IF; 
		
		SET @numPoints = (
			SELECT SUM(PointValue) 
			FROM Achievement a,AchievementToUserToGame b
			WHERE b.userToGameid IN (
				SELECT ID 
				FROM UserToGame u 
				WHERE u.UserName = usrname)
			AND a.achievementID = b.achievementID
		);
		IF (@numPoints IS NULL) 
		THEN 
			SET @numPoints = 0; 
		END IF; 
		
		SET @numFriends = (
			SELECT COUNT(Friend) FROM Friends f
			WHERE f.AccHolder = usrname
		);
		IF (@numFriends IS NULL) 
		THEN 
			SET @numFriends = 0; 
		END IF; 
		
		
		CREATE TABLE Status_Screen (
			Username VARCHAR(20), 
			Status_Line VARCHAR(100), 
			Number_of_Games_Owned INT, 
			Total_Number_of_Achievement_Points INT, 
			Number_of_Friends INT
		);
		INSERT INTO Status_Screen
		VALUES (usrname,@status,@numGames,@numPoints,@numFriends);
		SELECT * FROM Status_Screen;
		DROP TABLE Status_Screen;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `SuggestFriends` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `SuggestFriends`(IN User VARCHAR(20))
BEGIN
	DECLARE toCheck VARCHAR(20);
	DECLARE done INT DEFAULT FALSE;
	DECLARE cur CURSOR FOR 
		SELECT UserName FROM SuggestedFriends;
	DECLARE CONTINUE HANDLER FOR
		NOT FOUND SET done = TRUE;

	
	CREATE TABLE AllFriends(
		SELECT Friend 
		FROM Friends
		WHERE AccHolder = User
	);
	
	CREATE TABLE AllGames(
		SELECT GameID
		FROM UserToGame
		WHERE UserName = User
	);
	
	CREATE TABLE SuggestedFriends(
		SELECT UserName
		FROM UserPrivate
		WHERE UserName <> User
		AND UserName NOT IN
			(SELECT Friend AS UserName
			FROM AllFriends)
	);
	ALTER TABLE SuggestedFriends
	ADD FriendsInCommon INT;
	ALTER TABLE SuggestedFriends
	ADD GamesInCommon INT;

	
	OPEN cur;
	getFriends: LOOP

		FETCH cur INTO toCheck;
		IF done = TRUE
		THEN
			LEAVE getFriends;
		END IF;	

		
		CREATE TABLE CompareFriend(
			SELECT Friend
			FROM Friends
			WHERE AccHolder = toCheck
		);
		
		UPDATE SuggestedFriends 
		SET FriendsInCommon =(
			SELECT COUNT(CompareFriend.Friend) 
			FROM CompareFriend,AllFriends
			WHERE CompareFriend.Friend = AllFriends.Friend
		)
		WHERE UserName = toCheck;

		
		CREATE TABLE CompareGame(
			SELECT GameID
			FROM UserToGame
			WHERE UserName = toCheck
		);
		
		UPDATE SuggestedFriends 
		SET GamesInCommon =(
			SELECT COUNT(CompareGame.GameID) 
			FROM CompareGame,AllGames
			WHERE CompareGame.GameID = AllGames.GameID
		)
		WHERE UserName = toCheck;
		
		DROP TABLE CompareFriend;
		DROP TABLE CompareGame;
		

	END LOOP getFriends;
	CLOSE cur;

	
	SELECT * FROM SuggestedFriends
	WHERE FriendsInCommon > 1
	OR GamesInCommon > 1;

	DROP TABLE AllFriends;
	DROP TABLE AllGames;
	DROP TABLE SuggestedFriends;	
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `TopTens` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `TopTens`()
BEGIN 
	SET @row:=0;
	SET @prev:=null;
	SELECT genre,name,AverageRating
	FROM (
		SELECT Genre.Name AS genre,
	  	Game.Name AS name,
	  	AverageRating,
	  	@row:= IF(@prev = Genre.Name, @row + 1, 1) AS row_number,       
	  	@prev:= Genre.Name
	  	FROM Game, Genre, GameToGenre 
		WHERE Game.GameID = GameToGenre.GameID 
		AND Genre.GenreID = GameToGenre.GenreID
	  	ORDER BY Genre.Name, AverageRating DESC) 
	AS src
	WHERE row_number <= 10
	ORDER BY genre, AverageRating DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `UpdateAverage` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`james`@`localhost` PROCEDURE `UpdateAverage`(IN updated INT)
BEGIN
	UPDATE Game
		
		SET NoOfRatings = (
			SELECT COUNT(UserRating) 
			FROM UserToGame
			WHERE UserToGame.GameID = Game.GameID
			AND UserToGame.GameID = updated)
		WHERE Game.GameID = updated;

		
		IF (SELECT NoOfRatings FROM Game WHERE GameID = updated) >= 10 
		THEN BEGIN
			UPDATE Game
				SET AverageRating = (
					SELECT AVG(UserRating) 
					FROM UserToGame 
					WHERE UserToGame.GameID = Game.GameID
					AND UserToGame.GameID = updated)
				WHERE Game.GameID = updated;
		END; END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-08 15:50:57
