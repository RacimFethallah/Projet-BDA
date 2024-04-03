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
--done
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

--done
CREATE OR REPLACE TYPE temploye AS OBJECT(
    numemploye INTEGER,
    nomemploye VARCHAR2(50),
    prenomemploye VARCHAR2(50),
    categorie VARCHAR2(50),
    salaire float
);
/


--done
CREATE OR REPLACE TYPE tmarque AS OBJECT(
    NUMMARQUE INTEGER,
    MARQUE VARCHAR2(50),
    PAYS VARCHAR2(50)
);
/



/* jsp si on utilise ça
Create type tset_ref_marque as table of ref tville;
/ 
*/


CREATE OR REPLACE TYPE tmodele AS OBJECT(
    NUMMODELE INTEGER,
    NUMMARQUE INTEGER,
    MODELE VARCHAR2(50)
);
/

CREATE OR REPLACE TYPE tvehicule AS OBJECT(
    NUMVEHICULE INTEGER,
    NUMCLIENT INTEGER,
    NUMMODELE INTEGER,
    NUMIMMAT VARCHAR2(50),
    ANNEE INTEGER
);
/

CREATE OR REPLACE TYPE tinterventions AS OBJECT(
    NUMINTERVENTION INTEGER,
    NUMVEHICULE INTEGER,
    TYPEINTERVENTION VARCHAR2(50),
    DATEDEBINTERV DATE,
    DATEFININTERV DATE,
    COUTINTERV NUMBER
);
/

CREATE OR REPLACE TYPE tintervenants AS OBJECT(
    NUMINTERVENTION INTEGER,
    NUMEMPLOYE INTEGER,
    DATEDEBUT DATE,
    DATEFIN DATE
);
/



-- 6 Définir les méthodes permettant de : 


-- 6.1 Calculer pour chaque employé, le nombre des interventions effectuées. 

-- 6.2 Calculer pour chaque marque, le nombre de modèles. 

-- 6.3 Calculer pour chaque modèle, le nombre de véhicules. 

-- 6.4 Lister pour chaque client, ses  véhicules. 

-- 6.5 Calculer pour chaque marque, son chiffre d’affaire.





-- 7. Définir les tables nécessaires à la base de données.
--pas encore executé
CREATE TABLE client OF tclient (
    CONSTRAINT numclient_pk PRIMARY KEY (numclient),
    CONSTRAINT civ_check CHECK (civ IN ('M', 'Mle', 'Mme'))
);



CREATE TABLE employe OF temploye (
    CONSTRAINT numemploye_pk PRIMARY KEY (NUMEMPLOYE)
);

CREATE TABLE marque OF tmarque (
    CONSTRAINT nummarque_pk PRIMARY KEY (NUMMARQUE)
);

CREATE TABLE modele OF tmodele (
    CONSTRAINT nummodele_pk PRIMARY KEY (NUMMODELE),
    CONSTRAINT nummarque_fk FOREIGN KEY (NUMMARQUE) REFERENCES marque(NUMMARQUE)
);

CREATE TABLE vehicule OF tvehicule (
    CONSTRAINT numvehicule_pk PRIMARY KEY (NUMVEHICULE),
    CONSTRAINT numclient_fk FOREIGN KEY (NUMCLIENT) REFERENCES client(NUMCLIENT),
    CONSTRAINT nummodele_fk FOREIGN KEY (NUMMODELE) REFERENCES modele(NUMMODELE)
);

CREATE TABLE interventions OF tinterventions (
    CONSTRAINT numintervention_pk PRIMARY KEY (NUMINTERVENTION),
    CONSTRAINT numvehicule_fk FOREIGN KEY (NUMVEHICULE) REFERENCES vehicule(NUMVEHICULE)
);

CREATE TABLE intervenants OF tintervenants (
    CONSTRAINT numintervention_fk FOREIGN KEY (NUMINTERVENTION) REFERENCES interventions(NUMINTERVENTION),
    CONSTRAINT numemploye_fk FOREIGN KEY (NUMEMPLOYE) REFERENCES employe(NUMEMPLOYE)
);

-- D. Langage de manipulation de donnees