import argparse
import mysql.connector
import datetime
from faker import Faker


# MySQL connection parameters
db_config = {
    "database": "todo_list",
    "host": "localhost",
    "user": "root",
    "password": "123",
}

fake: Faker = Faker()
USERS_COUNT = 5
LISTS_COUNT_PER_TEAM = [1, 3] # min, max
TASKS_COUNT_PER_LIST = [1, 5] # min, max
TASK_TYPES_ENUM = ('REGULAR', 'DEADLINE', 'HIGHLIGHTED', 'RECURRENT')


def insert_avatar(cursor, avatar_data):
    print(f"Insert avatar data: {avatar_data}")
    insert_avatar_query = "INSERT INTO avatars (avatar_image_id) VALUES (%s)"
    cursor.execute(insert_avatar_query, avatar_data)
    return cursor.lastrowid

def insert_theme(cursor, theme_data):
    print(f"Insert theme data: {theme_data}")
    insert_theme_query = "INSERT INTO themes (theme_image_id) VALUES (%s)"
    cursor.execute(insert_theme_query, theme_data)
    return cursor.lastrowid

def insert_task(cursor, task_data):
    print(f"Insert task data: {task_data}")
    insert_task_query = "INSERT INTO tasks (title, description, owner_id, type, is_completed) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(insert_task_query, task_data)
    return cursor.lastrowid

def insert_deadline_task(cursor, task_data):
    print(f"Insert deadline task data: {task_data}")
    insert_deadline_task_query = "INSERT INTO deadline_tasks (id, deadline) VALUES (%s, now())"
    cursor.execute(insert_deadline_task_query, task_data)
    return cursor.lastrowid

def insert_highlighted_task(cursor, task_data):
    print(f"Insert highlighted task data: {task_data}")
    insert_highlighted_task_query = "INSERT INTO highlighted_tasks (id) VALUES (%s)"
    cursor.execute(insert_highlighted_task_query, task_data)
    return cursor.lastrowid

def insert_recurrent_task(cursor, task_data):
    print(f"Insert recurrent task data: {task_data}")
    insert_recurrent_task_query = "INSERT INTO recurrent_tasks (id, weekday) VALUES (%s, %s)"
    cursor.execute(insert_recurrent_task_query, task_data)
    return cursor.lastrowid

def insert_list(cursor, list_data):
    print(f"Insert list data: {list_data}")
    insert_list_query = "INSERT INTO lists (name) VALUES (%s)"
    cursor.execute(insert_list_query, list_data)
    return cursor.lastrowid

def insert_team(cursor, team_data):
    print(f"Insert team data: {team_data}")
    insert_team_query = "INSERT INTO teams (theme_id, name, owner_id, shareable) VALUES (%s, %s, %s, %s)"
    cursor.execute(insert_team_query, team_data)
    return cursor.lastrowid

def insert_user(cursor, user_data):
    print(f"Insert user data: {user_data}")
    insert_user_query = "INSERT INTO users (email, password, nickname, avatar_id) VALUES (%s, %s, %s, %s)"
    cursor.execute(insert_user_query, user_data)
    return cursor.lastrowid

def insert_team2user(cursor, team2user_data):
    print(f"Insert team2user data: {team2user_data}")
    insert_team2user_query = "INSERT INTO team2user (team_id, user_id) VALUES (%s, %s)"
    cursor.execute(insert_team2user_query, team2user_data)
    return cursor.lastrowid

def insert_team2list(cursor, team2list_data):
    print(f"Insert team2list data: {team2list_data}")
    insert_team2list_query = "INSERT INTO team2list (team_id, list_id) VALUES (%s, %s)"
    cursor.execute(insert_team2list_query, team2list_data)
    return cursor.lastrowid

def insert_list2task(cursor, list2task_data):
    print(f"Insert list2task data: {list2task_data}")
    insert_list2task_query = "INSERT INTO list2task (task_id, list_id) VALUES (%s, %s)"
    cursor.execute(insert_list2task_query, list2task_data)
    return cursor.lastrowid

def insert_team_with_users(cursor, theme_id, owner_id, team_users_ids):
    print(f"Insert team with multiple users ids: {team_users_ids}")

    team_id = insert_team(cursor, [theme_id, "Team with all users", owner_id, False])

    for other_user_id in team_users_ids:
        insert_team2user(cursor, [team_id, other_user_id])


def insert_data(cursor):
    avatar_id = insert_avatar(cursor, [1])
    theme_id = insert_theme(cursor, [1])

    users_ids: list[int] = []
    teams_ids: list[int] = []

    for _ in range(USERS_COUNT):
        # insert user
        user_id = insert_user(cursor, [fake.email(), fake.password(), fake.name(), avatar_id])

        # insert non-shareable team
        team_id = insert_team(cursor, [theme_id, " ".join(fake.words(3)), user_id, False])

        users_ids.append(user_id)
        teams_ids.append(team_id)

        insert_team2user(cursor, [team_id, user_id])

        lists_count = fake.random_int(min=LISTS_COUNT_PER_TEAM[0], max=LISTS_COUNT_PER_TEAM[1])
        lists_ids = []

        # insert lists
        for _ in range(lists_count):
            list_id = insert_list(cursor, ["List '" + fake.word() + "'"])
            lists_ids.append(list_id)

            tasks_count = fake.random_int(min=TASKS_COUNT_PER_LIST[0], max=TASKS_COUNT_PER_LIST[1])
            tasks_ids = []

            insert_team2list(cursor, [team_id, list_id])

            # insert tasks
            for _ in range(tasks_count):
                task_type = fake.random_element(TASK_TYPES_ENUM)
                task_id = insert_task(
                    cursor,
                    [
                        "Task '" + fake.word() + "'",
                        "Description '" + " ".join(fake.words(5)) + "'",
                        user_id,
                        task_type,
                        False
                    ]
                )
                tasks_ids.append(task_id)

                if (task_type == 'DEADLINE'):
                    insert_deadline_task(cursor, [task_id])
                    print(f"Inserted deadline task: {task_id}")
                elif (task_type == 'HIGHLIGHTED'):
                    insert_highlighted_task(cursor, [task_id])
                    print(f"Inserted highlighted task: {task_id}")
                elif (task_type == 'RECURRENT'):
                    insert_recurrent_task(cursor, [task_id, fake.random_int(min=1, max=7)])
                    print(f"Inserted recurrent task: {task_id}")

                insert_list2task(cursor, [task_id, list_id])
            
            lists_ids.append(list_id)
            print(f"Inserted tasks ids {tasks_ids} to list {list_id}")
        
        print(f"Inserted lists ids {lists_ids} to team {team_id}")

    print(f"Inserted users ids: {users_ids}")
    print(f"Inserted teams ids: {teams_ids}")

    # insert team, containing all users
    if (len(users_ids) != 0):
        insert_team_with_users(cursor, theme_id, users_ids[0], users_ids)



def populate_data():
    with mysql.connector.connect(**db_config) as connection:
        # Create a cursor object to execute SQL commands
        with connection.cursor() as cursor:
            # create single avatar
            insert_data(cursor)
        
        connection.commit()
            

def execute_sql_script(script_file):
    with mysql.connector.connect(**db_config) as connection:
        # Create a cursor object to execute SQL commands
        with connection.cursor() as cursor:
            # Read the SQL commands from the specified script file
            with open(script_file, 'r') as sql_file:
                sql_commands = sql_file.read()

            # Split the script into individual SQL statements (assuming statements are separated by ';')
            sql_statements = sql_commands.split(';')
            for sql_statement in sql_statements:
                if sql_statement.strip():
                    cursor.execute(sql_statement)

            # Commit the changes to the database
            connection.commit()
            print(f"Script '{script_file}' executed successfully.")

# parse arguments
parser = argparse.ArgumentParser(description='Script to manage tables in a MySQL database and populate it with data')
parser.add_argument('--create-tables', type=str, help='Path to the tables initialization script')
parser.add_argument('--drop-tables', type=str, help='Path to the table drop script')
parser.add_argument('--populate-tables', action="store_true", help='Path to the table drop script')
args = parser.parse_args()


if args.create_tables:
    print(f"Creating tables in database: '{db_config['database']}' using '{args.create_tables}'")
    execute_sql_script(args.create_tables)

if args.populate_tables:
    print(f"Populating tables in database: '{db_config['database']}' with fake data")
    populate_data()

if args.drop_tables:
    print(f"Dropping tables in database: '{db_config['database']}' using '{args.drop_tables}'")
    execute_sql_script(args.drop_tables)
