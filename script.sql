-- Partie 1 Partie I : Relationnel-Objet 

-- B. Creation des TableSpaces et  utilisateur 

-- 2. Creer deux TableSpaces   SQL3_TBS et  SQL3_TempTBS 
--TableSpace
CREATE TABLESPACE SQL3_TBS
DATAFILE 'c:\sql3_tbs.dat' SIZE 2M
DEFAULT STORAGE (
  INITIAL 128K
  NEXT 64K
  MINEXTENTS 1
  MAXEXTENTS 5
);
--Temporary Tablespace
CREATE TEMPORARY TABLESPACE SQL3_TempTBS
TEMPFILE 'c:\sql3_Temptbs.dat' SIZE 2M;


-- 3. Creer un utilisateur SQL3 en lui attribuant les deux tablespaces crees precedemment
CREATE USER SQL3_BDA IDENTIFIED BY admin
DEFAULT TABLESPACE SQL3_TBS
TEMPORARY TABLESPACE SQL3_TempTBS
QUOTA UNLIMITED ON SQL3_TBS;


--4. Donner tous les privileges a cet utilisateur.
GRANT ALL PRIVILEGES TO SQL3_BDA;


-- C. Langage de definition de donnees
-- 5. definir tous les types necessaires.

CREATE OR REPLACE TYPE tclient AS OBJECT(
    numclient INTEGER,
    civ VARCHAR2(3), 
    prenomclient VARCHAR2(50), 
    NOMCLIENT VARCHAR2(50), 
    DATENAISSANCE DATE,  
    ADRESSE VARCHAR2(100), 
    TELPROF VARCHAR2(10), 
    TELPRIV VARCHAR2(10), 
    FAX VARCHAR2(10)
);
/

--pour apres
CREATE TABLE client OF tclient (
    CONSTRAINT numclient_pk PRIMARY KEY (numclient),
    CONSTRAINT civ_check CHECK (civ IN ('M', 'Mle', 'Mme'))
);


