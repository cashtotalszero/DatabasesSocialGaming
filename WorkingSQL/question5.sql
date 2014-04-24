
SET @row:=0;
SET @prev:=null;
select genre, name, AverageRating
from
(
  SELECT 
  Genre.Name AS genre,
  Game.Name AS name,
  AverageRating,
  @row:= if(@prev=Genre.Name, @row + 1, 1) as row_number,       
  @prev:= Genre.Name
  FROM Game, Genre, GameToGenre WHERE Game.GameID = GameToGenre.GameID AND Genre.GenreID = GameToGenre.GenreID
  order by Genre.Name, AverageRating desc
) 
AS src
where row_number <= 10
order by genre, AverageRating desc;

