/*
Trigger to automatically update rankInGenre

Doesn't work yet...

AP working on this.
*/

DELIMITER //
CREATE TRIGGER genreRankInsert AFTER
INSERT ON GameToGenre
FOR EACH ROW
	SET @Rank=0;
	UPDATE GameToGenre
		SET RankInGenre = (	
			SELECT @Rank:=@Rank+1 AS Rank,GameToGenre.GameID,GameToGenre.GenreID,OverallRank
			FROM Game,GameToGenre,Genre
			WHERE Game.GameID=GameToGenre.GameID
			AND Genre.GenreID=GameToGenre.GenreID
			AND Genre.GenreID=NEW.GenreID
			ORDER BY OverallRank ASC)
		WHERE GameToGenre.GenreID=NEW.GenreID;//
DELIMITER;

/*
THIS WORKS
SET @Rank=0;
SELECT @Rank:=@Rank+1 AS Rank,GameToGenre.GameID,GameToGenre.GenreID,OverallRank
FROM Game,GameToGenre,Genre
WHERE Game.GameID=GameToGenre.GameID
AND Genre.GenreID=GameToGenre.GenreID
AND Genre.GenreID=4
ORDER BY OverallRank ASC
*/

