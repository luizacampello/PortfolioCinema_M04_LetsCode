-- Movie
ALTER TABLE Movie WITH CHECK ADD CONSTRAINT FK_category FOREIGN KEY(category)
REFERENCES Category (id_category)
ON DELETE CASCADE
ON UPDATE CASCADE


ALTER TABLE Movie WITH CHECK ADD CONSTRAINT FK_language FOREIGN KEY(originalLanguage)
REFERENCES Language (id_language)
ON DELETE CASCADE
ON UPDATE CASCADE


ALTER TABLE Movie WITH CHECK ADD CONSTRAINT FK_studio FOREIGN KEY(studio)
REFERENCES Studio (id_studio)
ON DELETE CASCADE
ON UPDATE CASCADE

--Portfolio
ALTER TABLE Portfolio
ADD CONSTRAINT fk_id_movie FOREIGN KEY (id_movie)
    REFERENCES Movie (id_movie);

ALTER TABLE Portfolio
ADD CONSTRAINT fk_cpf FOREIGN KEY (cpf)
    REFERENCES Person (cpf);

-- MovieActor
ALTER TABLE MovieActor
ADD CONSTRAINT fk_id_movieActor FOREIGN KEY (id_movie)
	REFERENCES Movie (id_movie);

ALTER TABLE MovieActor
ADD CONSTRAINT fk_id_actorMovie FOREIGN KEY (id_actor)
	REFERENCES Actor (id_actor);

-- MovieDirector
ALTER TABLE MovieDirector
ADD CONSTRAINT fk_id_movieDirector FOREIGN KEY (id_movie)
	REFERENCES Movie (id_movie);

ALTER TABLE MovieDirector
ADD CONSTRAINT fk_id_directorMovie FOREIGN KEY (id_director)
	REFERENCES Director (id_director);

-- PersonCategory
ALTER TABLE PersonCategory
ADD CONSTRAINT fk_id_personCategory FOREIGN KEY (cpf)
	REFERENCES Person (cpf);

ALTER TABLE PersonCategory
ADD CONSTRAINT fk_id_categoryPerson FOREIGN KEY (id_category)
	REFERENCES Category (id_category);