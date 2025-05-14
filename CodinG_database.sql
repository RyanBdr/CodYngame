-- Créer la base de données
DROP DATABASE codingame;
CREATE DATABASE codingame;
USE codingame;


-- Vérifier la configuration du bind_address pour les connexions distantes (séparer cette commande si nécessaire)
SHOW VARIABLES LIKE 'bind_address';

-- Table des utilisateurs
CREATE TABLE User (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique pour chaque utilisateur
    username VARCHAR(255) NOT NULL UNIQUE, -- Nom d'utilisateur avec une longueur maximale
    email TEXT, -- Adresse email de l'utilisateur (facultatif)
    password_hash TEXT, -- Mot de passe (haché, jamais en clair)
    score INTEGER DEFAULT 0, -- Score cumulé en fonction des réussites
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP -- Date de création du compte (par défaut à maintenant)
);

-- Table des administrateurs
CREATE TABLE Admin (
    id INT PRIMARY KEY AUTO_INCREMENT,  -- Identifiant unique pour chaque administrateur
    user_id INT,  -- Référence à l'utilisateur admin (clé étrangère vers la table `User`)
    FOREIGN KEY (user_id) REFERENCES User(id)  -- Clé étrangère vers la table User
);

-- Table des exercices
CREATE TABLE Exercise (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique de l'exercice
    title TEXT NOT NULL, -- Titre de l'exercice
    description TEXT NOT NULL, -- Description/énoncé de l'exercice
    type TEXT CHECK(type IN ('STDIN_STDOUT', 'INCLUDE')) NOT NULL, -- Type d'exercice (entrée/sortie ou fonction à compléter)
    exercise_image BLOB,  -- Image de l'exercice (stockée sous forme binaire)
    solution_image BLOB,  -- Image de la solution (stockée sous forme binaire)
    solution TEXT, -- Solution modèle attendue pour l'exercice
    difficulty INT CHECK(difficulty IN (1, 2, 3)) NOT NULL, -- Niveau de difficulté (1 = facile, 2 = moyen, 3 = difficile)
    attempts_count INT DEFAULT 0, -- Nombre de tentatives effectuées
    success_count INT DEFAULT 0 -- Nombre de réussites
);

-- Table des langages de programmation
CREATE TABLE Language (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique du langage
    name VARCHAR(255) NOT NULL UNIQUE -- Nom du langage (ex : Java, Python) avec une longueur spécifiée
);
-- Table de liaison entre exercices et langages disponibles
CREATE TABLE ExerciseLanguage (
    exercise_id INT, -- Référence vers l'exercice
    language_id INT, -- Référence vers le langage
    PRIMARY KEY (exercise_id, language_id), -- Clé primaire composée (chaque couple est unique)
    FOREIGN KEY (exercise_id) REFERENCES Exercise(id), -- Contrainte d'intégrité sur l'exercice
    FOREIGN KEY (language_id) REFERENCES Language(id) -- Contrainte d'intégrité sur le langage
);

-- Table des cas de test associés aux exercices
CREATE TABLE TestCase (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique du test
    exercise_id INT, -- Exercice concerné
    input_data TEXT, -- Données d'entrée du test (envoyées sur stdin)
    expected_output TEXT, -- Sortie attendue du test
    FOREIGN KEY (exercise_id) REFERENCES Exercise(id) -- Clé étrangère vers la table Exercise
);

-- Table des soumissions de code
CREATE TABLE Submission (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique pour chaque soumission
    user_id INT, -- Référence à l'utilisateur qui a soumis
    exercise_id INT, -- Référence à l'exercice auquel la soumission correspond
    language_id INT, -- Langage utilisé pour la soumission
    code TEXT NOT NULL, -- Le code soumis par l'utilisateur
    result TEXT, -- Résultat de l'exécution du code (succès ou erreur)
    success BOOLEAN DEFAULT FALSE, -- Si la soumission est réussie ou non
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date de la soumission
    FOREIGN KEY (user_id) REFERENCES User(id), -- Clé étrangère vers la table User
    FOREIGN KEY (exercise_id) REFERENCES Exercise(id), -- Clé étrangère vers la table Exercise
    FOREIGN KEY (language_id) REFERENCES Language(id) -- Clé étrangère vers la table Language
);

-- Table des résultats des tests associés aux soumissions
CREATE TABLE TestResult (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique pour chaque résultat
    submission_id INT, -- Référence à la soumission associée
    test_case_id INT, -- Référence au cas de test
    input_data TEXT, -- Données d'entrée utilisées pour le test
    expected_output TEXT, -- Sortie attendue du test
    actual_output TEXT, -- Sortie réelle obtenue
    success BOOLEAN, -- Si le test a réussi ou non
    FOREIGN KEY (submission_id) REFERENCES Submission(id), -- Clé étrangère vers la table Submission
    FOREIGN KEY (test_case_id) REFERENCES TestCase(id) -- Clé étrangère vers la table TestCase
);

-- Table des commentaires
CREATE TABLE Comment (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique du commentaire
    user_id INT, -- Référence à l'utilisateur qui a posté le commentaire
    exercise_id INT, -- Référence à l'exercice
    content TEXT NOT NULL, -- Contenu du commentaire
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Date de création du commentaire
    FOREIGN KEY (user_id) REFERENCES User(id), -- Clé étrangère vers la table User
    FOREIGN KEY (exercise_id) REFERENCES Exercise(id) -- Clé étrangère vers la table Exercise
);

-- Table des scores ( systeme de score spécifique à chaque exo )
CREATE TABLE Score (
    id INT PRIMARY KEY AUTO_INCREMENT, -- Identifiant unique du score
    user_id INT, -- Référence à l'utilisateur
    exercise_id INT, -- Référence à l'exercice
    score INT DEFAULT 0, -- Score de l'utilisateur pour cet exercice
    achieved BOOLEAN DEFAULT FALSE, -- Si l'exercice est réussi
    FOREIGN KEY (user_id) REFERENCES User(id), -- Clé étrangère vers la table User
    FOREIGN KEY (exercise_id) REFERENCES Exercise(id) -- Clé étrangère vers la table Exercise
);
