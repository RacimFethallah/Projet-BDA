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

-- --good
-- CREATE OR REPLACE TYPE BODY temploye AS
--     MEMBER FUNCTION calcul_interventions RETURN INTEGER IS
--         nombre_interventions INTEGER := 0;
--     BEGIN
--         FOR i IN 1..self.intervenants.COUNT LOOP
--             nombre_interventions := nombre_interventions + 1;
--         END LOOP;
--         RETURN nombre_interventions;
--     END;
-- END;
-- /

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
        nombre_modeles := self.modeles.COUNT;
        RETURN nombre_modeles;
    END;
END;
/

-- SELECT MARQUE, m.calcul_modeles() AS nb_modeles
-- FROM marque m;


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



--------------------------------------------------------------------------------------------------------

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



--------------------------------------------------------------------------------------------------------
-- 6.4 Lister pour chaque client, ses  véhicules. 

ALTER TYPE tclient
ADD MEMBER FUNCTION lister_vehicules RETURN tset_ref_vehicule
CASCADE;


CREATE OR REPLACE TYPE BODY tclient AS
    MEMBER FUNCTION lister_vehicules RETURN tset_ref_vehicule IS
    BEGIN
        RETURN self.vehicules;
    END;
END;
/


-- exemple pour executer: 
-- SELECT c.nomclient, c.prenomclient, v.numvehicule, v.numimmat, v.annee, m.modele, ma.marque
-- FROM client c, TABLE(c.get_vehicules()) v
-- JOIN TABLE(v.modele.modeles) m
-- JOIN TABLE(m.marque.modeles) ma
-- WHERE c.nomclient = 'Dupont';



-- ou ça

-- ALTER TYPE tclient
-- ADD MEMBER FUNCTION lister_vehicules RETURN varchar2
-- CASCADE;


-- CREATE OR REPLACE TYPE BODY tclient AS
--     MEMBER FUNCTION lister_vehicules RETURN VARCHAR2 IS
--         liste_vehicules VARCHAR2(4000);
--     BEGIN
--         liste_vehicules := 'Véhicules du client ' || self.nomclient || ' ' || self.prenomclient || ' :' || CHR(10);
--         FOR i IN 1..self.vehicules.COUNT LOOP
--             liste_vehicules := liste_vehicules || 'Véhicule n° ' || self.vehicules(i).numvehicule ||
--                                 ', Immatriculation : ' || self.vehicules(i).numimmat ||
--                                 ', Année : ' || self.vehicules(i).annee ||
--                                 ', Modèle : ' || self.vehicules(i).modele.modele ||
--                                 ', Marque : ' || self.vehicules(i).modele.marque.marque || CHR(10);
--         END LOOP;
--         RETURN liste_vehicules;
--     END;
-- END;
-- /



-- contient des erreurs
-------------------------------------------------------------------------------------------
-- 6.5 Calculer pour chaque marque, son chiffre d’affaire. 

ALTER TYPE tmarque
ADD MEMBER FUNCTION calcul_chiffre_affaire RETURN NUMBER
CASCADE;


CREATE OR REPLACE TYPE BODY tmarque AS
    MEMBER FUNCTION calcul_chiffre_affaire RETURN NUMBER IS
        chiffre_affaire NUMBER := 0;
    BEGIN
        FOR modele_ref IN (SELECT DEREF(m.modeles) AS modele
                           FROM TABLE(self.modeles) m)
        LOOP
            FOR vehicule IN (SELECT DEREF(v) AS vehicule
                             FROM TABLE(CAST(modele_ref.vehicules AS tset_ref_vehicule)) v)
            LOOP
                FOR intervention IN (SELECT DEREF(i) AS intervention
                                     FROM TABLE(CAST(MULTISET(vehicule.interventions))) i)
                LOOP
                    chiffre_affaire := chiffre_affaire + intervention.coutinterv;
                END LOOP;
            END LOOP;
        END LOOP;
        RETURN chiffre_affaire;
    END;
END;
/









-- 7. Définir les tables nécessaires à la base de données.
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
-- 8. Remplir toutes les tables par les instances fournies en annexe. 

-- Remplir la table client
INSERT INTO client VALUES (1, 'Mme', 'Cherifa', 'MAHBOUBA', TO_DATE('08/08/1957', 'DD/MM/YYYY'), 'CITE 1013 LOGTS BT 61 Alger', '0561381813', '0562458714', NULL, NULL);
INSERT INTO client VALUES (2, 'Mme', 'Lamia', 'TAHMI', TO_DATE('31/12/1955', 'DD/MM/YYYY'), 'CITE BACHEDJARAH BATIMENT 38 -Bach Djerrah-Alger', '0562467849', '0561392487', NULL, NULL);
INSERT INTO client VALUES (3, 'Mle', 'Ghania', 'DIAF AMROUNI', TO_DATE('31/12/1955', 'DD/MM/YYYY'), '43, RUE ABDERRAHMANE SBAA BELLE VUE-EL HARRACH-ALGER', '0523894562', '0619430945', '0562784254', NULL);
INSERT INTO client VALUES (4, 'Mle', 'Chahinaz', 'MELEK', TO_DATE('27/06/1955', 'DD/MM/YYYY'), 'HLM AISSAT IDIR CAGE 9 3EME ETAGE-EL HARRACH ALGER', '0634613493', '0562529463', NULL, NULL);
INSERT INTO client VALUES (5, 'Mme', 'Noura', 'TECHTACHE', TO_DATE('22/03/1949', 'DD/MM/YYYY'), '16, ROUTE EL DJAMILA-AIN BENIAN-ALGER', '0562757834', '0562757843', NULL, NULL);
INSERT INTO client VALUES (6, 'Mme', 'Widad', 'TOUATI', TO_DATE('14/08/1965', 'DD/MM/YYYY'), '14 RUE DES FRERES AOUDIA-EL MOURADIA- ALGER', '0561243967', '0561401836', NULL, NULL);
INSERT INTO client VALUES (7, 'Mle', 'Faiza', 'ABLOUL', TO_DATE('28/10/1967', 'DD/MM/YYYY'), 'CITE DIPLOMATIQUE BT BLEU 14B N 3 DERGANA- ALGER', '0562935427', '0561486203', NULL, NULL);
INSERT INTO client VALUES (8, 'Mme', 'Assia', 'HORRA', TO_DATE('08/12/1963', 'DD/MM/YYYY'), '32 RUE AHMED OUAKED- DELY BRAHIM-ALGER', '0561038500', '0562466733', NULL, NULL);
INSERT INTO client VALUES (9, 'Mle', 'Souad', 'MESBAH', TO_DATE('30/08/1972', 'DD/MM/YYYY'), 'RESIDENCE CHABANI- HYDRA-ALGER', '0561024358', NULL, NULL, NULL);
INSERT INTO client VALUES (10, 'Mme', 'Houda', 'GROUDA', TO_DATE('20/02/1950', 'DD/MM/YYYY'), 'EPSP THNIET ELABED BATNA', '0562939495', '0561218456', NULL, NULL);
INSERT INTO client VALUES (11, 'Mle', 'Saida', 'FENNICHE', NULL, 'CITE DE L''INDEPENDANCE LARBAA BLIDA', '0645983165', '0562014784', NULL, NULL);
INSERT INTO client VALUES (12, 'Mme', 'Samia', 'OUALI', TO_DATE('17/11/1966', 'DD/MM/YYYY'), 'CITE 200 LOGEMENTS BT1 N1-JIJEL', '0561374812', '0561277013', NULL, NULL);
INSERT INTO client VALUES (13, 'Mme', 'Fatiha', 'HADDAD', TO_DATE('20/09/1980', 'DD/MM/YYYY'), 'RUE BOUFADA LAKHDARAT- AIN OULMANE-SETIF', '0647092453', '0562442700', NULL, NULL);
INSERT INTO client VALUES (14, 'M.', 'Djamel', 'MATI', NULL, 'DRAA KEBILA HAMMAM GUERGOUR SETIF', '0561033663', '0561484259', NULL, NULL);
INSERT INTO client VALUES (15, 'M.', 'Mohamed', 'GHRAIR', TO_DATE('24/06/1950', 'DD/MM/YYYY'), 'CITE JEANNE D''ARC ECRAN B5-GAMBETTA – ORAN', '0561390288', '0562375849', NULL, NULL);
INSERT INTO client VALUES (16, 'M.', 'Ali', 'LAAOUAR', NULL, 'CITE 1ER MAI EX 137 LOGEMENTS-ADRAR', '0639939410', '0561255412', NULL, NULL);
INSERT INTO client VALUES (17, 'M.', 'Messoud', 'AOUIZ', TO_DATE('24/11/1958', 'DD/MM/YYYY'), 'RUE SAIDANI ABDESSLAM - AIN BESSEM-BOUIRA', '0561439256', '0561473625', NULL, NULL);
INSERT INTO client VALUES (18, 'M.', 'Farid', 'AKIL', TO_DATE('06/05/1961', 'DD/MM/YYYY'), '3 RUE LARBI BEN M''HIDI- DRAA EL MIZAN-TIZI OUZOU', NULL, '0561294268', NULL, NULL);
INSERT INTO client VALUES (19, 'Mme', 'Dalila', 'MOUHTADI', NULL, '6, BD TRIPOLI ORAN', '0506271459', '0506294186', NULL, NULL);
INSERT INTO client VALUES (20, 'M.', 'Younes', 'CHALAH', NULL, 'CITE DES 60 LOGTS BT D N 48-NACIRIA-BOUMERDES', '0561358279', NULL, NULL, NULL);
INSERT INTO client VALUES (21, 'M.', 'Boubeker', 'BARKAT', TO_DATE('08/11/1935', 'DD/MM/YYYY'), 'CITE MENTOURI N 71 BT AB SMK Constantine', '0561824538', '0561326179', NULL, NULL);
INSERT INTO client VALUES (22, 'M.', 'Seddik', 'HMIA', NULL, '25 RUE BEN YAHIYA-JIJEL', '0562379513', '0562493627', NULL, NULL);
INSERT INTO client VALUES (23, 'M.', 'Lamine', 'MERABAT', TO_DATE('09/12/1965', 'DD/MM/YYYY'), 'CITE JEANNE D''ARC ECRAN B2-GAMBETTA – ORAN', '0561724538', '0561724538', NULL, NULL);

-- Remplir la table employe
INSERT INTO employe VALUES (53, 'LACHEMI', 'Bouzid', 'Mecanicien', 25000, NULL);  
INSERT INTO employe VALUES (54, 'BOUCHEMLA', 'Elias', 'Assistant', 10000, NULL);
INSERT INTO employe VALUES (55, 'HADJ', 'Zouhir', 'Assistant', 12000, NULL);
INSERT INTO employe VALUES (56, 'OUSSEDIK', 'Hakim', 'Mecanicien', 20000, NULL);
INSERT INTO employe VALUES (57, 'ABAD','Abdelhamid', 'Assistant', 13000, NULL);
INSERT INTO employe VALUES (58, 'BABACI', 'Tayeb', 'Mecanicien', 21300, NULL);
INSERT INTO employe VALUES (59, 'BELHAMIDI', 'Mourad', 'Mecanicien', 19500, NULL);
INSERT INTO employe VALUES (60, 'IGOUDJIL', 'Redouane', 'Assistant', 15000, NULL);
INSERT INTO employe VALUES (61, 'KOULA', 'Bahim', 'Mecanicien', 23100, NULL);
INSERT INTO employe VALUES (62, 'RAHALI', 'Ahcene', 'Mecanicien', 24000, NULL);
INSERT INTO employe VALUES (63, 'CHAOUI', 'Ismail', 'Assistant', 13000, NULL);
INSERT INTO employe VALUES (64, 'BADI', 'Hatem', 'Assistant', 14000, NULL);
INSERT INTO employe VALUES (65, 'MOHAMMEDI', 'Mustapha', 'Mecanicien', 24000, NULL);
INSERT INTO employe VALUES (66, 'FEKAR', 'Abdelaziz', 'Assistant', 13500, NULL);
INSERT INTO employe VALUES (67, 'SAIDOUNI', 'Wahid', 'Mecanicien', 25000, NULL);
INSERT INTO employe VALUES (68, 'BOULARAS', 'Farid', 'Assistant', 14000, NULL);
INSERT INTO employe VALUES (69, 'CHAKER', 'Nassim', 'Mecanicien', 26000, NULL);
INSERT INTO employe VALUES (71, 'TERKI', 'Yacine', 'Mecanicien', 23000, NULL);
INSERT INTO employe VALUES (72, 'TEBIBEL', 'Ahmed', 'Assistant', 17000, NULL);
INSERT INTO employe VALUES (80, 'LARDJOUNE', 'Karim', 'Mecanicien', 25000, NULL);

-- Remplir la table marque  
INSERT INTO marque VALUES (1, 'LAMBORGHINI', 'ITALIE', NULL);
INSERT INTO marque VALUES (2, 'AUDI', 'ALLEMAGNE', NULL);
INSERT INTO marque VALUES (3, 'ROLLS-ROYCE', 'GRANDE-BRETAGNE', NULL);
INSERT INTO marque VALUES (4, 'BMW', 'ALLEMAGNE', NULL);
INSERT INTO marque VALUES (5, 'CADILLAC', 'ETATS-UNIS', NULL);
INSERT INTO marque VALUES (6, 'CHRYSLER', 'ETATS-UNIS', NULL);
INSERT INTO marque VALUES (7, 'FERRARI', 'ITALIE', NULL);
INSERT INTO marque VALUES (8, 'HONDA', 'JAPON', NULL);
INSERT INTO marque VALUES (9, 'JAGUAR', 'GRANDE-BRETAGNE', NULL);
INSERT INTO marque VALUES (10, 'ALFA-ROMEO', 'ITALIE', NULL);
INSERT INTO marque VALUES (11, 'LEXUS', 'JAPON', NULL);
INSERT INTO marque VALUES (12, 'LOTUS', 'GRANDE-BRETAGNE', NULL);
INSERT INTO marque VALUES (13, 'MASERATI', 'ITALIE', NULL);
INSERT INTO marque VALUES (14, 'MERCEDES', 'ALLEMAGNE', NULL);
INSERT INTO marque VALUES (15, 'PEUGEOT', 'FRANCE', NULL);
INSERT INTO marque VALUES (16, 'PORSCHE', 'ALLEMAGNE', NULL);
INSERT INTO marque VALUES (17, 'RENAULT', 'FRANCE', NULL);
INSERT INTO marque VALUES (18, 'SAAB', 'SUEDE', NULL);
INSERT INTO marque VALUES (19, 'TOYOTA', 'JAPON', NULL);
INSERT INTO marque VALUES (20, 'VENTURI', 'FRANCE', NULL);
INSERT INTO marque VALUES (21, 'VOLVO', 'SUEDE', NULL);

-- Remplir la table modele
INSERT INTO modele VALUES (2, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 1), 'Diablo', NULL);
INSERT INTO modele VALUES (3, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 2), 'Serie 5', NULL);
INSERT INTO modele VALUES (4, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 10), 'NSX', NULL);
INSERT INTO modele VALUES (5, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 14), 'Classe C', NULL);
INSERT INTO modele VALUES (6, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 17), 'Safrane', NULL);
INSERT INTO modele VALUES (7, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 20), '400 GT', NULL);
INSERT INTO modele VALUES (8, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 12), 'Esprit', NULL);
INSERT INTO modele VALUES (9, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 15), '605', NULL);
INSERT INTO modele VALUES (10, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 19), 'Previa', NULL);
INSERT INTO modele VALUES (11, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 7), '550 Maranello', NULL);
INSERT INTO modele VALUES (12, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 3), 'Bentley-Continental', NULL);
INSERT INTO modele VALUES (13, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 10), 'Spider', NULL);
INSERT INTO modele VALUES (14, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 13), 'Evoluzione', NULL);
INSERT INTO modele VALUES (15, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 16), 'Carrera', NULL);
INSERT INTO modele VALUES (16, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 16), 'Boxter', NULL);
INSERT INTO modele VALUES (17, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 21), 'S 80', NULL);
INSERT INTO modele VALUES (18, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 6), '300 M', NULL);
INSERT INTO modele VALUES (19, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 4), 'M 3', NULL);
INSERT INTO modele VALUES (20, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 9), 'XJ 8', NULL);
INSERT INTO modele VALUES (21, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 15), '406 Coupe', NULL);
INSERT INTO modele VALUES (22, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 20), '300 Atlantic', NULL);
INSERT INTO modele VALUES (23, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 14), 'Classe E', NULL);
INSERT INTO modele VALUES (24, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 11), 'GS 300', NULL);
INSERT INTO modele VALUES (25, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 5), 'Seville', NULL);
INSERT INTO modele VALUES (26, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 18), '95 Cabriolet', NULL);
INSERT INTO modele VALUES (27, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 2), 'TT Coupe', NULL);
INSERT INTO modele VALUES (28, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 7), 'F 355', NULL);
INSERT INTO modele VALUES (29, (SELECT REF(m) FROM marque m WHERE m.NUMMARQUE = 45), 'POLO', NULL);

-- Remplir la table vehicule
INSERT INTO vehicule VALUES (1, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 2), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 6), '0012519216', '1992', NULL);
INSERT INTO vehicule VALUES (2, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 9), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 20), '0124219316', '1993', NULL);  
INSERT INTO vehicule VALUES (3, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 17), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 8), '1452318716', '1987', NULL);
INSERT INTO vehicule VALUES (4, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 6), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 12), '3145219816', '1998', NULL);
INSERT INTO vehicule VALUES (5, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 16), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 23), '1278919816', '1998', NULL);
INSERT INTO vehicule VALUES (6, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 20), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 6), '3853319735', '1997', NULL);
INSERT INTO vehicule VALUES (7, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 7), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 8), '1453119816', '1998', NULL);
INSERT INTO vehicule VALUES (8, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 16), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 14), '8365318601', '1986', NULL);
INSERT INTO vehicule VALUES (9, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 13), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 15), '3087319233', '1992', NULL);
INSERT INTO vehicule VALUES (10, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 20), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 22), '9413119935', '1999', NULL);
INSERT INTO vehicule VALUES (11, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 9), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 16), '1572319801', '1998', NULL);
INSERT INTO vehicule VALUES (12, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 14), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 20), '6025319733', '1997', NULL);
INSERT INTO vehicule VALUES (13, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 19), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 17), '5205319736', '1997', NULL);
INSERT INTO vehicule VALUES (14, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 22), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 21), '7543119207', '1992', NULL);
INSERT INTO vehicule VALUES (15, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 4), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 19), '6254319916', '1999', NULL);
INSERT INTO vehicule VALUES (16, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 16), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 21), '9831419701', '1997', NULL);
INSERT INTO vehicule VALUES (17, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 12), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 11), '4563117607', '1976', NULL);
INSERT INTO vehicule VALUES (18, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 1), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 2), '7973318216', '1982', NULL);
INSERT INTO vehicule VALUES (19, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 18), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 77), '3904318515', '1985', NULL);
INSERT INTO vehicule VALUES (20, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 22), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 2), '1234319707', '1997', NULL);
INSERT INTO vehicule VALUES (21, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 3), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 19), '8429318516', '1985', NULL);
INSERT INTO vehicule VALUES (22, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 8), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 19), '1245619816', '1998', NULL);
INSERT INTO vehicule VALUES (23, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 7), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 25), '1678918516', '1985', NULL);
INSERT INTO vehicule VALUES (24, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 80), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 9), '1789519816', '1998', NULL);
INSERT INTO vehicule VALUES (25, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 13), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 5), '1278919833', '1998', NULL);
INSERT INTO vehicule VALUES (26, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 3), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 10), '1458919316', '1993', NULL);
INSERT INTO vehicule VALUES (27, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 10), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 7), '1256019804', '1998', NULL);
INSERT INTO vehicule VALUES (28, (SELECT REF(c) FROM client c WHERE c.NUMCLIENT = 10), (SELECT REF(m) FROM modele m WHERE m.NUMMODELE = 3), '1986219904', '1999', NULL);

-- Remplir la table interventions 
INSERT INTO interventions VALUES (1, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 3), 'Reparation', TO_DATE('25/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('26/02/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 30000, NULL);
INSERT INTO interventions VALUES (2, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 21), 'Reparation', TO_DATE('23/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('24/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 10000, NULL);
INSERT INTO interventions VALUES (3, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 25), 'Reparation', TO_DATE('06/04/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 42000, NULL);
INSERT INTO interventions VALUES (4, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 10), 'Entretien', TO_DATE('14/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('14/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 10000, NULL);
INSERT INTO interventions VALUES (5, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 6), 'Reparation', TO_DATE('22/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('25/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 40000, NULL);
INSERT INTO interventions VALUES (6, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 14), 'Entretien', TO_DATE('03/03/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('04/03/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 7500, NULL);
INSERT INTO interventions VALUES (7, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 1), 'Entretien', TO_DATE('09/04/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 8000, NULL);
INSERT INTO interventions VALUES (8, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 17), 'Entretien', TO_DATE('11/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 9000, NULL);
INSERT INTO interventions VALUES (9, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 22), 'Entretien', TO_DATE('22/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('22/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 7960, NULL);
INSERT INTO interventions VALUES (10, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 2), 'Entretien et Reparation', TO_DATE('08/04/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 45000, NULL);
INSERT INTO interventions VALUES (11, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 28), 'Reparation', TO_DATE('08/03/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('17/03/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 36000, NULL);
INSERT INTO interventions VALUES (12, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 20), 'Entretien et Reparation', TO_DATE('03/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('05/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 27000, NULL);
INSERT INTO interventions VALUES (13, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 8), 'Reparation Systeme', TO_DATE('12/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'), 17846, NULL);
INSERT INTO interventions VALUES (14, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 1), 'Reparation', TO_DATE('10/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 39000, NULL);
INSERT INTO interventions VALUES (15, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 20), 'Reparation Systeme', TO_DATE('25/06/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('25/06/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 27000, NULL);
INSERT INTO interventions VALUES (16, (SELECT REF(v) FROM vehicule v WHERE v.NUMVEHICULE = 77), 'Reparation', TO_DATE('27/06/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('30/06/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'), 25000, NULL);




INSERT INTO intervenants VALUES (1, 54, TO_DATE('26/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('26/02/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (1, 59, TO_DATE('25/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('25/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (2, 57, TO_DATE('24/02/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('24/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (2, 59, TO_DATE('23/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('24/02/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (3, 60, TO_DATE('09/04/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (3, 65, TO_DATE('06/04/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('08/04/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (4, 62, TO_DATE('14/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('14/05/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (4, 66, TO_DATE('14/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('14/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (5, 56, TO_DATE('22/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('25/02/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (5, 60, TO_DATE('23/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('25/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (6, 53, TO_DATE('03/03/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('04/03/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (6, 57, TO_DATE('04/03/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('04/03/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (7, 55, TO_DATE('09/04/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (7, 65, TO_DATE('09/04/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (8, 54, TO_DATE('12/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (8, 62, TO_DATE('11/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (9, 59, TO_DATE('22/02/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('22/02/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (9, 60, TO_DATE('22/02/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('22/02/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (10, 63, TO_DATE('09/04/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (10, 67, TO_DATE('08/04/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('09/04/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (11, 59, TO_DATE('09/03/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('11/03/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (11, 64, TO_DATE('09/03/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('17/03/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (11, 53, TO_DATE('08/03/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('16/03/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (12, 55, TO_DATE('05/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('05/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (12, 56, TO_DATE('03/05/2006 09:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('05/05/2006 12:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (13, 64, TO_DATE('12/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('12/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));
INSERT INTO intervenants VALUES (14, 88, TO_DATE('07/05/2006 14:00:00', 'DD/MM/YYYY HH24:MI:SS'), TO_DATE('10/05/2006 18:00:00', 'DD/MM/YYYY HH24:MI:SS'));




SELECT m.modele, ma.marque
FROM tmodele m, tmarque ma
WHERE m.marque = REF(ma);

SELECT v.numimmat, v.annee
FROM tvehicule v
WHERE v.interventions IS NOT EMPTY;

SELECT AVG(DATEFININTERV - DATEDEBINTERV) AS duree_moyenne_intervention
FROM interventions;


SELECT SUM(COUTINTERV) AS montant_global
FROM interventions
WHERE COUTINTERV > 30000;


SELECT e.numemploye, e.nomemploye, e.prenomemploye, COUNT(*) AS nombre_interventions
FROM employe e
JOIN TABLE(e.intervenants) i ON e.numemploye = i.employe.numemploye
GROUP BY e.numemploye, e.nomemploye, e.prenomemploye
ORDER BY COUNT(*) DESC;
