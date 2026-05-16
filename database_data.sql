USE agenceinterim;
-- ------------------------------------------------------------
-- 1. PERSONNE
-- ------------------------------------------------------------
INSERT INTO Personne (idPersonne, Nom, Prenom, DateNaissance, Adresse, Telephone, Email) VALUES
(1,  'Martin',   'Sophie',  '1985-03-12', '12 rue des Lilas, Lyon',              '0612345678', 'sophie.martin@gmail.com'),
(2,  'Dubois',   'Pierre',  '1979-07-24', '5 avenue Foch, Paris',                '0623456789', 'pierre.dubois@gmail.com'),
(3,  'Leroy',    'Marie',   '1990-11-05', '8 rue Pasteur, Marseille',            '0634567890', 'marie.leroy@gmail.com'),
(4,  'Bernard',  'Thomas',  '1982-02-18', '3 place Bellecour, Lyon',             '0645678901', 'thomas.bernard@gmail.com'),
(5,  'Petit',    'Julie',   '1995-08-30', '22 rue Victor Hugo, Bordeaux',        '0656789012', 'julie.petit@gmail.com'),
(6,  'Durand',   'Lucas',   '1998-04-15', '14 rue de la Paix, Paris',            '0667890123', 'lucas.durand@gmail.com'),
(7,  'Moreau',   'Emma',    '1996-09-22', '7 rue Nationale, Lille',              '0678901234', 'emma.moreau@gmail.com'),
(8,  'Simon',    'Hugo',    '2000-01-10', '18 rue du Port, Nantes',              '0689012345', 'hugo.simon@gmail.com'),
(9,  'Laurent',  'Chloé',   '1997-06-03', '9 rue des Fleurs, Toulouse',          '0690123456', 'chloe.laurent@gmail.com'),
(10, 'Michel',   'Antoine', '1993-12-28', '31 avenue de la Gare, Strasbourg',    '0601234567', 'antoine.michel@gmail.com'),
(11, 'Garcia',   'Léa',     '1999-03-17', '6 rue Molière, Montpellier',          '0611234567', 'lea.garcia@gmail.com'),
(12, 'Roux',     'Maxime',  '1994-07-09', '25 rue Lafayette, Nice',              '0622345678', 'maxime.roux@gmail.com'),
(13, 'Vincent',  'Camille', '2001-10-14', '4 rue du Commerce, Rennes',           '0633456789', 'camille.vincent@gmail.com'),
(14, 'Fontaine', 'Nathan',  '1992-05-21', '11 rue de la République, Grenoble',   '0644567890', 'nathan.fontaine@gmail.com'),
(15, 'Rousseau', 'Inès',    '1998-08-07', '17 rue Saint-Michel, Bordeaux',       '0655678901', 'ines.rousseau@gmail.com');

-- ------------------------------------------------------------
-- 2. SALARIE
-- ------------------------------------------------------------
INSERT INTO Salarie (idSalarie, idPersonne, Role, Prime) VALUES
(1, 1, 'Directeur',      0.00),
(2, 2, 'Manager',        0.00),
(3, 3, 'Accompagnateur', 0.00),
(4, 4, 'Secrétaire',     0.00),
(5, 5, 'Consultant',     0.00);

-- ------------------------------------------------------------
-- 3. CANDIDAT
-- ------------------------------------------------------------
INSERT INTO Candidat (idCandidat, idPersonne, DescriptionCandidat, StatutDisponibilite) VALUES
(1,  6,  'Développeur web passionné, 3 ans d''expérience en JavaScript et React', 'Disponible'),
(2,  7,  'Analyste data junior, maîtrise Python et SQL',                           'Disponible'),
(3,  8,  'Charpentier expérimenté, 5 ans en construction bois',                    'Disponible'),
(4,  9,  'Professeure de mathématiques, 2 ans d''expérience',                      'Disponible'),
(5,  10, 'Soudeur certifié, spécialiste TIG et MIG',                               'Disponible'),
(6,  11, 'Développeuse fullstack, maîtrise Java et Angular',                       'Disponible'),
(7,  12, 'Data scientist, expérience en machine learning',                         'Disponible'),
(8,  13, 'Étudiante en informatique, cherche stage',                               'Disponible'),
(9,  14, 'Technicien réseau, certifié Cisco',                                      'Disponible'),
(10, 15, 'Graphiste UX/UI, maîtrise Figma et Adobe XD',                           'Disponible');

-- ------------------------------------------------------------
-- 4. ENTREPRISE
-- ------------------------------------------------------------
INSERT INTO Entreprise (idEntreprise, NomEntreprise, TelEntreprise, AdresseEntreprise, EmailEntreprise) VALUES
(1, 'TechSolutions',    '0411223344', '10 rue de l''Innovation, Lyon',   'contact@techsolutions.fr'),
(2, 'DataCorp',         '0122334455', '5 avenue des Champs, Paris',       'rh@datacorp.fr'),
(3, 'BâtiPro',          '0433445566', '3 rue du Bâtiment, Marseille',     'recrutement@batipro.fr'),
(4, 'EduFormation',     '0544556677', '8 rue de l''École, Toulouse',      'contact@eduformation.fr'),
(5, 'IndustrieMetall',  '0355667788', '15 zone industrielle, Strasbourg', 'rh@industriemetall.fr');

-- ------------------------------------------------------------
-- 5. METIER
-- ------------------------------------------------------------
INSERT INTO Metier (idMetier, NomMetier) VALUES
(1,  'Développeur Web'),
(2,  'Analyste Data'),
(3,  'Charpentier'),
(4,  'Soudeur'),
(5,  'Professeur'),
(6,  'Data Scientist'),
(7,  'Technicien Réseau'),
(8,  'Graphiste UX/UI'),
(9,  'Développeur Fullstack'),
(10, 'Technicien Informatique');

-- ------------------------------------------------------------
-- 6. COMPETENCE
-- ------------------------------------------------------------
INSERT INTO Competence (idCompetence, NomCompetence) VALUES
(1,  'JavaScript'),
(2,  'React'),
(3,  'Python'),
(4,  'SQL'),
(5,  'Java'),
(6,  'Angular'),
(7,  'Figma'),
(8,  'Adobe XD'),
(9,  'Machine Learning'),
(10, 'Cisco'),
(11, 'Construction bois'),
(12, 'Soudure TIG'),
(13, 'Soudure MIG'),
(14, 'MySQL'),
(15, 'PHP'),
(16, 'HTML/CSS'),
(17, 'Réseaux informatiques'),
(18, 'Linux'),
(19, 'Docker'),
(20, 'Git');

-- ------------------------------------------------------------
-- 7. DIPLOME
-- ------------------------------------------------------------
INSERT INTO Diplome (idDiplome, NomDiplome, Niveau, idCandidat) VALUES
(1,  'Licence Informatique',        'Licence', 1),
(2,  'Master Data Science',         'Master',  2),
(3,  'CAP Charpente',               'CAP',     3),
(4,  'Licence Mathématiques',       'Licence', 4),
(5,  'CAP Soudure',                 'CAP',     5),
(6,  'Master Informatique',         'Master',  6),
(7,  'Master Data Science',         'Master',  7),
(8,  'BTS Informatique',            'Bac+2',   8),
(9,  'Licence Réseaux et Télécom',  'Licence', 9),
(10, 'BTS Design Graphique',        'Bac+2',   10);

-- ------------------------------------------------------------
-- 8. EXPERIENCEPRO
-- ------------------------------------------------------------
INSERT INTO ExperiencePro (idExperience, idCandidat, TypeExperience, DateDebut, DateFin) VALUES
(1,  1, 'CDD',       '2022-01-10', '2023-06-30'),
(2,  1, 'Stage',     '2021-04-01', '2021-06-30'),
(3,  2, 'CDI',       '2021-09-01', NULL),
(4,  3, 'CDI',       '2019-03-15', '2023-12-31'),
(5,  4, 'CDD',       '2022-09-01', '2023-06-30'),
(6,  5, 'CDI',       '2018-06-01', '2024-01-31'),
(7,  6, 'Stage',     '2023-02-01', '2023-07-31'),
(8,  7, 'Freelance', '2022-01-01', NULL),
(9,  8, 'Stage',     '2024-02-01', '2024-07-31'),
(10, 9, 'CDI',       '2020-10-01', NULL),
(11, 10,'CDD',       '2023-03-01', '2024-02-28');

-- ------------------------------------------------------------
-- 9. OFFRE
-- ------------------------------------------------------------
INSERT INTO Offre (idOffre, IntituleOffre, TauxHoraire, NbHeuresMois, TypeContrat, DateDebut, DateFin, StatutOffre, DateFermeture, idSalarie, idEntreprise, idCandidatRetenu) VALUES
(1,  'Développeur Web Junior',       18.00, 160, 'CDD',   '2025-06-01', '2026-05-31', 'ouverte', NULL,         1, 1, NULL),
(2,  'Analyste Data',                22.00, 160, 'CDI',   '2025-07-01', NULL,         'ouverte', NULL,         2, 2, NULL),
(3,  'Charpentier confirmé',         16.00, 160, 'CDI',   '2025-08-01', NULL,         'ouverte', NULL,         3, 3, NULL),
(4,  'Stage Développeur Fullstack',  12.00, 140, 'Stage', '2025-09-01', '2026-02-28', 'ouverte', NULL,         4, 1, NULL),
(5,  'Technicien Réseau',            20.00, 160, 'CDI',   '2025-10-01', NULL,         'ouverte', NULL,         5, 5, NULL),
(6,  'Développeur Fullstack',        25.00, 160, 'CDI',   '2024-01-01', NULL,         'fermée',  '2024-03-15', 2, 1, 6),
(7,  'Data Scientist',               28.00, 160, 'CDI',   '2024-02-01', NULL,         'fermée',  '2024-04-10', 1, 2, 7),
(8,  'Professeur Mathématiques',     19.00, 160, 'CDD',   '2024-03-01', '2025-02-28', 'fermée',  '2024-05-20', 3, 4, 4),
(9,  'Soudeur TIG/MIG',              17.00, 160, 'CDI',   '2024-04-01', NULL,         'fermée',  '2024-06-01', 4, 5, 5),
(10, 'Stage UX/UI Designer',         11.00, 140, 'Stage', '2024-06-01', '2024-11-30', 'fermée',  '2024-07-15', 5, 1, 10);

-- Mise à jour des candidats retenus → indisponibles
UPDATE Candidat SET StatutDisponibilite = 'Indisponible' WHERE idCandidat IN (4, 5, 6, 7, 10);

-- Mise à jour des primes des salariés
UPDATE Salarie SET Prime = Prime + (SELECT CommissionAgence * 0.10 FROM Offre WHERE idOffre = 6)  WHERE idSalarie = 2;
UPDATE Salarie SET Prime = Prime + (SELECT CommissionAgence * 0.10 FROM Offre WHERE idOffre = 7)  WHERE idSalarie = 1;
UPDATE Salarie SET Prime = Prime + (SELECT CommissionAgence * 0.10 FROM Offre WHERE idOffre = 8)  WHERE idSalarie = 3;
UPDATE Salarie SET Prime = Prime + (SELECT CommissionAgence * 0.10 FROM Offre WHERE idOffre = 9)  WHERE idSalarie = 4;
UPDATE Salarie SET Prime = Prime + (SELECT CommissionAgence * 0.10 FROM Offre WHERE idOffre = 10) WHERE idSalarie = 5;

-- ------------------------------------------------------------
-- 10. POSSESSION_METIER
-- ------------------------------------------------------------
INSERT INTO Possession_Metier (idCandidat, idMetier) VALUES
(1,  1),
(1,  9),
(2,  2),
(3,  3),
(4,  5),
(5,  4),
(6,  9),
(7,  6),
(8,  10),
(9,  7),
(10, 8);

-- ------------------------------------------------------------
-- 11. POSSESSION_COMP
-- ------------------------------------------------------------
INSERT INTO Possession_Comp (idCandidat, idCompetence) VALUES
(1,  1),
(1,  2),
(1,  16),
(2,  3),
(2,  4),
(3,  11),
(4,  4),
(5,  12),
(5,  13),
(6,  5),
(6,  6),
(6,  20),
(7,  3),
(7,  9),
(7,  4),
(8,  7),
(8,  8),
(9,  10),
(9,  17),
(9,  18),
(10, 7),
(10, 8);

-- ------------------------------------------------------------
-- 12. OFFRE_METIER
-- ------------------------------------------------------------
INSERT INTO Offre_Metier (idOffre, idMetier) VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  9),
(5,  7),
(6,  9),
(7,  6),
(8,  5),
(9,  4),
(10, 8);

-- ------------------------------------------------------------
-- 13. OFFRE_COMP
-- ------------------------------------------------------------
INSERT INTO Offre_Comp (idOffre, idCompetence) VALUES
(1,  1),
(1,  2),
(1,  16),
(2,  3),
(2,  4),
(3,  11),
(4,  5),
(4,  6),
(5,  10),
(5,  17),
(6,  5),
(6,  6),
(7,  9),
(7,  3),
(8,  4),
(9,  12),
(9,  13),
(10, 7),
(10, 8);

-- ------------------------------------------------------------
-- 14. CANDIDATURE
-- ------------------------------------------------------------
INSERT INTO Candidature (idOffre, idCandidat, StatutCandidature) VALUES
(1,  1,  'en attente'),
(1,  8,  'en attente'),
(2,  2,  'en attente'),
(2,  7,  'en attente'),
(3,  3,  'en attente'),
(4,  8,  'en attente'),
(5,  9,  'en attente'),
(6,  6,  'retenu'),
(6,  1,  'refusé'),
(7,  7,  'retenu'),
(7,  2,  'refusé'),
(8,  4,  'retenu'),
(9,  5,  'retenu'),
(10, 10, 'retenu');