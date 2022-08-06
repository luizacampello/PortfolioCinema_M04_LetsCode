CREATE TABLE Person (
    cpf VARCHAR(11) NOT NULL,
    name VARCHAR(255) NOT NULL,
    birthDate DATE NOT NULL,
	email VARCHAR(255) NOT NULL,
	password VARCHAR(40) NOT NULL,
	CONSTRAINT PK_CPF PRIMARY KEY (cpf),	
);


CREATE TABLE Category (
	id_category int IDENTITY(1,1) NOT NULL CONSTRAINT PK_id_category PRIMARY KEY (id_Category),
	name VARCHAR(100) NOT NULL UNIQUE,	
);

CREATE TABLE Studio(
	id_studio INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_id_studio PRIMARY KEY (id_studio),
	name VARCHAR(100) NOT NULL UNIQUE,
);

CREATE TABLE Director (
	id_director INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_id_director PRIMARY KEY (id_director),
	name VARCHAR(100) NOT NULL,
);

CREATE TABLE Actor (
	id_actor INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_id_actor PRIMARY KEY (id_actor),
	name VARCHAR(100) NOT NULL,
);

CREATE TABLE Language (
	id_language INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_id_language PRIMARY KEY (id_language),
	language VARCHAR(100) NOT NULL UNIQUE,
);

CREATE TABLE Movie (
		id_movie INT IDENTITY (1,1) NOT NULL CONSTRAINT PK_id_movie PRIMARY KEY (id_movie),
		title VARCHAR (100) NOT NULL,
		runtime INT NOT NULL,
		releaseYear INT NOT NULL,
		rating INT NOT NULL,
		category INT NOT NULL,
		studio INT NOT NULL,
		originalLanguage INT NOT NULL,
);


-- Tabelas Relacionais

CREATE TABLE Portfolio (
	id_portfolio INT IDENTITY NOT NULL CONSTRAINT pk_id_portfolio PRIMARY KEY (id_portfolio),
	id_movie INT NOT NULL,
	cpf VARCHAR(11) NOT NULL,
	score SMALLINT DEFAULT NULL,
	CONSTRAINT check_score CHECK (score >= 0 AND score <= 5)
);

CREATE TABLE MovieActor (
	id_movie INT NOT NULL,
	id_actor INT NOT NULL,
);

CREATE TABLE MovieDirector (
	id_movie INT NOT NULL,
	id_director INT NOT NULL,
);

CREATE TABLE PersonCategory (
	cpf VARCHAR(11) NOT NULL,
	id_category INT NOT NULL,
);

-- Tabelas de logs

CREATE TABLE personLogs
(
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    data_log DATETIME DEFAULT GETDATE() NOT NULL,
    command NCHAR(6) NOT NULL,
    username VARCHAR(100) NOT NULL,
	previous_name VARCHAR(255) NULL,
    previous_cpf VARCHAR(11) NULL,
	previous_birthDate DATE NULL,
    previous_email VARCHAR(255) NULL,
	previous_password VARCHAR(40) NULL,
    next_name VARCHAR(255) NULL, 
    next_cpf VARCHAR(11) NULL,
	next_birthDate DATE NULL,
    next_email VARCHAR(255) NULL,
	next_password VARCHAR(40) NULL
);


---------------------------------------------------------

CREATE TABLE ScoreLogs (
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	data_log DATETIME DEFAULT GETDATE() NOT NULL,
	command NCHAR(6) NOT NULL,
	username VARCHAR (100) NOT NULL,
	previous_idPortfolio INT NULL,
	previous_idMovie INT NULL,
	previous_cpf VARCHAR (11) NULL,
	previous_score SMALLINT NULL,
	next_idPortfolio INT NULL,
	next_idMovie INT NULL,
	next_cpf VARCHAR (11) NULL,
	next_score SMALLINT NULL,
);

SELECT * FROM scoreLogs
DROP TABLE scoreLogs

CREATE TABLE MovieLogs
(
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
    data_log DATETIME DEFAULT GETDATE() NOT NULL,
    command NCHAR(6) NOT NULL,
    username VARCHAR(100) NOT NULL,
	previous_id_movie INT NULL,
	previous_title VARCHAR(100) NULL,
    previous_runtime VARCHAR(40) NULL,
	previous_releaseYear INT NULL,
	previous_rating INT NULL,
	previous_category INT NULL,
    previous_studio INT NULL,
	previous_originalLanguage INT NULL,
	next_id_movie INT NULL,
    next_title VARCHAR(100) NULL, 
    next_runtime INT NULL,
	next_releaseYear INT NULL,
	next_rating INT NULL,
	next_category INT NULL,
    next_studio INT NULL,
	next_originalLanguage INT NULL
);


