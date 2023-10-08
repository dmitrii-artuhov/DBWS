import argparse
import mysql.connector


# MySQL connection parameters
db_config = {
    "database": "todo_list",
    "host": "localhost",
    "user": "root",
    "password": "123",
}

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
args = parser.parse_args()


if args.create_tables:
    print(f"Creating tables in database: '{db_config['database']}' using '{args.create_tables}'")
    execute_sql_script(args.create_tables)

if args.drop_tables:
    print(f"Dropping tables in database: '{db_config['database']}' using '{args.drop_tables}'")
    execute_sql_script(args.drop_tables)
