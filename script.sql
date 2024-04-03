DROP TABLESPACE SQL3_TBS INCLUDING CONTENTS AND DATAFILES;
DROP TABLESPACE SQL3_TempTBS INCLUDING CONTENTS AND DATAFILES;
DROP USER SQL3_BDA CASCADE;

-- Partie 1 Partie I : Relationnel-Objet 

-- B. Creation des TableSpaces et  utilisateur 

-- 2. Creer deux TableSpaces   SQL3_TBS et  SQL3_TempTBS 
--TableSpace
CREATE TABLESPACE SQL3_TBS
DATAFILE 'c:\sql3_tbs.dat' SIZE 50M
AUTOEXTEND ON;
--Temporary Tablespace
CREATE TEMPORARY TABLESPACE SQL3_TempTBS
TEMPFILE 'c:\sql3_Temptbs.dat' SIZE 25M;




-- 3. Creer un utilisateur SQL3 en lui attribuant les deux tablespaces crees precedemment
CREATE USER SQL3_BDA IDENTIFIED BY admin
DEFAULT TABLESPACE SQL3_TBS
TEMPORARY TABLESPACE SQL3_TempTBS
QUOTA UNLIMITED ON SQL3_TBS;


--4. Donner tous les privileges a cet utilisateur.
GRANT ALL PRIVILEGES TO SQL3_BDA;


-- C. Langage de definition de donnees
-- 5. definir tous les types necessaires.


--pour montrer les attributs:
/*
SELECT ATTR_NAME, ATTR_TYPE_NAME, LENGTH, SCALE
FROM USER_TYPE_ATTRS
WHERE TYPE_NAME = 'TCLIENT';
*/

CREATE type tclient;
/
CREATE type temploye;
/
CREATE type tmarque;
/
CREATE type tmodele;
/
CREATE type tvehicule;
/
CREATE type tinterventions;
/
CREATE type tintervenants;
/

CREATE type tset_ref_modele AS TABLE OF ref tmodele;
/
CREATE type tset_ref_vehicule AS TABLE OF ref tvehicule;
/
CREATE type tset_ref_interventions AS TABLE OF ref tinterventions;
/
CREATE type tset_ref_intervenants AS TABLE OF ref tintervenants;
/


CREATE OR REPLACE TYPE tclient AS OBJECT(  
    numclient INTEGER,
    civ VARCHAR2(3), 
    prenomclient VARCHAR2(50), 
    NOMCLIENT VARCHAR2(50), 
    DATENAISSANCE DATE,  
    ADRESSE VARCHAR2(100), 
    TELPROF VARCHAR2(10), 
    TELPRIV VARCHAR2(10), 
    FAX VARCHAR2(10),
    vehicules tset_ref_vehicule
);
/


CREATE OR REPLACE TYPE temploye AS OBJECT(
    numemploye INTEGER,
    nomemploye VARCHAR2(50),
    prenomemploye VARCHAR2(50),
    categorie VARCHAR2(50),
    salaire float,
    intervenants tset_ref_intervenants
);
/



CREATE OR REPLACE TYPE tmarque AS OBJECT(
    NUMMARQUE INTEGER,
    MARQUE VARCHAR2(50),
    PAYS VARCHAR2(50),
    modeles tset_ref_modele
);
/



CREATE OR REPLACE TYPE tmodele AS OBJECT(
    nummodele INTEGER,
    marque REF tmarque,
    modele VARCHAR2(50),
    vehicules tset_ref_vehicule
);
/

CREATE OR REPLACE TYPE tvehicule AS OBJECT(
    NUMVEHICULE INTEGER,
    client REF tclient,
    modele REF tmodele,
    NUMIMMAT VARCHAR2(50),
    ANNEE VARCHAR2(50),
    interventions tset_ref_interventions
);
/

CREATE OR REPLACE TYPE tinterventions AS OBJECT(
    NUMINTERVENTION INTEGER,
    vehicule REF tvehicule,
    TYPEINTERVENTION VARCHAR2(50),
    DATEDEBINTERV DATE,
    DATEFININTERV DATE,
    COUTINTERV float,
    intervenants tset_ref_intervenants
);
/

CREATE OR REPLACE TYPE tintervenants AS OBJECT(
    intervention REF tinterventions,
    employe REF temploye,
    DATEDEBUT DATE,
    DATEFIN DATE
);
/

------------------- Done -------------------------


-- 6 Définir les méthodes permettant de : 

-- pour montrer les methodes d'un type
/*
SELECT OBJECT_NAME, PROCEDURE_NAME
FROM ALL_PROCEDURES
WHERE OBJECT_NAME = 'TEMPLOYE';
*/



-- 6.1 Calculer pour chaque employé, le nombre des interventions effectuées. 
ALTER TYPE temploye
ADD MEMBER FUNCTION calcul_interventions RETURN INTEGER
CASCADE;


-- -- on doit d'abbord creer la table intervenants
-- CREATE OR REPLACE TYPE BODY temploye AS
--     MEMBER FUNCTION calcul_interventions RETURN NUMBER IS
--         nombre_interventions NUMBER;
--     BEGIN
--         SELECT COUNT(*) INTO nombre_interventions
--         FROM INTERVENANTS
--         WHERE NUMEMPLOYE = self.numemploye;
        
--         RETURN nombre_interventions;
--     END calcul_interventions;
-- END;
-- /

--good
CREATE OR REPLACE TYPE BODY temploye AS
    MEMBER FUNCTION calcul_interventions RETURN INTEGER IS
        nombre_interventions INTEGER := 0;
    BEGIN
        FOR i IN 1..self.intervenants.COUNT LOOP
            nombre_interventions := nombre_interventions + 1;
        END LOOP;
        RETURN nombre_interventions;
    END;
END;
/

CREATE OR REPLACE TYPE BODY temploye AS
    MEMBER FUNCTION calcul_interventions RETURN INTEGER IS
        nombre_interventions INTEGER := 0;
    BEGIN
        nombre_interventions := self.intervenants.COUNT;
        RETURN nombre_interventions;
    END;
END;
/

SELECT nomemploye, prenomemploye, e.calcul_interventions() AS nb_interventions
FROM employe e;



-- 6.2 Calculer pour chaque marque, le nombre de modèles. 

ALTER TYPE tmarque
ADD MEMBER FUNCTION calcul_modeles RETURN INTEGER
CASCADE;

--good
CREATE OR REPLACE TYPE BODY tmarque AS
    MEMBER FUNCTION calcul_modeles RETURN INTEGER IS
        nombre_modeles INTEGER := 0;
    BEGIN
        nombre_modeles := self.modeles.COUNT;
        RETURN nombre_modeles;
    END;
END;
/


-- -- on doit d'abbord creer la table modele
-- CREATE OR REPLACE TYPE BODY tmarque AS
--     MEMBER FUNCTION calcul_modeles RETURN NUMBER IS
--         nombre_modeles NUMBER;
--     BEGIN
--         SELECT COUNT(*) INTO nombre_modeles
--         FROM modele
--         WHERE NUMMARQUE = self.nummarque;

--         RETURN nombre_modeles;
--     END;
-- END;
-- /





-- 6.3 Calculer pour chaque modèle, le nombre de véhicules. 

ALTER TYPE tmodele
ADD MEMBER FUNCTION calcul_vehicules RETURN INTEGER
CASCADE;


CREATE OR REPLACE TYPE BODY tmodele AS
    MEMBER FUNCTION calcul_vehicules RETURN INTEGER IS
        nombre_vehicules INTEGER := 0;
    BEGIN
        nombre_vehicules := self.vehicules.COUNT;
        RETURN nombre_vehicules;
    END;
END;
/


-- --has an error
-- CREATE OR REPLACE TYPE BODY tmodele AS
--     MEMBER FUNCTION calcul_vehicules RETURN NUMBER IS
--         nombre_vehicules NUMBER;
--     BEGIN
--         SELECT COUNT(*) INTO nombre_vehicules
--         FROM vehicule
--         WHERE NUMMODELE = self.NUMMODELE;
--         RETURN nombre_vehicules;
--     END calcul_vehicules;
-- END;
-- /

-- 6.4 Lister pour chaque client, ses  véhicules. 

ALTER TYPE tclient
ADD MEMBER FUNCTION lister_vehicules RETURN VARCHAR2
CASCADE;

CREATE OR REPLACE TYPE BODY tclient AS
    MEMBER FUNCTION lister_vehicules RETURN VARCHAR2 IS
        vehicules VARCHAR2(1000);
    BEGIN
        SELECT LISTAGG(NUMVEHICULE, ', ') WITHIN GROUP (ORDER BY NUMVEHICULE) INTO vehicules
        FROM vehicule
        WHERE NUMCLIENT = self.NUMCLIENT;
        RETURN vehicules;
    END lister_vehicules;
END;
/

-- 6.5 Calculer pour chaque marque, son chiffre d’affaire.

ALTER TYPE tmarque
ADD MEMBER FUNCTION calcul_chiffre_affaire RETURN NUMBER
CASCADE;

CREATE OR REPLACE TYPE BODY tmarque AS
    MEMBER FUNCTION calcul_chiffre_affaire RETURN NUMBER IS
        chiffre_affaire NUMBER;
    BEGIN
        SELECT SUM(COUTINTERV) INTO chiffre_affaire
        FROM interventions
        WHERE NUMVEHICULE IN (
            SELECT NUMVEHICULE
            FROM vehicule
            WHERE NUMMODELE IN (
                SELECT NUMMODELE
                FROM modele
                WHERE NUMMARQUE = self.NUMMARQUE
            )
        );
        RETURN chiffre_affaire;
    END calcul_chiffre_affaire;
END;
/





-- 7. Définir les tables nécessaires à la base de données.
--pas encore executé
CREATE TABLE client OF tclient (
    CONSTRAINT numclient_pk PRIMARY KEY (numclient),
    CONSTRAINT civ_check CHECK (civ IN ('M', 'Mle', 'Mme')))
NESTED TABLE vehicules STORE AS tab_client_vehicules;



CREATE TABLE employe OF temploye (
    CONSTRAINT numemploye_pk PRIMARY KEY (NUMEMPLOYE),
    CONSTRAINT categorie_check CHECK (categorie IN ('Mecanicien', 'Assistant')))
NESTED TABLE intervenants STORE AS tab_employe_intervenant;



CREATE TABLE marque OF tmarque (
    CONSTRAINT nummarque_pk PRIMARY KEY (NUMMARQUE))
NESTED TABLE modeles STORE AS tab_marque_modele;

CREATE TABLE modele OF tmodele (
    CONSTRAINT nummodele_pk PRIMARY KEY (NUMMODELE),
    CONSTRAINT nummarque_fk FOREIGN KEY (marque) REFERENCES marque)
NESTED TABLE vehicules STORE AS tab_modele_vehicule;

CREATE TABLE vehicule OF tvehicule (
    CONSTRAINT numvehicule_pk PRIMARY KEY (NUMVEHICULE),
    CONSTRAINT numclient_fk FOREIGN KEY (client) REFERENCES client,
    CONSTRAINT nummodele_fk FOREIGN KEY (modele) REFERENCES modele)
NESTED TABLE interventions STORE AS tab_vehicule_intervention;

CREATE TABLE interventions OF tinterventions (
    CONSTRAINT numintervention_pk PRIMARY KEY (NUMINTERVENTION),
    CONSTRAINT numvehicule_fk FOREIGN KEY (vehicule) REFERENCES vehicule)
    NESTED TABLE intervenants STORE AS tab_intervenant_intervention;

CREATE TABLE intervenants OF tintervenants (
    CONSTRAINT numintervention_fk FOREIGN KEY (intervention) REFERENCES interventions,
    CONSTRAINT numemploye_fk FOREIGN KEY (employe) REFERENCES employe);

-- D. Langage de manipulation de donnees