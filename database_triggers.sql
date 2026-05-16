-- ============================================================
--  PARTIE 4 - CONTRAINTES, PROCÉDURES ET TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- CONTRAINTE 1
-- Une offre d'emploi ne peut pas être supprimée, uniquement archivée
-- ------------------------------------------------------------

DELIMITER $$
CREATE TRIGGER before_delete_offre
BEFORE DELETE ON Offre
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La suppression d\'une offre est interdite. Veuillez archiver l\'offre en changeant son statut à "fermée".';
END $$
DELIMITER ;

-- Test contrainte 1 :
-- Doit retourner une erreur
DELETE FROM Offre WHERE idOffre = 1;


-- ------------------------------------------------------------
-- CONTRAINTE 2
-- Lorsqu'une offre passe de "ouverte" à "fermée",
-- la date de fermeture est automatiquement enregistrée
-- ------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_update_offre_statut
BEFORE UPDATE ON Offre
FOR EACH ROW
BEGIN
    -- On enregistre la date du jour ssi le statut passe de ouverte à fermée
    IF OLD.StatutOffre = 'ouverte' AND NEW.StatutOffre = 'fermée' THEN
        SET NEW.DateFermeture = CURDATE();
    END IF;
END $$
DELIMITER ;

-- Test contrainte 2 :
-- Mettre à jour le statut d'une offre ouverte → doit enregistrer la date du jour
UPDATE Offre SET StatutOffre = 'fermée' WHERE idOffre = 1;
-- Vérifier que DateFermeture a bien été renseignée
SELECT idOffre, StatutOffre, DateFermeture FROM Offre WHERE idOffre = 1;


-- ------------------------------------------------------------
-- CONTRAINTE 3
-- La suppression d'un candidat ne supprime que ses données
-- personnelles (Personne), ses autres données sont conservées
-- ------------------------------------------------------------


DELIMITER $$
CREATE TRIGGER before_delete_candidat
BEFORE DELETE ON Candidat
FOR EACH ROW
BEGIN
    -- On supprime les données de la table Personne 
    -- La FK dans la table Candidat passera automatiquement à NULL
    DELETE FROM Personne WHERE idPersonne = OLD.idPersonne;
END $$
DELIMITER ;


-- Test contrainte 3 :
-- Vérifier les données avant suppression
SELECT * FROM Personne WHERE idPersonne = (SELECT idPersonne FROM Candidat WHERE idCandidat = 3);
-- Supprimer la personne
DELETE FROM Personne WHERE idPersonne = (SELECT idPersonne FROM Candidat WHERE idCandidat = 3);
-- Vérifier que Personne est supprimée mais Candidat conservé avec idPersonne NULL
SELECT * FROM Personne WHERE idPersonne = 8;   -- doit être vide
SELECT * FROM Candidat WHERE idCandidat = 3;   -- doit exister avec idPersonne NULL
SELECT * FROM Diplome WHERE idCandidat = 3;    -- doit être conservé
SELECT * FROM ExperiencePro WHERE idCandidat = 3; -- doit être conservé


-- ------------------------------------------------------------
-- CONTRAINTE 4
-- Un candidat ne peut pas obtenir une offre s'il n'est pas disponible.
-- Un candidat est indisponible s'il a obtenu une offre sans date de fin
-- ou dont la date de fin est supérieure à la date actuelle.
-- ------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_candidature
BEFORE INSERT ON Candidature
FOR EACH ROW
BEGIN
    DECLARE v_disponible VARCHAR(50);

    SELECT StatutDisponibilite INTO v_disponible
    FROM Candidat WHERE idCandidat = NEW.idCandidat;

    IF v_disponible = 'Indisponible' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ce candidat est indisponible et ne peut pas postuler.';
    END IF;
END $$
DELIMITER ;

-- Test contrainte 4 :
-- Le candidat 4 (Chloé) est indisponible → doit retourner une erreur
INSERT INTO Candidature (idOffre, idCandidat, StatutCandidature)
VALUES (1, 4, 'en attente');


-- ------------------------------------------------------------
-- CONTRAINTE 5
-- Une candidature ne peut pas être obtenue si elle a déjà
-- été obtenue par un autre candidat
-- ------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_update_candidature
BEFORE UPDATE ON Candidature
FOR EACH ROW
BEGIN
    DECLARE v_deja_retenu INT;

    -- Vérifier si un autre candidat a déjà été retenu pour cette offre
    IF NEW.StatutCandidature = 'retenu' THEN
        SELECT COUNT(*) INTO v_deja_retenu
        FROM Candidature
        WHERE idOffre = NEW.idOffre
          AND StatutCandidature = 'retenu'
          AND idCandidat <> NEW.idCandidat;

        IF v_deja_retenu > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cette offre a déjà été obtenue par un autre candidat.';
        END IF;
    END IF;
END $$
DELIMITER ;

-- Test contrainte 5 :
-- L'offre 6 a déjà un candidat retenu (candidat 6)
-- Tenter de retenir un autre candidat → doit retourner une erreur
UPDATE Candidature SET StatutCandidature = 'retenu'
WHERE idOffre = 6 AND idCandidat = 1;


-- ------------------------------------------------------------
-- CONTRAINTE 6
-- Procédure qui remet les candidats à "Disponible"
-- si leur emploi actuel s'est terminé
-- ------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE maj_disponibilite_candidats()
BEGIN
    -- Un candidat redevient disponible si toutes ses offres obtenues
    -- ont une date de fin dépassée
    UPDATE Candidat c
    SET c.StatutDisponibilite = 'Disponible'
    WHERE c.StatutDisponibilite = 'Indisponible'
    AND NOT EXISTS (
        -- Vérifie qu'il n'a pas d'offre active sans date de fin ou dont la date de fin est future
        SELECT 1
        FROM Candidature ca
        JOIN Offre o ON ca.idOffre = o.idOffre
        WHERE ca.idCandidat = c.idCandidat
          AND ca.StatutCandidature = 'retenu'
          AND (o.DateFin IS NULL OR o.DateFin > CURDATE())
    );
END $$
DELIMITER ;

-- Test contrainte 6 :
-- Vérifier les candidats indisponibles avant
SELECT idCandidat, StatutDisponibilite FROM Candidat WHERE StatutDisponibilite = 'Indisponible';
-- Appeler la procédure
CALL maj_disponibilite_candidats();
-- Vérifier après → le candidat 4 (offre CDD terminée le 2025-02-28) doit être repassé Disponible
SELECT idCandidat, StatutDisponibilite FROM Candidat WHERE StatutDisponibilite = 'Disponible';


-- ------------------------------------------------------------
-- CONTRAINTE 7
-- Un candidat doit avoir au moins 16 ans à l'insertion
-- On vérifie via la table Personne car c'est là que
-- DateNaissance est stockée
-- ------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_insert_candidat_age
BEFORE INSERT ON Candidat
FOR EACH ROW
BEGIN
    DECLARE v_date_naissance DATE;
    DECLARE v_age INT;

    -- Récupérer la date de naissance depuis Personne
    SELECT DateNaissance INTO v_date_naissance
    FROM Personne WHERE idPersonne = NEW.idPersonne;

    -- Calculer l'âge
    SET v_age = TIMESTAMPDIFF(YEAR, v_date_naissance, CURDATE());

    IF v_age < 16 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Le candidat doit avoir au moins 16 ans.';
    END IF;
END $$
DELIMITER ;

-- Test contrainte 7 :
-- Insérer une personne de moins de 16 ans puis tenter de l'ajouter comme candidat
INSERT INTO Personne (idPersonne, Nom, Prenom, DateNaissance, Adresse, Telephone, Email)
VALUES (16, 'Jeune', 'Trop', '2015-01-01', '1 rue des Enfants, Paris', '0600000000', 'trop.jeune@gmail.com');
-- Doit retourner une erreur
INSERT INTO Candidat (idCandidat, idPersonne, DescriptionCandidat, StatutDisponibilite)
VALUES (11, 16, 'Trop jeune', 'Disponible');
-- Nettoyage
DELETE FROM Personne WHERE idPersonne = 16;