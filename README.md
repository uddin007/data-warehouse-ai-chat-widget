# Genie FastAPI Microservice

FastAPI service that wraps Databricks Genie APIs for Microsoft Teams integration.

##  Prerequisites

- Python 3.9+
- Azure CLI installed
- Databricks workspace with Genie Space configured
- Databricks Personal Access Token (PAT)

##  Local Development

### 1. Setup Environment

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Configure Environment Variables

Create a `.env` file:

```bash
export DATABRICKS_HOST="https://your-workspace.databricks.com"
export DATABRICKS_TOKEN="your-databricks-pat-token"
export SPACE_ID="your-genie-space-id"
```

Load environment variables:
```bash
source .env
```

### 3. Run Locally

```bash
# Start the server
python app.py
```

The API will be available at `http://localhost:8000`

### 4. Test Locally

```bash
# Open another terminal
python test_api.py
```

Or use curl:
```bash
curl -X POST http://localhost:8000/genie/query \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "question": "What are the total sales?"
  }'
```

##  API Documentation

Once running, visit:
- Swagger UI: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

##  Deploy to Azure App Service

### Method 1: Using Azure CLI (Recommended)

```bash
# 1. Login to Azure
az login

# 2. Set your subscription (if you have multiple)
az account set --subscription "your-subscription-id"

# 3. Deploy to your existing App Service
az webapp up \
  --name genie-web-app \
  --resource-group dataod-2026-rg \
  --runtime "PYTHON:3.12" \
  --sku B1

# 4. Configure environment variables
az webapp config appsettings set \
  --name genie-web-app \
  --resource-group dataod-2026-rg \
  --settings \
    DATABRICKS_HOST="https://your-workspace.databricks.com" \
    DATABRICKS_TOKEN="your-token" \
    SPACE_ID="your-space-id" \
    SCM_DO_BUILD_DURING_DEPLOYMENT=true

# 5. Configure startup command
az webapp config set \
  --name genie-web-app \
  --resource-group dataod-2026-rg \
  --startup-file "startup.sh"

# 6. Restart the app
az webapp restart \
  --name genie-web-app \
  --resource-group dataod-2026-rg
```

### Method 2: Using VS Code Azure Extension

1. Install "Azure App Service" extension in VS Code
2. Open this project folder in VS Code
3. Click Azure icon in sidebar
4. Right-click on your app service (`genie-web-app`)
5. Select "Deploy to Web App"
6. Configure environment variables in Azure Portal

### Method 3: Using Git Deployment

```bash
# 1. Initialize git (if not already)
git init
git add .
git commit -m "Initial commit"

# 2. Get deployment credentials
az webapp deployment list-publishing-credentials \
  --name genie-web-app \
  --resource-group dataod-2026-rg

# 3. Add Azure remote
git remote add azure https://<deployment-username>@genie-web-app.scm.azurewebsites.net/genie-web-app.git

# 4. Push to deploy
git push azure main
```

##  Configure Environment Variables in Azure Portal

1. Go to Azure Portal → Your App Service (`genie-web-app`)
2. Navigate to **Settings → Environment variables**
3. Click **+ Add** and add:
   - Name: `DATABRICKS_HOST`, Value: `https://your-workspace.databricks.com`
   - Name: `DATABRICKS_TOKEN`, Value: `your-pat-token`
   - Name: `SPACE_ID`, Value: `your-space-id`
4. Click **Apply** → **Confirm**

##  Verify Deployment

After deployment, test your service:

```bash
# Health check
curl https://genie-web-app.azurewebsites.net/health

# Test query
curl -X POST https://genie-web-app.azurewebsites.net/genie/query \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "test-user",
    "question": "What are the total sales?"
  }'
```

##  Monitoring

View logs in Azure Portal:
1. Go to your App Service
2. Navigate to **Monitoring → Log stream**
3. Select **Application logs**

Or use Azure CLI:
```bash
az webapp log tail \
  --name genie-web-app \
  --resource-group dataod-2026-rg
```

##  Troubleshooting

### Issue: App not starting
- Check logs: `az webapp log tail --name genie-web-app --resource-group dataod-2026-rg`
- Verify environment variables are set
- Ensure startup.sh is executable: `chmod +x startup.sh`

### Issue: Timeout errors
- Increase timeout in startup.sh (already set to 300s)
- Check Databricks network connectivity

### Issue: 502 Bad Gateway
- App might be starting up (wait 2-3 minutes)
- Check if Python version matches (3.12)
- Verify all dependencies are in requirements.txt

##  Architecture

```
Teams Bot
    ↓
FastAPI Service (this app)
    ↓
Databricks Genie APIs
```

##  API Endpoints

- `GET /` - Health check
- `GET /health` - Health check (alternative)
- `POST /genie/query` - Query Genie with a question
- `DELETE /genie/session/{user_id}` - Clear user session

##  Security Notes

- **Never commit tokens** - Use environment variables or Azure Key Vault
- **Use HTTPS** in production
- **Implement rate limiting** for production use
- **Add authentication** to verify Teams requests

##  Next Steps

1.  Deploy FastAPI service
2. Create Teams Bot (Node.js)
3. Register Azure Bot Service
4. Connect to Teams
5. Add Redis for session management
6. Implement rate limiting
7. Add Application Insights

##  Support

For issues, check:
- Application logs in Azure Portal
- Databricks Genie API status
- Network connectivity between Azure and Databricks
