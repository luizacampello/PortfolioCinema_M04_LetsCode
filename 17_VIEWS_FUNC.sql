CREATE VIEW vw_portfolio
AS
	SELECT DISTINCT per.CPF, mov.title AS Filme,
	cat.name AS Gênero,
	mov.releaseYear AS [Ano de Lançamento],
	por.score AS Avaliação  
	FROM Person AS per  
	INNER JOIN Portfolio AS por ON per.CPF = por.CPF  
	INNER JOIN Movie AS mov ON mov.id_Movie = por.id_Movie  
	INNER JOIN Category AS cat ON mov.category = cat.id_Category

CREATE VIEW vw_movie
AS  
	 SELECT   
		Movie.title AS 'Título do Filme',
		runtime AS 'Duração (min)',
		releaseYEAR AS 'Ano de Lançamento',
		rating AS 'Classificação',
		Studio.name AS 'Estúdio',
		Language.language AS 'Idioma',
		Category.name AS 'Categoria',
		vw_groupedDirectorsMovie.Directors AS [Dirigido por],
		vw_groupedActorsMovie.Cast AS [Elenco]  
	 FROM Movie  
	 INNER JOIN vw_groupedDirectorsMovie ON Movie.id_Movie = vw_groupedDirectorsMovie.[Movie ID]  
	 INNER JOIN vw_groupedActorsMovie ON Movie.id_Movie = vw_groupedActorsMovie.[Movie ID]  
	 INNER JOIN Studio ON Movie.studio = Studio.id_Studio  
	 INNER JOIN Language ON Movie.originalLanguage = Language.id_Language  
	 INNER JOIN Category ON Movie.category = Category.id_Category

