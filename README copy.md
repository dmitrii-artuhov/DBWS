# Todo List Application

## Participants:
- Dmitrii Artiukhov (dartiukhov@constructor.university)
- Aleksei Vantorin (avantorin@constructor.university)
- Nikolai Vladimirov (nvladimirov@constructor.university)

## HW 3

You can find the queries and logs in `scripts/hw3` folder:
- `initial_logs.txt`: contains data that database was populated with.
- `logs.txt`: contains logs from execution of commands from `scripts/hw3/hw3.sql`.

## Setup:
Project uses `docker/docker-compose.yaml` file in order to setup `MySQL` databse server and `Adminer` web client for managing the database. There is also a python script that creates/drops tables and populates them with data: `scripts/python/populate_database.py`.

- **Fast setup** (runs docker-compose, setups python virtual environment, and installs dependencies from `requirements.txt` using `pip`):
    ```sh
    ./setup.sh
    ```
- **Manual setup**:
    - Create docker containers for `MySQL` and `Adminer` and run them:
        ```sh
        docker-compose -f ./docker/docker-compose.yaml up -d
        ```
    - Setup python virtual environment:
        ```sh
        python -m venv .venv
        source .venv/bin/activate # for POSIX
        # `source .venv/Scripts/activate` for Windows using bash terminal emulator
        ```
    - Install python dependencies:
        ```sh
        pip install -r requirements.txt
        ```

## Usage:

After running docker-compose `Adminer` panel will be available at http://localhost:8080/. Use login credentials from `docker/docker-compose.yaml` file in order to view and manage database (field `Server` must have the same value as MySQL service name in `.yaml` file, which is `mysql`).

To get usage guide for the python script which populates database, run: `python ./scripts/python/populate_database.py --help`.