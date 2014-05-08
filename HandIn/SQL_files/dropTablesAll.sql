/*
This file removes all tables from the database in the correct order (avoiding
any foreign key restrictions).
*/
DROP TABLE MatchRequest;
DROP TABLE MatchToUserToGame;
DROP TABLE Matches;
DROP TABLE AchievementToUserToGame;
DROP TABLE Achievement;
DROP TABLE Scores;
DROP TABLE Plays;
DROP TABLE Leaderboard;
DROP TABLE UserToGame;
DROP TABLE GameImage;
DROP TABLE GameToGenre;
DROP TABLE Genre;
DROP TABLE FriendRequest;
DROP TABLE Game;
DROP TABLE Friends;
DROP TABLE Email;
DROP TABLE UserPrivate;
DROP TABLE UserPublic;
DROP TABLE RudeWord;

SHOW tables;
