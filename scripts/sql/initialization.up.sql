/*
Implement:
    entities:
        User
        Task
        List
        Team
        Avatar
        Theme

    relationships:
        User -> Avatar
        Task -> User
        Team -> User
        Team -> Theme

    ISA hierarchies:
        DeadlineTask    -> Task
        HighlightedTask -> Task
        RecurrentTask   -> Task
*/

CREATE TABLE IF NOT EXISTS avatars(
    id INT AUTO_INCREMENT PRIMARY KEY,
    avatar_image_id INT NOT NULL -- inner id of predefined pictures
);


CREATE TABLE IF NOT EXISTS themes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    theme_image_id INT NOT NULL -- inner id of predefined pictures
);


CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(255) NOT NULL,
    team_ids TEXT NOT NULL, -- contains ids of teams with delimeter ','
    avatar_id INT DEFAULT 0, 
    FOREIGN KEY (avatar_id) REFERENCES avatars(id)
);


CREATE TABLE IF NOT EXISTS teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    participant_ids TEXT NOT NULL, -- contains ids of team participants with delimeter ','
    theme_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    shareable BOOLEAN DEFAULT FALSE,
    list_ids TEXT NOT NULL, -- contains ids of lists inside a team with delimeter ',' 
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (theme_id) REFERENCES themes(id)
);


CREATE TABLE IF NOT EXISTS lists(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    tasks TEXT NOT NULL -- contains ids of tasks inside a list with delimeter ','
);


CREATE TABLE IF NOT EXISTS tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    create_time DATETIME NOT NULL,
    update_time DATETIME NOT NULL,
    type ENUM('REGULAR', 'DEADLINE', 'HIGHLIGHTED', 'RECURRENT'),
    is_completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);


-- IS-A hierarchies

CREATE TABLE IF NOT EXISTS deadline_tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    deadline DATETIME NOT NULL,
    FOREIGN KEY (id) REFERENCES tasks(id)
);


CREATE TABLE IF NOT EXISTS highlighted_tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(7) DEFAULT '#FFFF00', -- Default color is yellow
    FOREIGN KEY (id) REFERENCES tasks(id)
);


CREATE TABLE IF NOT EXISTS recurrent_tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    weekday INT NOT NULL,
    CHECK (weekday >= 1 AND weekday <= 7),
    FOREIGN KEY (id) REFERENCES tasks(id)
);