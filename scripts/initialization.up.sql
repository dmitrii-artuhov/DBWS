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

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    team_ids INT[] DEFAULT ARRAY[]::INT[],
    avatar_id INT DEFAULT 0, 
    FOREIGN KEY (avatar_id) REFERENCES avatars(id)
);

CREATE TABLE avatars(
    id INT AUTO_INCREMENT PRIMARY KEY,
    avatar_image_id INT NOT NULL -- inner id of picture which is placed on client
);

CREATE TABLE themes(
    id INT AUTO_INCREMENT PRIMARY KEY,
    theme_image_id INT NOT NULL -- inner id of picture which is placed on client
);

CREATE TABLE teams (
    id INT AUTO_INCREMENT PRIMARY KEY,
    participants INT[] NOT NULL,
    theme_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    shareable BOOLEAN DEFAULT FALSE,
    list_ids INT[], 
    FOREIGN KEY (owner_id) REFERENCES users(id)
    FOREIGN KEY (theme_id) REFERENCES themes(id)
);

CREATE TABLE lists(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    tasks INT[]
);

CREATE TABLE tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(25) NOT NULL,
    description VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    create_time DATETIME NOT NULL,
    update_time DATETIME NOT NULL,
    type VARCHAR(50),
    is_completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

-- IS-A hierarchies

CREATE TABLE deadline_tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    deadline DATETIME NOT NULL,
    FOREIGN KEY (id) REFERENCES tasks(id)
);

CREATE TABLE highlighted_tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(7) DEFAULT '#FFFF00', -- Default color is yellow
    FOREIGN KEY (id) REFERENCES tasks(id)
);

CREATE TABLE recurrent_tasks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    weekday INT NOT NULL,
    CHECK (weekday >= 1 AND weekday <= 7),
    FOREIGN KEY (id) REFERENCES tasks(id)
);