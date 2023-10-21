-- WITH 3 JOINS (notice that there are >= 3 functions with joins)
-- AGGREGATION FUNCTIONS:

-- This query shows how many tasks with deadline 
-- are not completed in all teams for a concrete user.
SELECT COUNT(*)
FROM team2user tu
INNER JOIN team2list tt ON tu.team_id = tt.team_id
INNER JOIN list2task lt ON tt.list_id = lt.list_id
INNER JOIN tasks t ON t.id = lt.task_id
WHERE tu.user_id = 5 AND t.type = 'DEADLINE' AND t.is_completed = FALSE; -- Replace '5' with your user ID



-- GROUP BY / HAVING clauses:

-- Get list of list_ids in a concrete team that have less than 6 tasks 
-- (because otherwise we need to add special instrument for rolling up/down or hidding the rest of tasks)
SELECT lt.list_id, COUNT(lt.task_id) AS task_count
FROM team2list tl
INNER JOIN list2task lt ON tl.list_id = lt.list_id
WHERE tl.team_id = 2  -- Replace '2' with your team ID
GROUP BY lt.list_id
HAVING COUNT(lt.task_id) <= 5;

-- Shows all incompleted tasks in a concrete team grouped by list_id to present them in separated lists
SELECT lt.list_id, t.*
FROM team2user tu
INNER JOIN team2list tt ON tu.team_id = tt.team_id
INNER JOIN list2task lt ON tt.list_id = lt.list_id
INNER JOIN tasks t ON t.id = lt.task_id
WHERE tu.team_id = 2 AND t.is_completed = FALSE -- Replace '2' with your team ID
GROUP BY lt.list_id, t.id;



-- THE REST OF FUNCTIONS:

-- Show all teams where user takes part
SELECT teams.*
FROM team2user tu
INNER JOIN teams ON tu.team_id = teams.id
WHERE tu.user_id = 1; -- Replace '1' with your user ID

-- Get avatar_image_id of a concrete user to show it to one
SELECT a.avatar_image_id
FROM users u
INNER JOIN avatars a ON a.id = u.avatar_id
WHERE u.id = 1; -- Replace '1' with your user ID

-- Get theme_image_id for each team which user takes part in 
SELECT t.id, th.theme_image_id
FROM team2user tu
INNER JOIN users u ON u.id = tu.user_id
INNER JOIN teams t ON t.id = tu.team_id
INNER JOIN themes th ON th.id = t.theme_id
WHERE u.id = 1; -- Replace '1' with your user ID

-- Get all participant's nicknames of a concrete team sorted by nicknames alphabetically 
SELECT u.id, u.nickname 
FROM team2user tu
INNER JOIN users u ON u.id = tu.user_id
WHERE tu.team_id = 6 -- Replace '6' with your team ID
ORDER BY u.nickname;

-- Get all available avatars which user can choose 
SELECT avatars.id, avatars.avatar_image_id
FROM avatars LIMIT 10;

-- Shows all completed tasks which user created (task archive)
SELECT t.id, t.title 
FROM tasks t
WHERE t.owner_id = 1 AND t.is_completed = TRUE; -- Replace '1' with your owner ID
