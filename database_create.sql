CREATE DATABASE IF NOT EXISTS agenceinterim; 
USE agenceinterim;

-- Personne
CREATE TABLE Personne ( 
idPersonne INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
Nom VARCHAR(50) NOT NULL,
Prenom VARCHAR(50) NOT NULL,
DateNaissance DATE  NOT NULL,
Adresse VARCHAR(255) NOT NULL,
Telephone VARCHAR(15) NOT NULL,
Email VARCHAR(100)  NOT NULL,
CHECK (Email LIKE '%@%.%')
); 

-- Candidat
CREATE TABLE Candidat ( 
idCandidat INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
idPersonne INT UNIQUE,
DescriptionCandidat VARCHAR(255),
StatutDisponibilite VARCHAR(50) NOT NULL,

FOREIGN KEY (idPersonne) REFERENCES Personne(idPersonne)
ON DELETE SET NULL ON UPDATE CASCADE,
CHECK (StatutDisponibilite IN ('Disponible','Indisponible'))
); 

-- Salarie
CREATE TABLE Salarie ( 
idSalarie INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
idPersonne INT NOT NULL UNIQUE,
Role VARCHAR(50) NOT NULL,
Prime DECIMAL(10,2) NOT NULL DEFAULT 0.00,

FOREIGN KEY (idPersonne) REFERENCES Personne(idPersonne) 
ON DELETE RESTRICT ON UPDATE CASCADE,
CHECK (Role IN ('Directeur','Manager','Secrétaire','Accompagnateur','Consultant')),
CHECK (Prime >= 0)
); 

-- ExperiencePro
CREATE TABLE ExperiencePro (
idExperience INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
idCandidat INT NOT NULL,
TypeExperience VARCHAR(30) NOT NULL,
DateDebut DATE NOT NULL,
DateFin DATE,

FOREIGN KEY (idCandidat) REFERENCES Candidat(idCandidat)
ON DELETE CASCADE ON UPDATE CASCADE,
CHECK (TypeExperience IN ('CDI','CDD','Stage','Bénévolat','Alternance','Freelance','Autre')),
CHECK (DateFin IS NULL OR DateFin >= DateDebut)
); 

-- Diplome
CREATE TABLE Diplome (
idDiplome INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
NomDiplome VARCHAR(200) NOT NULL,
Niveau VARCHAR(50) NOT NULL,
idCandidat INT NOT NULL,

FOREIGN KEY (idCandidat) REFERENCES Candidat(idCandidat)
ON DELETE CASCADE ON UPDATE CASCADE,
CHECK (Niveau IN ('CAP','BEP','Bac','Bac+2','Licence','Master','Doctorat','Autre'))
); 

-- Entreprise
CREATE TABLE Entreprise (
idEntreprise INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
NomEntreprise VARCHAR (200) NOT NULL,
TelEntreprise VARCHAR (15),
AdresseEntreprise VARCHAR (255),
EmailEntreprise VARCHAR (150),

CHECK (EmailEntreprise LIKE '%@%.%')
);

-- Metier
CREATE TABLE Metier (
idMetier INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
NomMetier VARCHAR(150) NOT NULL UNIQUE
);

-- Competence
CREATE TABLE Competence (
idCompetence INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
NomCompetence VARCHAR (150) NOT NULL UNIQUE
);

-- Offre
CREATE TABLE Offre (
idOffre INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
IntituleOffre VARCHAR (255) NOT NULL, 
SalaireBrutMois DECIMAL (10,2),
TauxHoraire DECIMAL (10,2) NOT NULL,
NbHeuresMois DECIMAL (5,2) NOT NULL,
TypeContrat VARCHAR (30) NOT NULL,
DateDebut DATE NOT NULL,
DateFin DATE, 
DateFermeture DATE,
StatutOffre VARCHAR (10) NOT NULL DEFAULT 'ouverte',
idSalarie INT NOT NULL,
idEntreprise INT NOT NULL, 
idCandidatRetenu INT,
CommissionAgence DECIMAL(10,2),

FOREIGN KEY ( idCandidatRetenu) REFERENCES Candidat(idCandidat)
ON DELETE SET NULL ON UPDATE CASCADE,
FOREIGN KEY (idSalarie) REFERENCES Salarie(idSalarie)
ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (idEntreprise) REFERENCES Entreprise(idEntreprise)
ON DELETE RESTRICT ON UPDATE CASCADE,
CHECK (TypeContrat IN ('CDI','CDD','Stage','Alternance','Freelance','Autre')),
CHECK (StatutOffre IN ('ouverte','fermée')),
CHECK (TauxHoraire > 0),
CHECK (NbHeuresMois > 0),
-- Un CDI ne peut pas avoir de date de fin
CHECK (TypeContrat = 'CDI' OR DateFin IS NOT NULL),
CHECK (DateFin IS NULL OR DateFin >= DateDebut),
-- La date de fermeture n'existe que si le statut est 'fermée'
CHECK ((StatutOffre = 'fermée' AND DateFermeture IS NOT NULL)
OR (StatutOffre = 'ouverte' AND DateFermeture IS NULL))
);

-- Trigger : calcul automatique à l'insertion
DELIMITER //
CREATE TRIGGER trg_calc_commission_insert
BEFORE INSERT ON Offre
FOR EACH ROW
BEGIN
    SET NEW.SalaireBrutMois  = NEW.TauxHoraire * NEW.NbHeuresMois;
    SET NEW.CommissionAgence = NEW.TauxHoraire * NEW.NbHeuresMois * 0.10;
END//
DELIMITER ;

-- Trigger : calcul automatique à la mise à jour
DELIMITER //
CREATE TRIGGER trg_calc_commission_update
BEFORE UPDATE ON Offre
FOR EACH ROW
BEGIN
    SET NEW.SalaireBrutMois  = NEW.TauxHoraire * NEW.NbHeuresMois;
    SET NEW.CommissionAgence = NEW.TauxHoraire * NEW.NbHeuresMois * 0.10;
END//
DELIMITER ;

-- Candidature
CREATE TABLE Candidature ( 
idOffre INT NOT NULL, 
idCandidat INT NOT NULL, 
StatutCandidature VARCHAR(20) NOT NULL DEFAULT 'en attente',
PRIMARY KEY (idOffre, idCandidat),

FOREIGN KEY (idOffre) REFERENCES Offre(idOffre)
ON DELETE CASCADE ON UPDATE CASCADE, 
FOREIGN KEY (idCandidat) REFERENCES Candidat(idCandidat)
ON DELETE CASCADE ON UPDATE CASCADE,
CHECK (StatutCandidature IN ('en attente','retenu','refusé'))
); 

-- Possession_Metier 
CREATE TABLE Possession_Metier (
idCandidat INT NOT NULL, 
idMetier INT NOT NULL, 
PRIMARY KEY (idCandidat, idMetier ),

FOREIGN KEY (idCandidat) REFERENCES Candidat(idCandidat)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (idMetier) REFERENCES Metier(idMetier)
ON DELETE CASCADE ON UPDATE CASCADE
);

-- Possession_Comp
CREATE TABLE Possession_Comp (
idCandidat INT NOT NULL,
idCompetence INT NOT NULL,
PRIMARY KEY (idCandidat, idCompetence),

FOREIGN KEY (idCandidat) REFERENCES Candidat(idCandidat)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (idCompetence) REFERENCES Competence(idCompetence)
ON DELETE CASCADE ON UPDATE CASCADE
);

-- Offre_Comp
CREATE TABLE Offre_Comp (
idOffre INT NOT NULL, 
idCompetence INT NOT NULL, 
PRIMARY KEY (idOffre, idCompetence),

FOREIGN KEY (idOffre) REFERENCES Offre(idOffre)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (idCompetence) REFERENCES Competence (idCompetence)
ON DELETE CASCADE ON UPDATE CASCADE 
);

-- Offre_Metier
CREATE TABLE Offre_Metier (
idOffre INT NOT NULL, 
idMetier INT NOT NULL, 
PRIMARY KEY (idOffre, idMetier),

FOREIGN KEY (idOffre) REFERENCES Offre(idOffre)
ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (idMetier) REFERENCES Metier (idMetier)
ON DELETE CASCADE ON UPDATE CASCADE 
);