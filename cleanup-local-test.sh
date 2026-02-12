#!/bin/bash

echo " Cleaning up Genie local test environment..."

# Kill servers on ports
echo "Stopping servers on ports 8000 and 8001..."
lsof -ti:8000 | xargs kill -9 2>/dev/null
lsof -ti:8001 | xargs kill -9 2>/dev/null

# Kill any Python processes with our app names
echo "Stopping related Python processes..."
pkill -f "app.py" 2>/dev/null
pkill -f "http.server 8001" 2>/dev/null
pkill -f "uvicorn" 2>/dev/null

# Clear environment variables
echo "Clearing environment variables..."
unset DATABRICKS_HOST
unset DATABRICKS_TOKEN
unset SPACE_ID

# Remove log files
echo "Removing log files..."
rm -f /tmp/fastapi.log
rm -f /tmp/frontend.log

# Deactivate venv if active
if [ -n "$VIRTUAL_ENV" ]; then
    echo "Deactivating virtual environment..."
    deactivate
fi

echo " Cleanup complete!"
echo ""
echo "Verification:"
echo "Port 8000: $(lsof -ti:8000 | wc -l | xargs echo) processes"
echo "Port 8001: $(lsof -ti:8001 | wc -l | xargs echo) processes"
echo ""
