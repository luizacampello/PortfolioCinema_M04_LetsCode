CREATE VIEW vw_portfolio
AS
	SELECT DISTINCT per.cpf, mov.title AS Filme,
	cat.name AS G�nero,
	mov.releaseYear AS [Ano de Lan�amento],
	por.score AS Avalia��o  
	FROM Person AS per  
	INNER JOIN Portfolio AS por ON per.cpf = por.cpf  
	INNER JOIN Movie AS mov ON mov.id_Movie = por.id_Movie  
	INNER JOIN Category AS cat ON mov.category = cat.id_Category;

CREATE FUNCTION fn_personCategories()
RETURNS TABLE  
AS  
RETURN  
	SELECT name AS FavoriteCategories, pc.cpf FROM Category  
	RIGHT JOIN personCategory AS pc ON pc.id_Category = Category.id_Category  
	WHERE pc.cpf is not null;

CREATE FUNCTION fn_groupedPersonCategory()
RETURNS TABLE  
AS  
RETURN  
	 SELECT cpf,  
		STRING_AGG(FavoriteCategories, ', ') AS [G�neros Favoritos]  
	 FROM fn_personCategories()  
	 GROUP BY cpf;


CREATE FUNCTION fn_movieActors()
RETURNS @actorsMovie Table  
(  
	 [Movie ID] INT,  
	 [Title] VARCHAR(100),  
	 [Artist ID] INT,  
	 [Actor/Actress Name] VARCHAR(100)  
)  
AS  
	BEGIN  
		 INSERT @actorsMovie([Movie ID], [Title], [Artist ID], [Actor/Actress Name])   
		 SELECT mov.id_Movie, mov.title, mact.id_Actor, act.name  
		 FROM Movie AS mov  
		 INNER JOIN movieActor AS mact  
		 ON mov.id_Movie = mact.id_Movie  
		 INNER JOIN Actor AS act  
		 ON mact.id_Actor = act.id_Actor  
		 RETURN  
	END;

CREATE VIEW vw_groupedActorsMovie
AS  
SELECT [Movie ID],  
	[Title],  
	STRING_AGG([Actor/Actress Name], ', ') AS [Cast]  
FROM fn_movieActors()  
GROUP BY [Movie ID], [TITLE];

CREATE FUNCTION fn_movieDirectors()
RETURNS @directorsMovie Table  
(  
	[Movie ID] INT,  
	[Title] VARCHAR(100),  
	[Artist ID] INT,  
	[Directed By] VARCHAR(100)  
)  
AS  
	BEGIN  
		INSERT @directorsMovie([Movie ID], [Title], [Artist ID], [Directed By])   
		SELECT mov.id_Movie, mov.title, mdir.id_Director, dir.name  
		FROM Movie AS mov  
		INNER JOIN MovieDirector AS mdir  
		ON mov.id_Movie= mdir.id_Movie  
		INNER JOIN Director AS dir  
		ON mdir.id_Director = dir.id_Director  
		RETURN  
	END;

CREATE VIEW vw_groupedDirectorsMovie AS  
SELECT [Movie ID],
	[Title], 
	STRING_AGG([Directed By], ', ') AS [Directors]  
FROM fn_movieDirectors()  
GROUP BY [Movie ID], [TITLE];

CREATE VIEW vw_groupedPersonCategory AS  
 SELECT   
   cpf,  
   STRING_AGG(FavoriteCategories, ', ') AS [G�neros Favoritos]  
 FROM fn_personCategories()  
 GROUP BY cpf;

CREATE VIEW vw_movie
AS  
	 SELECT   
		Movie.title AS 'T�tulo do Filme',
		runtime AS 'Dura��o (min)',
		releaseYEAR AS 'Ano de Lan�amento',
		rating AS 'Classifica��o',
		Studio.name AS 'Est�dio',
		Language.language AS 'Idioma',
		Category.name AS 'Categoria',
		vw_groupedDirectorsMovie.Directors AS [Dirigido por],
		vw_groupedActorsMovie.Cast AS [Elenco]  
	 FROM Movie  
	 INNER JOIN vw_groupedDirectorsMovie ON Movie.id_Movie = vw_groupedDirectorsMovie.[Movie ID]  
	 INNER JOIN vw_groupedActorsMovie ON Movie.id_Movie = vw_groupedActorsMovie.[Movie ID]  
	 INNER JOIN Studio ON Movie.studio = Studio.id_Studio  
	 INNER JOIN Language ON Movie.originalLanguage = Language.id_Language  
	 INNER JOIN Category ON Movie.category = Category.id_Category;

CREATE FUNCTION fn_countWatchedCategories()
RETURNS TABLE  
AS  
RETURN  
 SELECT vwp.cpf,
	vwp.G�nero,
	count(vwp.G�nero) AS countC,
	CONCAT(vwp.G�nero,' (', (count(vwp.G�nero)), ')') AS categoryCount 
FROM vw_portfolio as vwp  
GROUP BY vwp.cpf, vwp.G�nero;

CREATE VIEW vw_watchedCategories
AS
	SELECT   
	cwc.cpf,
	STRING_AGG(cwc.categoryCount, ', ') WITHIN GROUP (ORDER BY cwc.countC DESC) AS [G�neros Assistidos]
	FROM fn_countWatchedCategories() AS cwc
	GROUP BY cpf;

CREATE VIEW vw_person
AS  
	SELECT person.cpf,  
	person.name AS Nome,  
	datediff( YY, person.birthDate, getdate()) AS Idade,  
	person.email AS Email,  
	gpc.[G�neros Favoritos],  
	(SELECT COUNT(*) FROM Portfolio AS prt WHERE prt.cpf = person.cpf) AS [Filmes Avaliados],  
	cwc.[G�neros Assistidos]   
	FROM Person AS person  
	INNER JOIN vw_groupedPersonCategory AS gpc ON person.cpf = gpc.cpf  
	INNER JOIN vw_watchedCategories AS cwc ON person.cpf = cwc.cpf;

CREATE FUNCTION fn_ratingFilter
( 
    @cpf VARCHAR (11)  
)  
RETURNS TABLE  
AS  
RETURN  
    SELECT DISTINCT mov.* FROM vw_movie AS mov
	INNER JOIN vw_person AS per ON mov.Classifica��o <= per.Idade
	WHERE per.cpf = @cpf;