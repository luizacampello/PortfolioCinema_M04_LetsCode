

CREATE PROCEDURE sp_portfolioCategory
	@categoryname VARCHAR (50),
	@cpf VARCHAR (11)
AS  
	SELECT DISTINCT por.Filme, por.Avaliação FROM vw_portfolio AS por  
	WHERE por.CPF = @cpf AND por.Gênero = @categoryname;

CREATE PROCEDURE sp_portfolioScore
	@score INT,
	@cpf VARCHAR (11)   
AS  
	SELECT por.Filme, por.Gênero, por.Avaliação   
	FROM vw_portfolio AS por  
	WHERE por.CPF = @cpf AND por.Avaliação = @score  
	ORDER BY LEFT(por.Filme, 3), por.[Ano de Lançamento] ASC

CREATE PROCEDURE sp_printPersonInfo
	(@Cpf VARCHAR(11))  
AS  
	SELECT vwp.CPF, vwp.Nome, vwp.Idade, vwp.Email  FROM vw_person AS vwp     
    WHERE vwp.CPF = @Cpf

CREATE PROCEDURE sp_print_portfolio
	@Cpf VARCHAR(11)  
AS
	SELECT Filme, Gênero, Avaliação
	FROM vw_portfolio AS port
	WHERE @Cpf = port.CPF

CREATE PROCEDURE sp_removeRegisterPortfolio  
(  
    @Cpf VARCHAR(11),
	@IdMovie INT  
)  
AS
	DELETE FROM Portfolio
	WHERE Portfolio.CPF = @Cpf AND Portfolio.id_Movie = @IdMovie

CREATE PROCEDURE sp_searchCategory
	@categoryname VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT DISTINCT mov.[Título do Filme], mov.[Ano de Lançamento], mov.[Duração (min)] FROM vw_movie AS mov  
	INNER JOIN vw_person AS per ON mov.Classificação <= per.Idade  
	WHERE per.CPF = @cpf AND @categoryname = mov.Categoria;

CREATE PROCEDURE sp_searchTitle
	@title VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT * FROM fn_ratingFilter(@cpf) AS mov
	WHERE mov.[Título do Filme] LIKE '%' + @title + '%'
	ORDER BY LEFT(mov.[Título do Filme], 3), mov.[Ano de Lançamento] ASC

CREATE PROCEDURE sp_searchLanguage
(  
    @Cpf VARCHAR(11),
	@Language VARCHAR(30)  
)  
AS
	SELECT DISTINCT mov.*
	FROM vw_movie AS mov
	INNER JOIN vw_person AS per ON mov.Classificação <= per.Idade
	WHERE @Language = mov.Idioma AND @Cpf = per.CPF

CREATE PROCEDURE sp_searchRelease
(
	@Cpf VARCHAR(11)
)
AS
	SELECT DISTINCT mov.*
	FROM vw_movie AS mov
	INNER JOIN vw_person AS per
	ON mov.Classificação <= per.Idade
	WHERE @Cpf = per.CPF AND (SELECT YEAR (GETDATE())) - mov.[Ano de Lançamento] <= 2

CREATE PROCEDURE sp_searchRuntime
(
	@Cpf VARCHAR(11),
	@Runtime INT  
)
AS
	SELECT DISTINCT mov.*
	FROM vw_movie AS mov
	INNER JOIN vw_person AS per
	ON mov.Classificação <= per.Idade
	WHERE @Cpf = per.CPF AND mov.[Duração (min)] BETWEEN @Runtime - 10 AND @Runtime + 10
	ORDER BY mov.[Duração (min)]

CREATE PROCEDURE sp_searchTitle
	@title VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT * FROM fn_ratingFilter(@cpf) AS mov
	WHERE mov.[Título do Filme] LIKE '%' + @title + '%'
	ORDER BY LEFT(mov.[Título do Filme], 3), mov.[Ano de Lançamento] ASC

CREATE PROCEDURE sp_topMovies
	@topMovies INT,
	@cpf VARCHAR (11)
AS
	SELECT TOP (@topMovies) por.Filme, por.Gênero, por.Avaliação
	FROM vw_portfolio AS por
	WHERE por.CPF = @cpf
	ORDER BY por.Avaliação DESC

CREATE PROCEDURE sp_updateEmail
(
	@Cpf VARCHAR(11),
	@NewEmail VARCHAR(255)  
)
AS
	UPDATE Person
	SET Person.email = @NewEmail
	WHERE Person.CPF = @Cpf

CREATE PROCEDURE sp_updateMovieRating
(
	@Cpf VARCHAR(11),
	@IdMovie INT,
	@NewRating SMALLINT  
)
AS
	UPDATE Portfolio
	SET Portfolio.Rating = @NewRating
	WHERE Portfolio.CPF = @Cpf AND Portfolio.id_Movie = @IdMovie