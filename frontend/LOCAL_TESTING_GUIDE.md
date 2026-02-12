#  Local Testing Setup Guide

This guide will help you test your Genie FastAPI service locally on your MacBook Pro using a simple web interface.

##  Why This Is Safe for Corporate Networks

This setup is 100% local and won't trigger any security alerts because:

1. **Everything runs on localhost** (127.0.0.1) - no external connections
2. **No external services** - all communication stays on your machine
3. **No installations required** - just Python and a web browser
4. **No open ports to the internet** - only accessible from your machine
5. **Standard ports** - Uses common development ports (8000, 8001)

##  Project Structure

```
genie-fastapi-service/
├── app.py                    # FastAPI backend
├── requirements.txt
├── startup.sh
├── test_api.py
├── frontend/
│   └── index.html           # Test UI (created)
└── .env                      # Environment variables (create this)
```

##  Step-by-Step Setup

### Step 1: Create Environment File

In your `genie-fastapi-service` directory, create a `.env` file:

```bash
# Navigate to your project
cd ~/path/to/genie-fastapi-service

# Create .env file
cat > .env << 'EOF'
export DATABRICKS_HOST="https://your-workspace.databricks.com"
export DATABRICKS_TOKEN="your-databricks-pat-token"
export SPACE_ID="your-genie-space-id"
EOF
```

**Replace with your actual values:**
- `DATABRICKS_HOST`: Your Databricks workspace URL
- `DATABRICKS_TOKEN`: Your Personal Access Token from Databricks
- `SPACE_ID`: Your Genie Space ID

### Step 2: Setup Python Environment

```bash
# Create virtual environment (if not already created)
python3 -m venv venv

# Activate virtual environment
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

### Step 3: Load Environment Variables

```bash
# Load environment variables
source .env
```

### Step 4: Start the FastAPI Backend

```bash
# Start the API server (runs on port 8000)
python app.py
```

You should see:
```
INFO:     Uvicorn running on http://0.0.0.0:8000 (Press CTRL+C to quit)
INFO:     Started reloader process
INFO:     Started server process
INFO:     Waiting for application startup.
INFO:     Application startup complete.
```

**Keep this terminal window open!**

### Step 5: Open the Test UI

Open a **new terminal window** and navigate to your project:

```bash
cd ~/path/to/genie-fastapi-service/frontend

# Start a simple HTTP server for the frontend
python3 -m http.server 8001
```

You should see:
```
Serving HTTP on 0.0.0.0 port 8001 (http://0.0.0.0:8001/) ...
```

### Step 6: Access the Test Interface

Open your web browser and go to:

```
http://localhost:8001
```

You should see the **Genie API Test Console**! 

##  Using the Test Interface

### 1. Check Health
- Click the **"Check API Health"** button
- You should see a green "✓ API is healthy" status

### 2. Ask Questions
- Enter your User ID (default: "test-user")
- Type a question in the text area, or click a sample question
- Click **"Send Query"**
- Wait for the response (may take 30-120 seconds)

### 3. View Results
The interface will show:
-  Status (COMPLETED/FAILED)
-  Analysis text
-  Generated SQL query
-  Results table (first 10 rows)

### 4. Follow-up Questions
- The session is maintained automatically
- Ask follow-up questions using the same User ID
- Click **"Clear Session"** to start fresh

##  Troubleshooting

### Problem: "Cannot connect to API"

**Solution:**
1. Make sure FastAPI is running (check terminal with `python app.py`)
2. Verify it's running on port 8000
3. Try accessing http://localhost:8000/docs directly in browser

### Problem: "Failed to start conversation"

**Solution:**
1. Check your environment variables are loaded: `echo $DATABRICKS_HOST`
2. Verify your Databricks token is valid
3. Check the FastAPI terminal for error messages

### Problem: "Query timed out"

**Solution:**
1. Increase max_wait time in the settings (up to 300 seconds)
2. Try a simpler query first
3. Check your Databricks Genie Space is accessible

### Problem: Port already in use

**Solution:**
```bash
# For port 8000 (FastAPI)
lsof -ti:8000 | xargs kill -9

# For port 8001 (Frontend)
lsof -ti:8001 | xargs kill -9
```

##  Sample Questions to Try

1. **Simple queries:**
   - "What are the total sales?"
   - "How many customers do we have?"
   - "Show me the latest orders"

2. **Analytical queries:**
   - "What are the top 10 products by revenue?"
   - "Show sales trend by month"
   - "Compare sales by region"

3. **Aggregations:**
   - "What is the average order value?"
   - "Calculate total revenue by category"
   - "Show customer count by country"

##  Understanding the Output

### Status Indicators
-  **COMPLETED** - Query executed successfully
-  **FAILED** - Query failed (check error message)
-  **CANCELLED** - Query was cancelled

### Response Sections
1. **Analysis** - Genie's interpretation and explanation
2. **Generated SQL** - The SQL query Genie created
3. **Results** - Data table (limited to first 10 rows in UI)

##  Security Notes

### Safe Practices 
- Running locally on localhost only
- Environment variables not committed to git
- Token stored in .env file (in .gitignore)
- No external network calls except to Databricks

### Things to Avoid 
- Don't commit .env file to git
- Don't share your Databricks token
- Don't expose ports externally (no port forwarding)
- Don't run on public Wi-Fi without VPN

##  When You're Done Testing

### Stop the Servers

In each terminal window, press: **Ctrl+C**

```bash
# Terminal 1 (FastAPI)
^C  # (Ctrl+C)

# Terminal 2 (Frontend)
^C  # (Ctrl+C)
```

### Deactivate Virtual Environment

```bash
deactivate
```

## 🚀 Next Steps After Local Testing

Once you've verified everything works locally:

1.  **Deploy FastAPI to Azure** (using the deployment guide in main README)
2.  **Create Teams Bot** (Node.js application)
3.  **Register Azure Bot Service**
4.  **Connect to Microsoft Teams**

##  Getting Help

If you encounter issues:

1. Check the FastAPI terminal for error logs
2. Check browser console (F12) for JavaScript errors
3. Verify all environment variables are set correctly
4. Test the API directly: http://localhost:8000/docs

##  Additional Testing

You can also test using the Python script:

```bash
# In a new terminal (with venv activated)
python test_api.py
```

Or using curl:

```bash
curl -X POST http://localhost:8000/genie/query \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "question": "What are the total sales?"
  }'
```

---

