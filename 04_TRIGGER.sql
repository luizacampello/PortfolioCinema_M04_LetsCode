CREATE TRIGGER tr_personLogs
ON Person
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @command CHAR(6)
    SET @command = CASE
        WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
            THEN 'Update'
        WHEN EXISTS(SELECT * FROM inserted)
            THEN 'Insert'
        WHEN EXISTS(SELECT * FROM deleted)
            THEN 'Delete'
        ELSE NULL
    END
    IF @command = 'Delete'
        INSERT INTO personLogs (command, data_log, username, previous_name, previous_cpf, previous_birthDate, previous_email, previous_password)
        SELECT @command, GETDATE(), USER_NAME(), d.name, d.CPF, d.birthDate, d.email, d.password
        FROM deleted AS d
    ELSE IF @command = 'Insert'
        INSERT INTO personLogs (command, data_log, username, next_name, next_cpf, next_birthDate, next_email, next_password)
        SELECT @command, GETDATE(), USER_NAME(), i.name, i.cpf, i.birthDate, i.email, i.password
        FROM inserted AS i
    ELSE IF @command = 'Update'
        INSERT INTO personLogs (command, data_log, username, previous_name, previous_cpf, previous_birthDate, previous_email, previous_password, next_name, next_cpf, next_birthDate, next_email, next_password)
        SELECT @command, GETDATE(), USER_NAME(), d.name, d.CPF, d.birthDate, d.email, d.password, i.name, i.cpf, i.birthDate, i.email, i.password
        FROM deleted AS d, inserted AS i
END;

CREATE TRIGGER tr_movieLogs
ON Movie
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @command CHAR(6)
    SET @command = CASE
        WHEN EXISTS(SELECT * FROM inserted) AND EXISTS(SELECT * FROM deleted)
            THEN 'Update'
        WHEN EXISTS(SELECT * FROM inserted)
            THEN 'Insert'
        WHEN EXISTS(SELECT * FROM deleted)
            THEN 'Delete'
        ELSE NULL
    END
    IF @command = 'Delete'
        INSERT INTO movieLogs (command, data_log, username,
		previous_id_movie, previous_title, previous_runtime, previous_releaseYear, previous_rating, previous_category, previous_studio, previous_originalLanguage)
        SELECT @command, GETDATE(), USER_NAME(), d.id_movie, d.title, d.runtime, d.releaseYear, d.rating, d.category, d.studio, d.originalLanguage
        FROM deleted AS d
    ELSE IF @command = 'Insert'
        INSERT INTO movieLogs (command, data_log, username, 
		next_id_movie, next_title, next_runtime, next_releaseYear, next_rating, next_category, next_studio, next_originalLanguage)
        SELECT @command, GETDATE(), USER_NAME(), i.id_movie, i.title, i.runtime, i.releaseYear, i.rating, i.category, i.studio, i.originalLanguage
        FROM inserted AS i
    ELSE IF @command = 'Update'
        INSERT INTO movieLogs (command, data_log, username,
		previous_id_movie, previous_title, previous_runtime, previous_releaseYear, previous_rating, previous_category, previous_studio, previous_originalLanguage,
		next_id_movie, next_title, next_runtime, next_releaseYear, next_rating, next_category, next_studio, next_originalLanguage)
        SELECT @command, GETDATE(), USER_NAME(), 
		d.id_movie, d.title, d.runtime, d.releaseYear, d.rating, d.category, d.studio, d.originalLanguage,
		i.id_movie, i.title, i.runtime, i.releaseYear, i.rating, i.category, i.studio, i.originalLanguage
        FROM deleted AS d, inserted  AS i
END;

CREATE TRIGGER tr_scoreLogs
ON Portfolio
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @command NCHAR(6)
	SET @command = CASE
		WHEN EXISTS(SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
				THEN 'Update'
		WHEN EXISTS (SELECT * FROM inserted)
			THEN 'Insert'
		WHEN EXISTS (SELECT * FROM deleted)
			THEN 'Delete'
		ELSE NULL
	END
	
	IF @command = 'Insert'
		INSERT INTO ScoreLogs (command, username, data_log, next_idPortfolio, next_cpf, next_idMovie, next_score)
		SELECT @command, GETDATE(), USER_NAME(), ins.id_portfolio, ins.cpf, ins.id_movie, ins.score
		FROM inserted AS ins
	ELSE IF @command = 'Delete'
		INSERT INTO ScoreLogs (command, username, data_log, previous_idPortfolio, previous_cpf, previous_idMovie, previous_score)
		SELECT  @command, GETDATE(), USER_NAME(), del.id_portfolio, del.cpf, del.id_movie, del.score
		FROM deleted AS del
	ELSE IF @command = 'Update'
		INSERT INTO ScoreLogs (command, username, data_log, previous_idPortfolio, previous_cpf, previous_idMovie, previous_score, next_idPortfolio, next_cpf, next_idMovie, next_score)
		SELECT @command, GETDATE(), USER_NAME(), del.id_portfolio, del.cpf, del.id_movie, del.score, ins.id_portfolio, ins.cpf, ins.id_movie, ins.score
		FROM deleted AS del, inserted AS ins
END;