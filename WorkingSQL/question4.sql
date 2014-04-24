/*question 4 */


SET @rank=0;
SELECT @rank:=@rank+1 AS rank, @rank/COUNT(*)*100 AS top_X_percent, LeaderboardID, UserToGameID, Score, TimeOfScore  
FROM LeaderboardToUserToGame 
WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE UserName = "william_woodhead" AND GameID = 2)
ORDER BY Score DESC LIMIT 0, 1;