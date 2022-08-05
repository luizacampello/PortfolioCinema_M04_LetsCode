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