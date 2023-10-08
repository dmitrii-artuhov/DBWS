echo "Ensure to use bash terminal on both POSIX and Windows systems in order for script to work properly."

if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose is not installed."
    exit 1
fi

echo "Running docker-compose..."
docker-compose -f ./docker/docker-compose.yaml up -d

echo "Creating python environment..."
python -m venv .venv

if [[ "$OSTYPE" == "linux-gnu" || "$OSTYPE" == "darwin"* ]]; then
    echo "Running on a POSIX-compliant system (Linux or macOS)"
    source .venv/bin/activate
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" ]]; then
    echo "Running on Windows"
    source .venv/Scripts/activate
else
    echo "Unknown OS, cannot start virtual environment"
    exit 1
fi

PIP_LOCATION=$(pip show pip | grep "Location*")
echo "Installing python dependencies using pip at: $PIP_LOCATION"
pip install -r requirements.txt

echo -e "\nNavigate to adminer panel at http://localhost:8080/ to view and manage MySQL database."

credentials=("System: MySQL" "Server: mysql" "Username: root" "Password: 123" "Database: todo_list")

echo "Login credentials:"
for item in "${credentials[@]}"; do
    echo "• $item"
done

