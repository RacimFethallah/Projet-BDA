--au cas ou
-- DROP TABLESPACE SQL3_TBS INCLUDING CONTENTS AND DATAFILES;
-- DROP TABLESPACE SQL3_TempTBS INCLUDING CONTENTS AND DATAFILES;
-- DROP USER SQL3_BDA CASCADE;




-- Partie 1 Partie I : Relationnel-Objet 

---------------------------------------- B. Creation des TableSpaces et utilisateur -----------------------------------------------------

-- 2. Creer deux TableSpaces   SQL3_TBS et  SQL3_TempTBS 
--TableSpace
CREATE TABLESPACE SQL3_TBS
DATAFILE 'D:\01_DevCode\uni\bda\Projet-BDA\tablespaces\sql3_tbs.dat' SIZE 50M
AUTOEXTEND ON;
--Temporary Tablespace
CREATE TEMPORARY TABLESPACE SQL3_TempTBS
TEMPFILE 'D:\01_DevCode\uni\bda\Projet-BDA\tablespaces\sql3_Temptbs.dat' SIZE 25M;




-- 3. Creer un utilisateur SQL3 en lui attribuant les deux tablespaces crees precedemment
CREATE USER SQL3_BDA IDENTIFIED BY admin
DEFAULT TABLESPACE SQL3_TBS
TEMPORARY TABLESPACE SQL3_TempTBS
QUOTA UNLIMITED ON SQL3_TBS;


--4. Donner tous les privileges a cet utilisateur.
GRANT ALL PRIVILEGES TO SQL3_BDA;


------------------------------------------- C. Langage de definition de donnees ---------------------------------------------------
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

CREATE type nt_ref_modele AS TABLE OF ref tmodele;
/
CREATE type nt_ref_vehicule AS TABLE OF ref tvehicule;
/
CREATE type nt_ref_interventions AS TABLE OF ref tinterventions;
/
CREATE type nt_ref_intervenants AS TABLE OF ref tintervenants;
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
    client_vehicule nt_ref_vehicule
);
/


CREATE OR REPLACE TYPE temploye AS OBJECT(
    numemploye INTEGER,
    nomemploye VARCHAR2(50),
    prenomemploye VARCHAR2(50),
    categorie VARCHAR2(50),
    salaire float,
    employe_intervenants nt_ref_intervenants
);
/



CREATE OR REPLACE TYPE tmarque AS OBJECT(
    NUMMARQUE INTEGER,
    MARQUE VARCHAR2(50),
    PAYS VARCHAR2(50),
    marque_modele nt_ref_modele
);
/



CREATE OR REPLACE TYPE tmodele AS OBJECT(
    nummodele INTEGER,
    marque REF tmarque,
    modele VARCHAR2(50),
    modele_vehicule nt_ref_vehicule
);
/





CREATE OR REPLACE TYPE tvehicule AS OBJECT(
    NUMVEHICULE INTEGER,
    client REF tclient,
    modele REF tmodele,
    NUMIMMAT VARCHAR2(50),
    ANNEE VARCHAR2(50),
    vehicule_interventions nt_ref_interventions
);
/

CREATE OR REPLACE TYPE tinterventions AS OBJECT(
    NUMINTERVENTION INTEGER,
    vehicule REF tvehicule,
    TYPEINTERVENTION VARCHAR2(50),
    DATEDEBINTERV DATE,
    DATEFININTERV DATE,
    COUTINTERV float,
    interventions_intervenants nt_ref_intervenants
);
/

CREATE OR REPLACE TYPE tintervenants AS OBJECT(
    interventions REF tinterventions,
    employe REF temploye,
    DATEDEBUT DATE,
    DATEFIN DATE
);
/



-- 6 Définir les méthodes permettant de : 

-- pour montrer les methodes d'un type
/*
SELECT OBJECT_NAME, PROCEDURE_NAME
FROM ALL_PROCEDURES
WHERE OBJECT_NAME = 'TEMPLOYE';
*/

--------------------------------------------------------------------------------------------------------

-- 6.1 Calculer pour chaque employé, le nombre des interventions effectuées. 

ALTER TYPE temploye
ADD MEMBER FUNCTION calcul_interventions RETURN INTEGER
CASCADE;


CREATE OR REPLACE TYPE BODY temploye AS
    MEMBER FUNCTION calcul_interventions RETURN INTEGER IS
        nombre_interventions INTEGER := 0;
    BEGIN
        nombre_interventions := self.employe_intervenants.COUNT;
        RETURN nombre_interventions;
    END;
END;
/

-- SELECT nomemploye, prenomemploye, e.calcul_interventions() AS nb_interventions
-- FROM employe e;



--------------------------------------------------------------------------------------------------------


-- 6.2 Calculer pour chaque marque, le nombre de modèles. 

ALTER TYPE tmarque
ADD MEMBER FUNCTION calcul_modeles RETURN INTEGER
CASCADE;

--good
CREATE OR REPLACE TYPE BODY tmarque AS
    MEMBER FUNCTION calcul_modeles RETURN INTEGER IS
        nombre_modeles INTEGER := 0;
    BEGIN
        nombre_modeles := self.marque_modele.COUNT;
        RETURN nombre_modeles;
    END;
END;
/

-- SELECT MARQUE, m.calcul_modeles() AS nb_modeles
-- FROM marque m;




--------------------------------------------------------------------------------------------------------

-- 6.3 Calculer pour chaque modèle, le nombre de véhicules. 

ALTER TYPE tmodele
ADD MEMBER FUNCTION calcul_vehicules RETURN INTEGER
CASCADE;


CREATE OR REPLACE TYPE BODY tmodele AS
    MEMBER FUNCTION calcul_vehicules RETURN INTEGER IS
        nombre_vehicules INTEGER := 0;
    BEGIN
        nombre_vehicules := self.modele_vehicule.COUNT;
        RETURN nombre_vehicules;
    END;
END;
/



--------------------------------------------------------------------------------------------------------
-- 6.4 Lister pour chaque client, ses véhicules. 

ALTER TYPE tclient
ADD MEMBER FUNCTION lister_vehicules RETURN nt_ref_vehicule
CASCADE;


CREATE OR REPLACE TYPE BODY tclient AS
    MEMBER FUNCTION lister_vehicules RETURN nt_ref_vehicule IS
    BEGIN
        RETURN self.client_vehicule;
    END;
END;
/



-------------------------------------------------------------------------------------------
-- 6.5 Calculer pour chaque marque, son chiffre d’affaire. 

ALTER TYPE tmarque
ADD MEMBER FUNCTION chiffre_affaire RETURN INTEGER
CASCADE;


CREATE OR REPLACE TYPE BODY tmarque AS 
   MEMBER FUNCTION chiffre_affaire RETURN INTEGER IS
        total_chiffre_affaire INTEGER := 0;
    BEGIN
        -- Parcours de la collection des références de modèles
        FOR i IN 1..self.marque_modele.COUNT LOOP
            -- Parcours de la collection des références de véhicules pour chaque modèle
            FOR j IN 1..self.marque_modele(i).modele_vehicule.COUNT LOOP
                -- Parcours de la collection des références d'interventions pour chaque véhicule
                FOR k IN 1..self.marque_modele(i).modele_vehicule(j).vehicule_interventions.COUNT LOOP
                    -- Ajout du coût de l'intervention au chiffre d'affaires total
                    total_chiffre_affaire := total_chiffre_affaire + self.marque_modele(i).modele_vehicule(j).vehicule_interventions(k).COUTINTERV;
                END LOOP;
            END LOOP;
        END LOOP;

        -- Retour du chiffre d'affaires total pour la marque
        RETURN total_chiffre_affaire;
    END chiffre_affaire;
END;
/







-- 7. Définir les tables nécessaires à la base de données.
CREATE TABLE client OF tclient (
    CONSTRAINT numclient_pk PRIMARY KEY (numclient),
    CONSTRAINT civ_check CHECK (civ IN ('M.', 'Mle', 'Mme')))
NESTED TABLE client_vehicule STORE AS tab_client_vehicule;



CREATE TABLE employe OF temploye (
    CONSTRAINT numemploye_pk PRIMARY KEY (NUMEMPLOYE),
    CONSTRAINT categorie_check CHECK (categorie IN ('Mecanicien', 'Assistant')))
NESTED TABLE employe_intervenants STORE AS tab_employe_intervenants;



CREATE TABLE marque OF tmarque (
    CONSTRAINT nummarque_pk PRIMARY KEY (NUMMARQUE))
NESTED TABLE marque_modele STORE AS tab_marque_modele;

CREATE TABLE modele OF tmodele (
    CONSTRAINT nummodele_pk PRIMARY KEY (NUMMODELE),
    CONSTRAINT nummarque_fk FOREIGN KEY (marque) REFERENCES marque)
NESTED TABLE modele_vehicule STORE AS tab_modele_vehicule;

CREATE TABLE vehicule OF tvehicule (
    CONSTRAINT numvehicule_pk PRIMARY KEY (NUMVEHICULE),
    CONSTRAINT numclient_fk FOREIGN KEY (client) REFERENCES client,
    CONSTRAINT nummodele_fk FOREIGN KEY (modele) REFERENCES modele)
NESTED TABLE vehicule_interventions STORE AS tab_vehicule_interventions;

CREATE TABLE interventions OF tinterventions (
    CONSTRAINT numintervention_pk PRIMARY KEY (NUMINTERVENTION),
    CONSTRAINT numvehicule_fk FOREIGN KEY (vehicule) REFERENCES vehicule)
    NESTED TABLE interventions_intervenants STORE AS tab_interventions_intervenants;

CREATE TABLE intervenants OF tintervenants (
    CONSTRAINT numintervention_fk FOREIGN KEY (interventions) REFERENCES interventions,
    CONSTRAINT numemploye_fk FOREIGN KEY (employe) REFERENCES employe);




-- D. Langage de manipulation de donnees
-- 8. Remplir toutes les tables par les instances fournies en annexe. 

-- Remplir la table client
INSERT INTO client VALUES (1, 'Mme', 'Cherifa', 'MAHBOUBA', TO_DATE('08/08/1957', 'DD/MM/YYYY'), 'CITE 1013 LOGTS BT 61 Alger', '0561381813', '0562458714',NULL,nt_ref_vehicule());

INSERT INTO client VALUES  (2, 'Mme', 'Lamia', 'TAHMI', TO_DATE('31/12/1955', 'DD/MM/YYYY'), 'CITE BACHEDJARAH BATIMENT 38 -Bach Djerrah-Alger', '0562467849', '0561392487',NULL,nt_ref_vehicule());

INSERT INTO client VALUES  (3, 'Mle', 'Ghania', 'DIAF', TO_DATE('31/12/1955', 'DD/MM/YYYY'), '43, RUE ABDERRAHMANE SBAA BELLE VUE-EL HARRACH-ALGER', '0523894562', '0619430945','0562784254',nt_ref_vehicule());

INSERT INTO client VALUES  (4, 'Mle', 'Chahinaz', 'MELEK', TO_DATE('27/06/1955', 'DD/MM/YYYY'), 'HLM AISSAT IDIR CAGE 9 3 EME ETAGE-EL HARRACH ALGER', '0634613493', '0562529463',NULL,nt_ref_vehicule());

INSERT INTO client VALUES  (5, 'Mme', 'Noura', 'TECHTACHE', TO_DATE('22/03/1949', 'DD/MM/YYYY'), '16, ROUTE EL DJAMILA-AIN BENIAN-ALGER', '0562757834', '0562757843','0562757843',nt_ref_vehicule());

INSERT INTO client VALUES  (6, 'Mme', 'Widad', 'TOUATI', TO_DATE('14/08/1965', 'DD/MM/YYYY'), '14 RUE DES FRERES AOUDIA-EL MOURADIA ALGER', '0561243967', '0561401836',NULL,nt_ref_vehicule());

INSERT INTO client VALUES  (7, 'Mle', 'Faiza', 'ABLOUL', TO_DATE('28/10/1967', 'DD/MM/YYYY'), 'CITE DIPLOMATIQUE BT BLEU 14B N 3 DERGANA-ALGER', '0562935427', '0561486203',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (8, 'Mme', 'Assia', 'HORRA', TO_DATE('08/12/1963', 'DD/MM/YYYY'), '32 RUE AHMED OUAKED-DELY BRAHIM-ALGER', '0561038500', '0562466733','0562466733',nt_ref_vehicule());

INSERT INTO client VALUES (9, 'Mle', 'Souad', 'MESBAH', TO_DATE('30/08/1972', 'DD/MM/YYYY'), 'RESIDENCE CHABANI-HYDRA-ALGER', '0561024358', NULL,NULL,nt_ref_vehicule());

INSERT INTO client VALUES (10, 'Mme', 'Houda', 'GROUDA', TO_DATE('20/02/1950', 'DD/MM/YYYY'), 'EPSP THNIET ELABED BATNA', '0562939495', '0561218456',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (11, 'Mle', 'Saida', 'FENNICHE', NULL, 'CITE DE L INDEPENDANCE LARBAA BLIDA', '0645983165', '0562014784',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (12, 'Mme', 'Samia', 'OUALI', TO_DATE('17/11/1966', 'DD/MM/YYYY'), 'CITE 200 LOGEMENTS BT1 N1-JIJEL', '0561374812', '0561277013',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (13, 'Mme', 'Fatiha', 'HADDAD', TO_DATE('20/09/1980', 'DD/MM/YYYY'), 'RUE BOUFADA LAKHDARAT-AIN OULMANE-SETIF', '0647092453', '0562442700',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (14, 'M.', 'Djamel', 'MATI', NULL, 'DRAA KEBILA HAMMAM GUERGOUR SETIF', '0561033663', '0561484259',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (15, 'M.', 'Mohamed', 'GHRAIR', TO_DATE('24/06/1950', 'DD/MM/YYYY'), 'CITE JEANNE D ARC ECRAN B5-GAMBETTA – ORAN', '0561390288',NULL, '0562375849',nt_ref_vehicule());

INSERT INTO client VALUES (16, 'M.', 'Ali', 'LAAOUAR', NULL, 'CITE 1ER MAI EX 137 LOGEMENTS-ADRAR', '0639939410', '0561255412',NULL,nt_ref_vehicule());
 
INSERT INTO client VALUES (17, 'M.', 'Messoud', 'AOUIZ', TO_DATE('24/11/1958', 'DD/MM/YYYY'), 'RUE SAIDANI ABDESSLAM - AIN BESSEM-BOUIRA', '0561439256', '0561473625',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (18, 'M.', 'Farid', 'AKIL', TO_DATE('06/05/1961', 'DD/MM/YYYY'), '3 RUE LARBI BEN M''HIDI-DRAA EL MIZAN-TIZI OUZOU', '0562349254', '0561294268',NULL,nt_ref_vehicule());
 
INSERT INTO client VALUES (19, 'Mme', 'Dalila', 'MOUHTADI', NULL, '6 BD TRIPOLI ORAN', '0506271459', '0506294186',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (20, 'M.', 'Younes', 'CHALAH', NULL, 'CITE DES 60 LOGTS BT D N 48-NACIRIA-BOUMERDES',NULL,'0561358279',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (21, 'M.', 'Boubeker', 'BARKAT', TO_DATE('08/11/1935', 'DD/MM/YYYY'), 'CITE MENTOURI N 71 BT AB SMK Constantine', '0561824538', '0561326179',NULL,nt_ref_vehicule());

INSERT INTO client VALUES (22, 'M.', 'Seddik', 'HMIA', NULL, '25 RUE BEN YAHIYA-JIJEL', '0562379513',NULL, '0562493627',nt_ref_vehicule());

INSERT INTO client VALUES (23, 'M.', 'Lamine', 'MERABAT', TO_DATE('09/13/1965', 'MM/DD/YYYY'), 'CITE JEANNE D ARC ECRAN B2-GAMBETTA - ORAN', '0561724538', '0561724538',NULL,nt_ref_vehicule());



-- Insérer les données dans la table employer

INSERT INTO employe VALUES (53, 'LACHEMI', 'Bouzid', 'Mecanicien', 25000,nt_ref_intervenants());

INSERT INTO employe VALUES (54, 'BOUCHEMLA', 'Elias', 'Assistant', 10000,nt_ref_intervenants());

INSERT INTO employe VALUES (55, 'HADJ', 'Zouhir', 'Assistant', 12000,nt_ref_intervenants());

INSERT INTO employe VALUES (56, 'OUSSEDIK', 'Hakim', 'Mecanicien', 20000,nt_ref_intervenants());

INSERT INTO employe VALUES (57, 'ABAD', 'Abdelhamid', 'Assistant', 13000,nt_ref_intervenants());

INSERT INTO employe VALUES (58, 'BABACI', 'Tayeb', 'Mecanicien', 21300,nt_ref_intervenants());

INSERT INTO employe VALUES (59, 'BELHAMIDI', 'Mourad', 'Mecanicien', 19500,nt_ref_intervenants());

INSERT INTO employe VALUES (60, 'IGOUDJIL', 'Redouane', 'Assistant', 15000,nt_ref_intervenants());

INSERT INTO employe VALUES (61, 'KOULA', 'Bahim', 'Mecanicien', 23100,nt_ref_intervenants());

INSERT INTO employe VALUES (62, 'RAHALI', 'Ahcene', 'Mecanicien', 24000,nt_ref_intervenants());

INSERT INTO employe VALUES (63, 'CHAOUI', 'Ismail', 'Assistant', 13000,nt_ref_intervenants());

INSERT INTO employe VALUES (64, 'BADI', 'Hatem', 'Assistant', 14000,nt_ref_intervenants());

INSERT INTO employe VALUES (65, 'MOHAMMEDI', 'Mustapha', 'Mecanicien', 24000,nt_ref_intervenants());

INSERT INTO employe VALUES (66, 'FEKAR', 'Abdelaziz', 'Assistant', 13500,nt_ref_intervenants());

INSERT INTO employe VALUES (67, 'SAIDOUNI', 'Wahid', 'Mecanicien', 25000,nt_ref_intervenants());

INSERT INTO employe VALUES (68, 'BOULARAS', 'Farid', 'Assistant', 14000,nt_ref_intervenants());
 
INSERT INTO employe VALUES (69, 'CHAKER', 'Nassim', 'Mecanicien', 26000,nt_ref_intervenants());

INSERT INTO employe VALUES (71, 'TERKI', 'Yacine', 'Mecanicien', 23000,nt_ref_intervenants());

INSERT INTO employe VALUES (72, 'TEBIBEL', 'Ahmed','Assistant', 17000,nt_ref_intervenants());

INSERT INTO employe VALUES (80, 'LARDJOUNE', 'Karim', NULL , 25000,nt_ref_intervenants());


-- Insérer les données dans la table marque

INSERT INTO marque VALUES (1, 'LAMBORGHINI', 'ITALIE',nt_ref_modele());

INSERT INTO marque VALUES (2, 'AUDI', 'ALLEMAGNE',nt_ref_modele());

INSERT INTO marque VALUES (3, 'ROLLS-ROYCE', 'GRANDE-BRETAGNE',nt_ref_modele());

INSERT INTO marque VALUES (4, 'BMW', 'ALLEMAGNE',nt_ref_modele());

INSERT INTO marque VALUES (5, 'CADILLAC', 'ETATS-UNIS',nt_ref_modele());

INSERT INTO marque VALUES (6, 'CHRYSLER', 'ETATS-UNIS',nt_ref_modele());

INSERT INTO marque VALUES (7, 'FERRARI', 'ITALIE',nt_ref_modele());

INSERT INTO marque VALUES (8, 'HONDA', 'JAPON',nt_ref_modele());

INSERT INTO marque VALUES (9, 'JAGUAR', 'GRANDE-BRETAGNE',nt_ref_modele());

INSERT INTO marque VALUES (10, 'ALFA-ROMEO', 'ITALIE',nt_ref_modele());

INSERT INTO marque VALUES (11, 'LEXUS', 'JAPON',nt_ref_modele());

INSERT INTO marque VALUES (12, 'LOTUS', 'GRANDE-BRETAGNE',nt_ref_modele());

INSERT INTO marque VALUES (13, 'MASERATI', 'ITALIE',nt_ref_modele());
 
INSERT INTO marque VALUES (14, 'MERCEDES', 'ALLEMAGNE',nt_ref_modele());

INSERT INTO marque VALUES (15, 'PEUGEOT', 'FRANCE',nt_ref_modele());

INSERT INTO marque VALUES (16, 'PORSCHE', 'ALLEMAGNE',nt_ref_modele());

INSERT INTO marque VALUES (17, 'RENAULT', 'FRANCE',nt_ref_modele());

INSERT INTO marque VALUES (18, 'SAAB', 'SUEDE',nt_ref_modele());

INSERT INTO marque VALUES (19, 'TOYOTA', 'JAPON',nt_ref_modele());

INSERT INTO marque VALUES (20, 'VENTURI', 'FRANCE',nt_ref_modele());

INSERT INTO marque VALUES (21, 'VOLVO', 'SUEDE',nt_ref_modele());


-- Insérer les données dans la table modele


INSERT INTO modele VALUES (2, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 1), 'Diablo',nt_ref_vehicule());

INSERT INTO modele VALUES (3, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 2), 'Série 5',nt_ref_vehicule());

INSERT INTO modele VALUES (4, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 10), 'NSX',nt_ref_vehicule());

INSERT INTO modele VALUES (5, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 14), 'Classe C',nt_ref_vehicule());

INSERT INTO modele VALUES (6, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 17), 'Safrane',nt_ref_vehicule());

INSERT INTO modele VALUES (7, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 20), '400 GT',nt_ref_vehicule());

INSERT INTO modele VALUES (8, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 12), 'Esprit',nt_ref_vehicule());

INSERT INTO modele VALUES (9, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 15), '605',nt_ref_vehicule());

INSERT INTO modele VALUES (10, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 19), 'Prévia',nt_ref_vehicule());

INSERT INTO modele VALUES (11, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 7), '550 Maranello',nt_ref_vehicule());

INSERT INTO modele VALUES (12, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 3), 'Bentley-Continental',nt_ref_vehicule());

INSERT INTO modele VALUES (13, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 10), 'Spider',nt_ref_vehicule());

INSERT INTO modele VALUES (14, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 13), 'Evoluzione',nt_ref_vehicule());

INSERT INTO modele VALUES (15, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 16), 'Carrera',nt_ref_vehicule());

INSERT INTO modele VALUES (16, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 16), 'Boxter',nt_ref_vehicule());

INSERT INTO modele VALUES (17, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 21), 'S 80',nt_ref_vehicule());

INSERT INTO modele VALUES (18, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 6), '300 M',nt_ref_vehicule());

INSERT INTO modele VALUES (19, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 4), 'M 3',nt_ref_vehicule());

INSERT INTO modele VALUES (20, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 9), 'XJ 8',nt_ref_vehicule());

INSERT INTO modele VALUES (21, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 15), '406 Coupé',nt_ref_vehicule());

INSERT INTO modele VALUES (22, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 20), '300 Atlantic',nt_ref_vehicule());

INSERT INTO modele VALUES (23, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 14), 'Classe E',nt_ref_vehicule());

INSERT INTO modele VALUES (24, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 11), 'GS 300',nt_ref_vehicule());

INSERT INTO modele VALUES (25, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 5), 'Séville',nt_ref_vehicule());

INSERT INTO modele VALUES (26, (SELECT REF(m) FROM marque m WHERE NUMMARQUE = 18), '95 Cabriolet',nt_ref_vehicule());


-- Insérer les données dans la table vehicule

INSERT INTO vehicule VALUES (1, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 2), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 6), '0012519216', 1992,nt_ref_interventions());

INSERT INTO vehicule VALUES (2, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 9), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 20), '0124219316', 1993,nt_ref_interventions());

INSERT INTO vehicule VALUES (3, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 17), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 8), '1452318716', 1987,nt_ref_interventions());

INSERT INTO vehicule VALUES (4, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 6), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 12), '3145219816', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (5, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 16), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 23), '1278919816', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (6, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 20), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 6), '3853319735', 1997,nt_ref_interventions());

INSERT INTO vehicule VALUES (7, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 7), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 8), '1453119816', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (8, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 16), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 14), '8365318601', 1986,nt_ref_interventions());

INSERT INTO vehicule VALUES (9, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 13), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 15), '3087319233', 1992,nt_ref_interventions());

INSERT INTO vehicule VALUES (10, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 20), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 22), '9413119935', 1999,nt_ref_interventions());

INSERT INTO vehicule VALUES (11, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 9), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 16), '1572319801', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (12, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 14), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 20), '6025319733', 1997,nt_ref_interventions());

INSERT INTO vehicule VALUES (13, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 19), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 17), '5205319736', 1997,nt_ref_interventions());

INSERT INTO vehicule VALUES (14, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 22), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 21), '7543119207', 1992,nt_ref_interventions());

INSERT INTO vehicule VALUES (15, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 4), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 19), '6254319916', 1999,nt_ref_interventions());

INSERT INTO vehicule VALUES (16, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 16), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 21), '9831419701', 1997,nt_ref_interventions());

INSERT INTO vehicule VALUES (17, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 12), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 11), '4563117607', 1976,nt_ref_interventions());

INSERT INTO vehicule VALUES (18, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 1), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 2), '7973318216', 1982,nt_ref_interventions());

INSERT INTO vehicule VALUES (19, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 18), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 77), '3904318515', 1985,nt_ref_interventions());

INSERT INTO vehicule VALUES (20, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 22), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 2), '1234319707', 1997,nt_ref_interventions());

INSERT INTO vehicule VALUES (21, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 3), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 19), '8429318516', 1985,nt_ref_interventions());

INSERT INTO vehicule VALUES (22, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 8), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 19), '1245619816', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (23, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 7), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 25), '1678918516', 1985,nt_ref_interventions());

INSERT INTO vehicule VALUES (24, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 80), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 9), '1789519816', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (25, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 13), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 5), '1278919833', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (26, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 3), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 10), '1458919316', 1993,nt_ref_interventions());

INSERT INTO vehicule VALUES (27, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 10), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 7), '1256019804', 1998,nt_ref_interventions());

INSERT INTO vehicule VALUES (28, (SELECT REF(c) FROM client c WHERE C.NUMCLIENT = 10), (SELECT REF(M) FROM MODELE M WHERE m.NUMMODELE = 3), '1986219904', 1999,nt_ref_interventions());



-- Insérer les données dans la table intervention

INSERT INTO interventions VALUES (1, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 3), 'Réparation', TO_DATE('2006-02-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 30000,nt_ref_intervenants());

INSERT INTO interventions VALUES (2, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 21), 'Réparation', TO_DATE('2006-02-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10000,nt_ref_intervenants());

INSERT INTO interventions VALUES (3, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 25), 'Réparation', TO_DATE('2006-04-06 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 42000,nt_ref_intervenants());

INSERT INTO interventions VALUES (4, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 10), 'Entretien', TO_DATE('2006-05-14 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 10000,nt_ref_intervenants());

INSERT INTO interventions VALUES (5, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 6), 'Réparation', TO_DATE('2006-02-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 40000,nt_ref_intervenants());

INSERT INTO interventions VALUES (6, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 14), 'Entretien', TO_DATE('2006-03-03 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7500,nt_ref_intervenants());

INSERT INTO interventions VALUES (7, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 1), 'Entretien', TO_DATE('2006-04-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 8000,nt_ref_intervenants());

INSERT INTO interventions VALUES (8, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 17), 'Entretien', TO_DATE('2006-05-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 9000,nt_ref_intervenants());

INSERT INTO interventions VALUES (9, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 22), 'Entretien', TO_DATE('2006-02-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 7960,nt_ref_intervenants());

INSERT INTO interventions VALUES (10, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 2), 'Entretien et Réparation', TO_DATE('2006-04-08 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 45000,nt_ref_intervenants());

INSERT INTO interventions VALUES (11, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 28), 'Réparation', TO_DATE('2006-03-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 36000,nt_ref_intervenants());

INSERT INTO interventions VALUES (12, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 20), 'Entretien et Réparation', TO_DATE('2006-05-03 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 27000,nt_ref_intervenants());

INSERT INTO interventions VALUES (13, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 8), 'Réparation Système', TO_DATE('2006-05-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'), 17846,nt_ref_intervenants());

INSERT INTO interventions VALUES (14, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 1), 'Réparation', TO_DATE('2006-05-10 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 39000,nt_ref_intervenants());

INSERT INTO interventions VALUES (15, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 20), 'Réparation Système', TO_DATE('2006-06-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-06-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 27000,nt_ref_intervenants());

INSERT INTO interventions VALUES (16, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 77), 'Réparation', TO_DATE('2006-06-27 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-06-30 12:00:00', 'YYYY-MM-DD HH24:MI:SS'), 25000,nt_ref_intervenants());


-- Insérer les données dans la table intervenant

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 1), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 54), TO_DATE('2006-02-26 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-26 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 1), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 59), TO_DATE('2006-02-25 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 2), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 57), TO_DATE('2006-02-24 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-24 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 2), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 59), TO_DATE('2006-02-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-24 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 3), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 60), TO_DATE('2006-04-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 3), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 65), TO_DATE('2006-04-06 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-08 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 4), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 62), TO_DATE('2006-05-14 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-14 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 4), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 66), TO_DATE('2006-02-14 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-14 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 5), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 56), TO_DATE('2006-02-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-25 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 5), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 60), TO_DATE('2006-02-23 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-25 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 6), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 53), TO_DATE('2006-03-03 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-04 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 6), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 57), TO_DATE('2006-03-04 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-04 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 7), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 55), TO_DATE('2006-04-09 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 7), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 65), TO_DATE('2006-04-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 8), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 54), TO_DATE('2006-05-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 8), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 62), TO_DATE('2006-05-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 9), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 59), TO_DATE('2006-02-22 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-22 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 9), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 60), TO_DATE('2006-02-22 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-02-22 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 10), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 63), TO_DATE('2006-04-09 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 10), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 67), TO_DATE('2006-04-08 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-04-09 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 11), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 59), TO_DATE('2006-03-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-11 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 11), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 64), TO_DATE('2006-03-09 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-17 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 11), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 53), TO_DATE('2006-03-08 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-03-16 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 12), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 55), TO_DATE('2006-05-05 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-05 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 12), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 56), TO_DATE('2006-05-03 09:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-05 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 13), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 64), TO_DATE('2006-05-12 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-12 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));

INSERT INTO intervenants VALUES ((SELECT REF(I) FROM interventions I WHERE I.NUMINTERVENTION = 14), (SELECT REF(e) FROM employe e WHERE e.NUMEMPLOYE = 88), TO_DATE('2006-05-07 14:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2006-05-10 18:00:00', 'YYYY-MM-DD HH24:MI:SS'));



------------------------------ Mise a jour Nested Tables ---------------------------------------


------------------------------ table client-vehicule --------------------------------


INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =1) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =18));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =2) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =1));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =3) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE=21));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =3) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE=26));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =4) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =15));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =6) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =4));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =7) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =7));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =7) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =23));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =8) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =22));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =8) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =24));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =9) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =2));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =9) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =11));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =10) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =27));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =10) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =28));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =12) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =17));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =13) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =9));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =13) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =25));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =14) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =12));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =16) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =5));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =16) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =16));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =17) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =3));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =18) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =19));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =19) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =13));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =20) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =6));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =20) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =10));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =22) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =14));
INSERT INTO table (SELECT c.client_vehicule FROM client c WHERE c.NUMCLIENT =22) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =20));


------------------------------ table employe-intervenants --------------------------------------



INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=54)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=1 and deref(employe).NUMEMPLOYE = 54);

insert into table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=59)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=1 and deref(employe).NUMEMPLOYE = 59);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=57)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=2 and deref(employe).NUMEMPLOYE=57);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=59)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=2 and deref(employe).NUMEMPLOYE=59);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=59)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=9  and deref(employe).NUMEMPLOYE=59);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=60)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=3 and deref(employe).NUMEMPLOYE=60);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=60)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=5 and deref(employe).NUMEMPLOYE=60);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=60)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=9  and deref(employe).NUMEMPLOYE=60);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=62)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=8  and deref(employe).NUMEMPLOYE=62);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=62)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=4 and deref(employe).NUMEMPLOYE=62);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=63)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=10 and deref(employe).NUMEMPLOYE=63);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=53)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=11 and deref(employe).NUMEMPLOYE=53);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=55)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=7 and deref(employe).NUMEMPLOYE=55);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=55)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=12 and deref(employe).NUMEMPLOYE=55);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=56)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=5 and deref(employe).NUMEMPLOYE=56);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=56)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=12 and deref(employe).NUMEMPLOYE=56);

INSERT INTO table(select e.employe_intervenants from employe e where e.NUMEMPLOYE=59)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=11 and deref(employe).NUMEMPLOYE=59);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=64)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=11 and deref(employe).NUMEMPLOYE=64);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=64)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=13 and deref(employe).NUMEMPLOYE=64);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=65)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=3 and deref(employe).NUMEMPLOYE=65);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=66)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=4 and deref(employe).NUMEMPLOYE=66);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=67)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=10 and deref(employe).NUMEMPLOYE=67);

insert into table(select e.employe_intervenants from employe e  where e.NUMEMPLOYE=88)  (select ref(i) from intervenants i where deref(interventions).NUMINTERVENTION=14 and deref(employe).NUMEMPLOYE=88);


--------------------------   table marque-modele ------------------------------------------------------------------------

INSERT INTO table (SELECT ma.marque_modele FROM marque ma WHERE ma.NUMMARQUE =1) VALUES ((SELECT REF(mo) FROM modele mo WHERE NUMMODELE =2));



---------------------------  table modele_vehicule -----------------------------------------------------------------------------


INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =2) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =18));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =2) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =20));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =3) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =28));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =5) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =25));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =6) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =1));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =6) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =6));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =7) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =19));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =7) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =27));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =8) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =3));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =8) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =7));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =9) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =24));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =10) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =26));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =11) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =17));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =12) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =4));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =14) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =8));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =15) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =9));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =16) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =11));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =17) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =13));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =19) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =21));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =19) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =22));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =20) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =2));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =20) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =12));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =21) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =14));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =21) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =16));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =22) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =10));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =23) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =5));
INSERT INTO table (SELECT m.modele_vehicule FROM modele m WHERE m.NUMMODELE =25) VALUES ((SELECT REF(v) FROM vehicule v WHERE NUMVEHICULE =23));




------------------------- table vehicule-interventions ----------------------------------------------------


insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=3)  (select ref(i) from interventions i where i.NUMINTERVENTION=1 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=21)  (select ref(i) from interventions i where i.NUMINTERVENTION=2 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=25)  (select ref(i) from interventions i where i.NUMINTERVENTION=3 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=10)  (select ref(i) from interventions i where i.NUMINTERVENTION=4 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=6)  (select ref(i) from interventions i where i.NUMINTERVENTION=5 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=14)  (select ref(i) from interventions i where i.NUMINTERVENTION=6 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=1)  (select ref(i) from interventions i where i.NUMINTERVENTION=7 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=17)  (select ref(i) from interventions i where i.NUMINTERVENTION=8 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=22)  (select ref(i) from interventions i where i.NUMINTERVENTION=9 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=2)  (select ref(i) from interventions i where i.NUMINTERVENTION=10 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=28)  (select ref(i) from interventions i where i.NUMINTERVENTION=11 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=20)  (select ref(i) from interventions i where i.NUMINTERVENTION=12 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=8)  (select ref(i) from interventions i where i.NUMINTERVENTION=13 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=1)  (select ref(i) from interventions i where i.NUMINTERVENTION=14 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=20)  (select ref(i) from interventions i where i.NUMINTERVENTION=15 );

insert into table(select v.vehicule_interventions from vehicule v where v.NUMVEHICULE=77)  (select ref(i) from interventions i where i.NUMINTERVENTION=16 );

------------------------- table interventions-intervenants -------------------------------------------------

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=1)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=54);
insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=1)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=59);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=2)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=57);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=2)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=59);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=3)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=60);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=3)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=65);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=4)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=62);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=4)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=66);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=5)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=56);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=5)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=60);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=6)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=53);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=6)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=57);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=7)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=55);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=7)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=65);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=8)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=54);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=8)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=62);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=9)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=59);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=9)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=60);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=10)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=63);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=10)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=67);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=11)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=59);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=11)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=64);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=11)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=53);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=12)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=59);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=12)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=56);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=13)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=64);

insert into table(select i.interventions_intervenants from interventions i  where i.NUMINTERVENTION=14)  (select ref(i) from intervenants i where deref(employe).NUMEMPLOYE=8);











----------------------------------------------- E. Langage d’interrogation de données --------------------------------------------------------- 

-- 9. Lister les modèles et leur marque. 
SELECT m.nummodele, m.modele, deref(m.marque).marque
FROM modele m;


-- 10. Lister les véhicules sur lesquels, il y a au moins une intervention. 

SELECT v.numvehicule, v.NUMIMMAT, v.ANNEE
FROM vehicule v
WHERE v.vehicule_interventions IS NOT EMPTY;

-- ou --

SELECT v.NUMIMMAT, v.ANNEE
FROM vehicule v
WHERE EXISTS (
    SELECT 1
    FROM TABLE(v.vehicule_interventions) i
);




-- 11. Quelle est la durée moyenne d’une intervention? 

SELECT i.NUMINTERVENTION, AVG(DATEFININTERV - DATEDEBINTERV) AS duree_moyenne_intervention
FROM interventions i
group by i.NUMINTERVENTION;



-- 12. Donner le montant global des interventions dont le coût d’intervention est supérieur à  30000 DA? 
SELECT SUM(COUTINTERV) AS montant_global
FROM interventions
WHERE COUTINTERV > 30000;








-- 13. Donner la liste des employés ayant fait le plus grand nombre d’interventions.
SELECT e.NUMEMPLOYE, e.nomemploye, e.prenomemploye, e.calcul_interventions() as nb_interventions
from employe e
where e.calcul_interventions() > 0
order by nb_interventions DESC;


SELECT e.numemploye, e.nomemploye, e.prenomemploye, count(*) as NombreInterventions
FROM employe e 
JOIN intervenants i ON e.numemploye = deref(i.employe).numemploye
group by  e.numemploye, e.nomemploye, e.prenomemploye
order by NombreInterventions DESC;



-- l'employé avec le plus d'interventions
SELECT e.NUMEMPLOYE, e.NOMEMPLOYE, e.PRENOMEMPLOYE, COUNT(*) as NombreInterventions
    FROM employe e
    JOIN intervenants i ON e.NUMEMPLOYE = deref(i.employe).NUMEMPLOYE
    GROUP BY e.NUMEMPLOYE, e.NOMEMPLOYE, e.PRENOMEMPLOYE
    HAVING COUNT(*) = (
        SELECT MAX(InterventionCount) FROM (
            SELECT COUNT(*) as InterventionCount
            FROM intervenants
           GROUP BY deref(employe).NUMEMPLOYE
       )
   )
   ORDER BY NombreInterventions DESC;
