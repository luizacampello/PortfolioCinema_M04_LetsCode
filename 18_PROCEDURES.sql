-- Read Procedures

CREATE PROCEDURE sp_portfolioCategory
	@categoryname VARCHAR (50),
	@cpf VARCHAR (11)
AS  
	SELECT DISTINCT por.Filme, por.Avalia��o FROM vw_portfolio AS por  
	WHERE por.cpf = @cpf AND por.G�nero = @categoryname;
GO

CREATE PROCEDURE sp_portfolioScore
	@score INT,
	@cpf VARCHAR (11)   
AS  
	SELECT por.Filme, por.G�nero, por.Avalia��o   
	FROM vw_portfolio AS por  
	WHERE por.cpf = @cpf AND por.Avalia��o = @score  
	ORDER BY LEFT(por.Filme, 3), por.[Ano de Lan�amento] ASC;
GO

CREATE PROCEDURE sp_printPersonInfo
	(@cpf VARCHAR(11))  
AS  
	SELECT vwp.cpf, vwp.Nome, vwp.Idade, vwp.Email  FROM vw_person AS vwp     
    WHERE vwp.cpf = @cpf;
GO

CREATE PROCEDURE sp_print_portfolio
	@cpf VARCHAR(11)  
AS
	SELECT Filme, G�nero, Avalia��o
	FROM vw_portfolio AS port
	WHERE @cpf = port.cpf;
GO

CREATE PROCEDURE sp_searchCategory
	@categoryname VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT DISTINCT mov.[T�tulo do Filme], mov.[Ano de Lan�amento], mov.[Dura��o (min)] FROM vw_movie AS mov  
	INNER JOIN vw_person AS per ON mov.Classifica��o <= per.Idade  
	WHERE per.cpf = @cpf AND @categoryname = mov.Categoria;
GO

CREATE PROCEDURE sp_searchTitle
	@title VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT * FROM fn_ratingFilter(@cpf) AS mov
	WHERE mov.[T�tulo do Filme] LIKE '%' + @title + '%'
	ORDER BY LEFT(mov.[T�tulo do Filme], 3), mov.[Ano de Lan�amento] ASC;
GO

CREATE PROCEDURE sp_searchLanguage
(  
    @cpf VARCHAR(11),
	@Language VARCHAR(30)  
)  
AS
	SELECT DISTINCT mov.*
	FROM vw_movie AS mov
	INNER JOIN vw_person AS per ON mov.Classifica��o <= per.Idade
	WHERE @Language = mov.Idioma AND @cpf = per.cpf;
GO

CREATE PROCEDURE sp_searchRelease
(
	@cpf VARCHAR(11)
)
AS
	SELECT DISTINCT mov.*
	FROM vw_movie AS mov
	INNER JOIN vw_person AS per
	ON mov.Classifica��o <= per.Idade
	WHERE @cpf = per.cpf AND (SELECT YEAR (GETDATE())) - mov.[Ano de Lan�amento] <= 2;
GO

CREATE PROCEDURE sp_searchRuntime
(
	@cpf VARCHAR(11),
	@runtime INT  
)
AS
	SELECT * FROM fn_ratingFilter(@cpf) AS mov
	WHERE mov.[Dura��o (min)] BETWEEN @runtime - 10 AND @runtime + 10
	ORDER BY mov.[Dura��o (min)];
GO


CREATE PROCEDURE sp_searchTitle
	@title VARCHAR (50),
	@cpf VARCHAR (11)
AS
	SELECT * FROM fn_ratingFilter(@cpf) AS mov
	WHERE mov.[T�tulo do Filme] LIKE '%' + @title + '%'
	ORDER BY LEFT(mov.[T�tulo do Filme], 3), mov.[Ano de Lan�amento] ASC;
GO

CREATE PROCEDURE sp_topMovies
	@topMovies INT,
	@cpf VARCHAR (11)
AS
	SELECT TOP (@topMovies) por.Filme, por.G�nero, por.Avalia��o
	FROM vw_portfolio AS por
	WHERE por.cpf = @cpf
	ORDER BY por.Avalia��o DESC;
GO

-- Update Procedures

CREATE PROCEDURE sp_updateEmail
(
	@cpf VARCHAR(11),
	@NewEmail VARCHAR(255)  
)
AS
	UPDATE Person
	SET Person.email = @NewEmail
	WHERE Person.cpf = @cpf;
GO

CREATE PROCEDURE sp_updateMovieScore
(
	@cpf VARCHAR(11),
	@idMovie INT,
	@NewScore SMALLINT  
)
AS
	UPDATE Portfolio
	SET Portfolio.score = @NewScore
	WHERE Portfolio.cpf = @cpf AND Portfolio.id_Movie = @idMovie;
GO

-- Delete Procedures

CREATE PROCEDURE sp_removeRegisterPortfolio  
(  
    @cpf VARCHAR(11),
	@idMovie INT  
)  
AS
	DELETE FROM Portfolio
	WHERE Portfolio.cpf = @cpf AND Portfolio.id_movie = @idMovie;
GO