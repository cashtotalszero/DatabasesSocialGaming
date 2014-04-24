/*question 4 */



SET @user = "WillWoodhead";
SET @GameID = 3;

SET @rank=0;
SELECT @rank:=@rank+1 AS rank, @rank/COUNT(*)*100 AS top_X_percent, LeaderboardID, UserToGameID, Score, TimeOfScore  
FROM LeaderboardToUserToGame 
WHERE UserToGameID = (SELECT ID FROM UserToGame WHERE UserName = @user AND GameID = @GameID)
ORDER BY Score DESC LIMIT 0, 1;