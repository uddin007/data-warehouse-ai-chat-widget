#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Genie API Local Test Environment    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if .env exists
if [ ! -f ".env" ]; then
    echo -e "${RED} Error: .env file not found${NC}"
    echo -e "${YELLOW}Please create a .env file with your Databricks credentials:${NC}"
    echo ""
    echo "export DATABRICKS_HOST=\"https://your-workspace.databricks.com\""
    echo "export DATABRICKS_TOKEN=\"your-databricks-token\""
    echo "export SPACE_ID=\"your-space-id\""
    echo ""
    exit 1
fi

# Load environment variables
echo -e "${BLUE} Loading environment variables...${NC}"
source .env

# Check if venv exists
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}  Virtual environment not found. Creating one...${NC}"
    python3 -m venv venv
    source venv/bin/activate
    echo -e "${BLUE} Installing dependencies...${NC}"
    pip install -r requirements.txt
else
    source venv/bin/activate
fi

# Check if required variables are set
if [ -z "$DATABRICKS_HOST" ] || [ -z "$DATABRICKS_TOKEN" ] || [ -z "$SPACE_ID" ]; then
    echo -e "${RED} Error: Missing required environment variables${NC}"
    echo "Please check your .env file"
    exit 1
fi

echo -e "${GREEN}✓ Environment configured${NC}"
echo ""
echo -e "${BLUE} Starting servers...${NC}"
echo ""

# Function to cleanup on exit
cleanup() {
    echo ""
    echo -e "${YELLOW} Shutting down servers...${NC}"
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN} Servers stopped${NC}"
    exit 0
}

trap cleanup EXIT INT TERM

# Start FastAPI backend in background
echo -e "${BLUE}Starting FastAPI backend on port 8000...${NC}"
python app.py > /tmp/fastapi.log 2>&1 &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 3

# Check if backend started successfully
if ! lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${RED} Failed to start FastAPI backend${NC}"
    echo "Check /tmp/fastapi.log for errors"
    exit 1
fi

echo -e "${GREEN}✓ FastAPI backend running (PID: $BACKEND_PID)${NC}"

# Start frontend server in background
echo -e "${BLUE}Starting frontend server on port 8001...${NC}"
cd frontend
python3 -m http.server 8001 > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..

# Wait a moment for frontend to start
sleep 2

# Check if frontend started successfully
if ! lsof -Pi :8001 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo -e "${RED} Failed to start frontend server${NC}"
    kill $BACKEND_PID
    exit 1
fi

echo -e "${GREEN}✓ Frontend server running (PID: $FRONTEND_PID)${NC}"
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       All systems ready!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📍 Access points:${NC}"
echo -e "   Frontend UI:  ${GREEN}http://localhost:8001${NC}"
echo -e "   API Docs:     ${GREEN}http://localhost:8000/docs${NC}"
echo -e "   API Health:   ${GREEN}http://localhost:8000/health${NC}"
echo ""
echo -e "${YELLOW} Tips:${NC}"
echo -e "   • Open ${GREEN}http://localhost:8001${NC} in your browser"
echo -e "   • Press ${RED}Ctrl+C${NC} to stop both servers"
echo -e "   • Check logs at /tmp/fastapi.log and /tmp/frontend.log"
echo ""
echo -e "${BLUE}Waiting... (Press Ctrl+C to stop)${NC}"

# Keep script running
wait
