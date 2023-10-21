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


CREATE TABLE IF NOT EXISTS users(
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(255) NOT NULL,
    avatar_id INT DEFAULT 0, 
    FOREIGN KEY (avatar_id) REFERENCES avatars(id)
);


CREATE TABLE IF NOT EXISTS teams(
    id INT AUTO_INCREMENT PRIMARY KEY,
    theme_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    shareable BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (owner_id) REFERENCES users(id),
    FOREIGN KEY (theme_id) REFERENCES themes(id)
);

CREATE TABLE IF NOT EXISTS team2user(
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(id),
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS lists(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS team2list(
    id INT AUTO_INCREMENT PRIMARY KEY,
    team_id INT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(id),
    list_id INT NOT NULL,
    FOREIGN KEY (list_id) REFERENCES lists(id)
);


CREATE TABLE IF NOT EXISTS tasks(
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    owner_id INT NOT NULL,
    type ENUM('REGULAR', 'DEADLINE', 'HIGHLIGHTED', 'RECURRENT'),
    is_completed BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (owner_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS list2task(
    id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    list_id INT NOT NULL,
    FOREIGN KEY (list_id) REFERENCES lists(id)
);

-- IS-A hierarchies

CREATE TABLE IF NOT EXISTS deadline_tasks(
    id INT PRIMARY KEY NOT NULL,
    deadline DATETIME NOT NULL,
    FOREIGN KEY (id) REFERENCES tasks(id)
);


CREATE TABLE IF NOT EXISTS highlighted_tasks(
    id INT PRIMARY KEY NOT NULL,
    color VARCHAR(7) DEFAULT '#FFFF00', -- Default color is yellow
    FOREIGN KEY (id) REFERENCES tasks(id)
);


CREATE TABLE IF NOT EXISTS recurrent_tasks (
    id INT PRIMARY KEY NOT NULL,
    weekday INT NOT NULL,
    CHECK (weekday >= 1 AND weekday <= 7),
    FOREIGN KEY (id) REFERENCES tasks(id)
);