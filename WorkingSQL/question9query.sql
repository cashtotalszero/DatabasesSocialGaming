SELECT Name as game, NOPLastWeek 
FROM Hotlist, Game 
WHERE Hotlist.GameID = Game.GameID;