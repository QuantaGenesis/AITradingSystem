#!/bin/bash
set -e

# Repository URLs
BACKEND_REPO="https://github.com/QuantaGenesis/AITradingSystem-backend.git"
FRONTEND_REPO="https://github.com/QuantaGenesis/AITradingSystem-frontend.git"

echo "======================================================"
echo "   QuantaGenesis AITradingSystem Management Script    "
echo "======================================================"
echo ""

prompt_with_default() {
    local prompt="$1"
    local default_val="$2"
    local var_name="$3"
    
    read -p "$prompt [$default_val]: " input_val
    if [ -z "$input_val" ]; then
        eval "$var_name=\"$default_val\""
    else
        eval "$var_name=\"$input_val\""
    fi
}

COMMAND=$1

if [ -z "$COMMAND" ] || { [ "$COMMAND" != "setup" ] && [ "$COMMAND" != "start" ]; }; then
    echo "Usage: ./install.sh [setup|start]"
    echo ""
    echo "  setup   - Interactively configure and install dependencies."
    echo "  start   - Start the application (requires setup first)."
    exit 1
fi

# ==============================================================================
# SETUP COMMAND
# ==============================================================================
if [ "$COMMAND" = "setup" ]; then

    echo "Select Installation Mode:"
    echo "1) Direct Installation (Bare-metal without Docker)"
    echo "2) Docker Installation (Self-hosted Database or External Database)"
    echo "3) Exit"
    read -p "Choice [1-3]: " INSTALL_MODE
    
    if [ "$INSTALL_MODE" = "3" ]; then
        echo "Exiting."
        exit 0
    fi
    
    if [ "$INSTALL_MODE" != "1" ] && [ "$INSTALL_MODE" != "2" ]; then
        echo "Invalid choice. Exiting."
        exit 1
    fi
    
    echo $INSTALL_MODE > .install_mode
    
    echo ""
    echo "[+] Checking and cloning repositories in current folder..."
    for repo in "$BACKEND_REPO" "$FRONTEND_REPO"; do
        repo_name=$(basename "$repo" .git)
        if [ ! -d "$repo_name" ]; then
            echo "    Cloning $repo_name..."
            git clone "$repo"
        else
            echo "    $repo_name already exists. Skipping clone."
        fi
    done
    
    echo ""
    echo "======================================================"
    echo "   General Configuration                              "
    echo "======================================================"
    prompt_with_default "Enter Admin Username" "admin" ADMIN_USERNAME
    prompt_with_default "Enter Admin Password" "admin" ADMIN_PASSWORD
    prompt_with_default "Enter CORS Origins" "*" CORS_ORIGINS
    prompt_with_default "Enter Frontend Port on Host" "3333" FRONTEND_PORT
    prompt_with_default "Enter VITE_API_BASE_URL" "http://localhost:8000" VITE_API_BASE_URL
    prompt_with_default "Enter Order Sync Interval (seconds)" "60" ORDER_SYNC_INTERVAL_S
    prompt_with_default "Enable Experience Extraction? (true/false)" "true" EXPERIENCE_EXTRACTION_ENABLED
    prompt_with_default "Enter Experience Extraction Interval (seconds)" "300" EXPERIENCE_EXTRACTION_INTERVAL_S
    prompt_with_default "Enter Experience LLM Model" "" EXPERIENCE_LLM_MODEL

    DEFAULT_SECRET=$(python3 -c "import secrets; print(secrets.token_hex(32))" 2>/dev/null || openssl rand -hex 32 || echo "super-secret-key-$(date +%s)")
    prompt_with_default "Enter AUTH_SECRET (JWT signing key)" "$DEFAULT_SECRET" AUTH_SECRET
    
    # DIRECT SETUP
    if [ "$INSTALL_MODE" = "1" ]; then
        echo ""
        echo "======================================================"
        echo "   Direct Installation Setup                          "
        echo "======================================================"
        
        # Check dependencies
        for cmd in python3 uv node pnpm; do
            if ! command -v $cmd &> /dev/null; then
                echo "[!] $cmd is not installed or not in PATH."
                echo "    Please install $cmd first."
                exit 1
            fi
        done
        
        prompt_with_default "Enter Database URL/Path" "postgresql://postgres:password@localhost:5432/tradingos" DB_URL
        
        # Write .env at root
        cat << EOF > .env
DATABASE_URL=${DB_URL}
AUTH_SECRET=${AUTH_SECRET}
ADMIN_USERNAME=${ADMIN_USERNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
CORS_ORIGINS=${CORS_ORIGINS}
FRONTEND_PORT=${FRONTEND_PORT}
VITE_API_BASE_URL=${VITE_API_BASE_URL}
ORDER_SYNC_INTERVAL_S=${ORDER_SYNC_INTERVAL_S}
EXPERIENCE_EXTRACTION_ENABLED=${EXPERIENCE_EXTRACTION_ENABLED}
EXPERIENCE_EXTRACTION_INTERVAL_S=${EXPERIENCE_EXTRACTION_INTERVAL_S}
EXPERIENCE_LLM_MODEL=${EXPERIENCE_LLM_MODEL}
EOF

        cp .env AITradingSystem-backend/.env
        echo "VITE_API_BASE_URL=${VITE_API_BASE_URL}" > AITradingSystem-frontend/.env
        
        echo ""
        echo "[+] Installing Backend Dependencies with uv..."
        cd AITradingSystem-backend
        uv sync
        cd ..
        
        echo ""
        echo "[+] Installing Frontend Dependencies..."
        cd AITradingSystem-frontend
        pnpm install
        pnpm run build
        cd ..
        
    # DOCKER SETUP
    elif [ "$INSTALL_MODE" = "2" ]; then
        echo ""
        echo "======================================================"
        echo "   Docker Installation Setup                          "
        echo "======================================================"
        
        if ! command -v docker &> /dev/null; then
            echo "[!] Docker is not installed. Please install Docker first."
            exit 1
        fi
        
        echo "Select Database Setup:"
        echo "1) Use existing Database URL/Path (External Database)"
        echo "2) Install Database in Docker (Self-hosted)"
        prompt_with_default "Choice" "2" DB_MODE
        
        if [ "$DB_MODE" = "1" ]; then
            prompt_with_default "Enter Database URL/Path" "postgresql://postgres:password@localhost:5432/tradingos" DB_URL
            DB_PASS=""
        else
            prompt_with_default "Enter PostgreSQL Password for Docker" "securepassword" DB_PASS
            DB_URL="postgresql+psycopg://postgres:${DB_PASS}@database:5432/tradingos"
        fi
        
        # Write .env at root
        cat << EOF > .env
DATABASE_URL=${DB_URL}
POSTGRES_PASSWORD=${DB_PASS}
AUTH_SECRET=${AUTH_SECRET}
ADMIN_USERNAME=${ADMIN_USERNAME}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
CORS_ORIGINS=${CORS_ORIGINS}
FRONTEND_PORT=${FRONTEND_PORT}
VITE_API_BASE_URL=${VITE_API_BASE_URL}
ORDER_SYNC_INTERVAL_S=${ORDER_SYNC_INTERVAL_S}
EXPERIENCE_EXTRACTION_ENABLED=${EXPERIENCE_EXTRACTION_ENABLED}
EXPERIENCE_EXTRACTION_INTERVAL_S=${EXPERIENCE_EXTRACTION_INTERVAL_S}
EXPERIENCE_LLM_MODEL=${EXPERIENCE_LLM_MODEL}
EOF

        cp .env AITradingSystem-backend/.env
        echo "VITE_API_BASE_URL=${VITE_API_BASE_URL}" > AITradingSystem-frontend/.env
        
        if [ "$DB_MODE" = "1" ]; then
            # Generate docker-compose without DB
            cat << 'EOF' > docker-compose.yml
services:
  backend:
    build:
      context: ./AITradingSystem-backend
      dockerfile: Dockerfile
    image: tradingos-backend:latest
    container_name: tradingos-backend
    restart: unless-stopped
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - AUTH_SECRET=${AUTH_SECRET}
      - ADMIN_USERNAME=${ADMIN_USERNAME}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - CORS_ORIGINS=${CORS_ORIGINS}
      - ORDER_SYNC_INTERVAL_S=${ORDER_SYNC_INTERVAL_S}
      - EXPERIENCE_EXTRACTION_ENABLED=${EXPERIENCE_EXTRACTION_ENABLED}
      - EXPERIENCE_EXTRACTION_INTERVAL_S=${EXPERIENCE_EXTRACTION_INTERVAL_S}
      - EXPERIENCE_LLM_MODEL=${EXPERIENCE_LLM_MODEL}
    ports:
      - "127.0.0.1:8000:8000"
    volumes:
      - backend_data:/app/data

  frontend:
    build:
      context: ./AITradingSystem-frontend
      dockerfile: Dockerfile
      args:
        - VITE_API_BASE_URL=${VITE_API_BASE_URL}
    image: tradingos-frontend:latest
    container_name: tradingos-frontend
    restart: unless-stopped
    ports:
      - "127.0.0.1:${FRONTEND_PORT:-3333}:80"
    depends_on:
      - backend

volumes:
  backend_data:
EOF
            echo "[+] Created docker-compose.yml (External Database)"
            
        else
            # Generate docker-compose with DB
            cat << 'EOF' > docker-compose.yml
services:
  database:
    image: pgvector/pgvector:pg17-trixie
    container_name: tradingos-db
    restart: unless-stopped
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DB: tradingos
    volumes:
      - postgres_data_ai:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres -d tradingos"]
      interval: 5s
      timeout: 5s
      retries: 10
      start_period: 10s

  backend:
    build:
      context: ./AITradingSystem-backend
      dockerfile: Dockerfile
    image: tradingos-backend:latest
    container_name: tradingos-backend
    restart: unless-stopped
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - AUTH_SECRET=${AUTH_SECRET}
      - ADMIN_USERNAME=${ADMIN_USERNAME}
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - CORS_ORIGINS=${CORS_ORIGINS}
      - ORDER_SYNC_INTERVAL_S=${ORDER_SYNC_INTERVAL_S}
      - EXPERIENCE_EXTRACTION_ENABLED=${EXPERIENCE_EXTRACTION_ENABLED}
      - EXPERIENCE_EXTRACTION_INTERVAL_S=${EXPERIENCE_EXTRACTION_INTERVAL_S}
      - EXPERIENCE_LLM_MODEL=${EXPERIENCE_LLM_MODEL}
    ports:
      - "127.0.0.1:8000:8000"
    depends_on:
      database:
        condition: service_healthy
    volumes:
      - backend_data:/app/data

  frontend:
    build:
      context: ./AITradingSystem-frontend
      dockerfile: Dockerfile
      args:
        - VITE_API_BASE_URL=${VITE_API_BASE_URL}
    image: tradingos-frontend:latest
    container_name: tradingos-frontend
    restart: unless-stopped
    ports:
      - "127.0.0.1:${FRONTEND_PORT:-3333}:80"
    depends_on:
      - backend

volumes:
  postgres_data_ai:
  backend_data:
EOF
            echo "[+] Created docker-compose.yml (Self-hosted Database)"
        fi
        
        echo ""
        echo "[+] Building Docker Containers..."
        docker compose build
    fi
    
    echo ""
    echo "======================================================"
    echo "   Setup Complete!                                    "
    echo "======================================================"
    echo "To start the application, run:"
    echo "  ./install.sh start"
    echo ""
    exit 0
fi

# ==============================================================================
# START COMMAND
# ==============================================================================
if [ "$COMMAND" = "start" ]; then
    
    if [ ! -f ".install_mode" ] || [ ! -d "AITradingSystem-backend" ] || [ ! -d "AITradingSystem-frontend" ]; then
        echo "[!] The project does not appear to be fully installed."
        echo "    Please run './install.sh setup' first."
        exit 1
    fi
    
    INSTALL_MODE=$(cat .install_mode)
    
    # Load environment variables from root .env if it exists
    if [ -f ".env" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip comments and empty lines
            if [[ ! "$line" =~ ^# ]] && [[ ! -z "$line" ]]; then
                # Only export lines containing '='
                if [[ "$line" == *"="* ]]; then
                    export "$line"
                fi
            fi
        done < .env
    fi
    
    FRONTEND_PORT=${FRONTEND_PORT:-3333}
    
    if [ "$INSTALL_MODE" = "1" ]; then
        echo "[+] Starting Backend (localhost:8000)..."
        cd AITradingSystem-backend
        nohup uv run app/main.py --host 127.0.0.1 --port 8000 > backend.log 2>&1 &
        echo $! > backend.pid
        cd ..
        
        echo "[+] Starting Frontend Preview (localhost:${FRONTEND_PORT})..."
        cd AITradingSystem-frontend
        nohup pnpm run preview --host 127.0.0.1 --port ${FRONTEND_PORT} > frontend.log 2>&1 &
        echo $! > frontend.pid
        cd ..
        
        echo ""
        echo "======================================================"
        echo "   Application Started!                               "
        echo "======================================================"
        echo "Backend is running in the background (PID: $(cat AITradingSystem-backend/backend.pid))"
        echo "Frontend is running in the background (PID: $(cat AITradingSystem-frontend/frontend.pid))"
        echo ""
        echo "Access the frontend at: http://127.0.0.1:${FRONTEND_PORT}"
        echo "Access the backend API at: http://127.0.0.1:8000"
        echo ""
        echo "Logs are available in AITradingSystem-backend/backend.log and AITradingSystem-frontend/frontend.log"
        echo ""
        
    elif [ "$INSTALL_MODE" = "2" ]; then
        echo "[+] Starting Docker Containers..."
        docker compose up -d
        
        echo ""
        echo "======================================================"
        echo "   Application Started!                               "
        echo "======================================================"
        echo "Backend is running at: http://127.0.0.1:8000"
        echo "Frontend is running at: http://127.0.0.1:${FRONTEND_PORT}"
        echo ""
        echo "Use 'docker compose logs -f' to view logs."
    fi
fi
