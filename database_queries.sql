-- ============================================================
--  PARTIE 3 - REQUÊTES SQL
-- ============================================================

-- ------------------------------------------------------------
-- Requête 1
-- Liste des candidats et des offres auxquelles ils ont postulé
-- ------------------------------------------------------------
SELECT 
    p.Nom,
    p.Prenom,
    o.IntituleOffre,
    o.TypeContrat,
    o.StatutOffre,
    c.StatutCandidature
FROM Candidature c
JOIN Candidat ca ON c.idCandidat = ca.idCandidat
JOIN Personne p  ON ca.idPersonne = p.idPersonne
JOIN Offre o     ON c.idOffre = o.idOffre
ORDER BY p.Nom, p.Prenom;


-- ------------------------------------------------------------
-- Requête 2
-- Toutes les informations d'un candidat
-- (on utilise plusieurs requêtes car un candidat peut avoir
--  plusieurs diplômes, compétences, métiers et offres)
-- ------------------------------------------------------------

-- 2a. Informations personnelles
SELECT 
    ca.idCandidat,
    p.Nom,
    p.Prenom,
    p.DateNaissance,
    p.Adresse,
    p.Telephone,
    p.Email,
    ca.DescriptionCandidat,
    ca.StatutDisponibilite
FROM Candidat ca
JOIN Personne p ON ca.idPersonne = p.idPersonne
WHERE ca.idCandidat = 1;

-- 2b. Diplômes
SELECT 
    d.NomDiplome,
    d.Niveau
FROM Diplome d
WHERE d.idCandidat = 1;

-- 2c. Métiers
SELECT 
    m.NomMetier
FROM possession_metier pm
JOIN Metier m ON pm.idMetier = m.idMetier
WHERE pm.idCandidat = 1;

-- 2d. Compétences
SELECT 
    co.NomCompetence
FROM possession_comp pc
JOIN Competence co ON pc.idCompetence = co.idCompetence
WHERE pc.idCandidat = 1;

-- 2e. Expériences professionnelles
SELECT 
    ep.TypeExperience,
    ep.DateDebut,
    ep.DateFin
FROM ExperiencePro ep
WHERE ep.idCandidat = 1;

-- 2f. Offres auxquelles il a postulé
SELECT 
    o.IntituleOffre,
    o.TypeContrat,
    o.StatutOffre,
    ca.StatutCandidature
FROM Candidature ca
JOIN Offre o ON ca.idOffre = o.idOffre
WHERE ca.idCandidat = 1;


-- ------------------------------------------------------------
-- Requête 3
-- Candidats qui ont postulé à TOUTES les offres d'emploi
-- (on utilise la division relationnelle :
--  le nombre de candidatures du candidat = nombre total d'offres)
-- ------------------------------------------------------------
SELECT 
    p.Nom,
    p.Prenom
FROM Candidat ca
JOIN Personne p ON ca.idPersonne = p.idPersonne
WHERE (
    SELECT COUNT(*) 
    FROM Candidature c 
    WHERE c.idCandidat = ca.idCandidat
) = (
    SELECT COUNT(*) 
    FROM Offre
);


-- ------------------------------------------------------------
-- Requête 4
-- Somme des commissions perçues par l'agence
-- (uniquement les offres fermées car ce sont celles
--  pour lesquelles la commission est perçue)
-- ------------------------------------------------------------
SELECT 
    SUM(CommissionAgence) AS TotalCommissionsAgence
FROM Offre
WHERE StatutOffre = 'fermée';


-- ------------------------------------------------------------
-- Requête 5
-- Commissions perçues par l'agence groupées par mois
-- ------------------------------------------------------------
SELECT 
    YEAR(DateFermeture)  AS Annee,
    MONTH(DateFermeture) AS Mois,
    SUM(CommissionAgence) AS TotalCommissionsAgence
FROM Offre
WHERE StatutOffre = 'fermée'
GROUP BY YEAR(DateFermeture), MONTH(DateFermeture)
ORDER BY Annee, Mois;


-- ------------------------------------------------------------
-- Requête 6
-- Commissions par salarié
-- 6a. Total toutes périodes confondues
-- ------------------------------------------------------------
SELECT 
    p.Nom,
    p.Prenom,
    SUM(o.CommissionAgence)        AS TotalCommissionAgence,
    SUM(o.CommissionAgence * 0.10) AS TotalPrimeSalarie
FROM Offre o
JOIN Salarie s  ON o.idSalarie = s.idSalarie
JOIN Personne p ON s.idPersonne = p.idPersonne
WHERE o.StatutOffre = 'fermée'
GROUP BY s.idSalarie, p.Nom, p.Prenom
ORDER BY TotalCommissionAgence DESC;

-- 6b. Par mois
SELECT 
    p.Nom,
    p.Prenom,
    YEAR(o.DateFermeture)          AS Annee,
    MONTH(o.DateFermeture)         AS Mois,
    SUM(o.CommissionAgence)        AS TotalCommissionAgence,
    SUM(o.CommissionAgence * 0.10) AS TotalPrimeSalarie
FROM Offre o
JOIN Salarie s  ON o.idSalarie = s.idSalarie
JOIN Personne p ON s.idPersonne = p.idPersonne
WHERE o.StatutOffre = 'fermée'
GROUP BY s.idSalarie, p.Nom, p.Prenom, YEAR(o.DateFermeture), MONTH(o.DateFermeture)
ORDER BY p.Nom, Annee, Mois;


-- ------------------------------------------------------------
-- Requête 7
-- Compétences non rattachées à des candidats
-- ------------------------------------------------------------
SELECT 
    c.NomCompetence
FROM Competence c
WHERE c.idCompetence NOT IN (
    SELECT DISTINCT idCompetence 
    FROM possession_comp
);


-- ------------------------------------------------------------
-- Requête 8
-- Candidats potentiels pour une offre donnée :
-- candidats disponibles, liés aux métiers ou compétences
-- requis par l'offre, et qui n'ont pas encore candidaté
-- On prend l'offre 1 en exemple (idOffre = 1)
-- ------------------------------------------------------------
SELECT DISTINCT
    p.Nom,
    p.Prenom,
    ca.StatutDisponibilite
FROM Candidat ca
JOIN Personne p ON ca.idPersonne = p.idPersonne
WHERE ca.StatutDisponibilite = 'Disponible'
-- N'a pas encore candidaté à cette offre
AND ca.idCandidat NOT IN (
    SELECT idCandidat 
    FROM Candidature 
    WHERE idOffre = 1
)
-- Est lié aux métiers ou compétences requis par l'offre
AND (
    ca.idCandidat IN (
        SELECT pm.idCandidat
        FROM possession_metier pm
        JOIN offre_metier om ON pm.idMetier = om.idMetier
        WHERE om.idOffre = 1
    )
    OR ca.idCandidat IN (
        SELECT pc.idCandidat
        FROM possession_comp pc
        JOIN offre_comp oc ON pc.idCompetence = oc.idCompetence
        WHERE oc.idOffre = 1
    )
);


-- ------------------------------------------------------------
-- Requête 9
-- Ajouter les candidatures pour les candidats listés en requête 8
-- On utilise un INSERT avec SELECT imbriqué pour ne pas
-- lister manuellement les identifiants
-- ------------------------------------------------------------
INSERT INTO Candidature (idOffre, idCandidat, StatutCandidature)
SELECT DISTINCT
    1,                  -- idOffre ciblée
    ca.idCandidat,
    'en attente'
FROM Candidat ca
WHERE ca.StatutDisponibilite = 'Disponible'
AND ca.idCandidat NOT IN (
    SELECT idCandidat 
    FROM Candidature 
    WHERE idOffre = 1
)
AND (
    ca.idCandidat IN (
        SELECT pm.idCandidat
        FROM possession_metier pm
        JOIN offre_metier om ON pm.idMetier = om.idMetier
        WHERE om.idOffre = 1
    )
    OR ca.idCandidat IN (
        SELECT pc.idCandidat
        FROM possession_comp pc
        JOIN offre_comp oc ON pc.idCompetence = oc.idCompetence
        WHERE oc.idOffre = 1
    )
);

-- Vérification
SELECT * FROM Candidature WHERE idOffre = 1;


-- ------------------------------------------------------------
-- Requête 10
-- Fermer une offre d'emploi et l'attribuer à un candidat
-- On ferme l'offre 2 et on retient le candidat 2 (Emma)
-- Le trigger before_update_offre_statut se chargera
-- automatiquement d'enregistrer la date de fermeture
-- ------------------------------------------------------------

-- Étape 1 : vérifier que le candidat a bien postulé à l'offre
SELECT * FROM Candidature WHERE idOffre = 2 AND idCandidat = 2;

-- Étape 2 : attribuer le candidat retenu et fermer l'offre
UPDATE Offre 
SET 
    StatutOffre       = 'fermée',
    idCandidatRetenu  = 2
WHERE idOffre = 2;

-- Étape 3 : mettre à jour le statut de la candidature
UPDATE Candidature 
SET StatutCandidature = 'retenu'
WHERE idOffre = 2 AND idCandidat = 2;

-- Étape 4 : refuser les autres candidats de cette offre
UPDATE Candidature 
SET StatutCandidature = 'refusé'
WHERE idOffre = 2 AND idCandidat <> 2;

-- Étape 5 : rendre le candidat retenu indisponible
UPDATE Candidat 
SET StatutDisponibilite = 'Indisponible'
WHERE idCandidat = 2;

-- Vérification finale
SELECT * FROM Offre WHERE idOffre = 2;
SELECT * FROM Candidature WHERE idOffre = 2;
SELECT StatutDisponibilite FROM Candidat WHERE idCandidat = 2;