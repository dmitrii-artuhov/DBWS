# Todo List Application

## Participants:
- Dmitrii Artiukhov (dartiukhov@constructor.university)
- Aleksei Vantorin (avantorin@constructor.university)
- Nikolai Vladimirov (nvladimirov@constructor.university)

## Setup:
Project uses `docker/docker-compose.yaml` file in order to setup `MySQL` databse server and `Adminer` web client for managing the database. There is also a python script that creates/drops tables and populates them with data: `scripts/python/populate_database.py`.

- **Fast setup** (runs docker-compose, setups python virtual environment, and installs dependencies from `requirements.txt` using `pip`):
    ```sh
    chmod +x setup.sh
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

`Adminer` panel available at http://localhost:8080/, use login credentials from `docker/docker-compose.yaml` file (field `Server` must have the same value as MySQL service name in `.yaml` file, which is `mysql`).

To get usage guide for the python script which populates database, run: `python ./scripts/python/populate_database.py --help`.