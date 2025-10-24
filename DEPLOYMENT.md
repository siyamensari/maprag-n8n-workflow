# Deployment Guide for MapRAG n8n Workflow

This guide provides step-by-step instructions for deploying the MapRAG n8n workflow to Render.

## Prerequisites

Before deploying, ensure you have:

1. **GitHub Account**: For hosting the repository
2. **Render Account**: Sign up at [render.com](https://render.com)
3. **Groq API Key**: Get from [console.groq.com](https://console.groq.com)
4. **Google Service Account**: For Google Sheets integration

## Step 1: Create GitHub Repository

### Option A: Using GitHub CLI
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit: n8n workflow for MapRAG"

# Create repository on GitHub
gh repo create MapRAG --public --source=. --remote=origin --push
```

### Option B: Using GitHub Web Interface
1. Go to [GitHub](https://github.com) and click "New repository"
2. Name it `MapRAG` (or your preferred name)
3. Make it public
4. Don't initialize with README (we already have files)
5. Click "Create repository"
6. Follow the instructions to push your local code

## Step 2: Set Up Google Service Account

1. **Go to Google Cloud Console**:
   - Visit [console.cloud.google.com](https://console.cloud.google.com)
   - Create a new project or select existing one

2. **Enable APIs**:
   - Go to "APIs & Services" → "Library"
   - Search for "Google Sheets API" and enable it
   - Search for "Google Drive API" and enable it

3. **Create Service Account**:
   - Go to "IAM & Admin" → "Service Accounts"
   - Click "Create Service Account"
   - Name: `n8n-sheets-service`
   - Description: `Service account for n8n Google Sheets integration`
   - Click "Create and Continue"

4. **Generate Key**:
   - Click on the created service account
   - Go to "Keys" tab
   - Click "Add Key" → "Create new key"
   - Choose "JSON" format
   - Download the JSON file

5. **Share Google Sheet**:
   - Open your Google Sheet
   - Click "Share" button
   - Add the service account email (from the JSON file)
   - Give "Editor" permissions

## Step 3: Get Groq API Key

1. **Sign up for Groq**:
   - Go to [console.groq.com](https://console.groq.com)
   - Create an account or sign in

2. **Create API Key**:
   - Go to "API Keys" section
   - Click "Create API Key"
   - Copy the key (you'll need it for deployment)

## Step 4: Deploy to Render

### Method 1: Using render.yaml (Recommended)

1. **Connect Repository**:
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub account
   - Select your `MapRAG` repository

2. **Configure Service**:
   - Name: `maprag-n8n` (or your preferred name)
   - Region: Choose closest to your users
   - Branch: `main` or `master`
   - Root Directory: Leave empty
   - Build Command: Leave empty (using Dockerfile)
   - Start Command: Leave empty (using Dockerfile)

3. **Set Environment Variables**:
   ```
   N8N_BASIC_AUTH_PASSWORD=your-secure-password-here
   GROQ_API_KEY=your-groq-api-key-here
   GOOGLE_APPLICATION_CREDENTIALS_JSON={"type":"service_account","project_id":"your-project",...}
   ```

4. **Deploy**:
   - Click "Create Web Service"
   - Render will automatically build and deploy
   - Wait for deployment to complete (5-10 minutes)

### Method 2: Manual Configuration

If you prefer manual setup:

1. **Create Web Service**:
   - Go to Render Dashboard
   - Click "New +" → "Web Service"
   - Connect GitHub repository

2. **Configure Build**:
   - Environment: `Docker`
   - Dockerfile Path: `./Dockerfile`
   - Plan: `Starter` (free tier)

3. **Set Environment Variables**:
   - Add all required environment variables
   - Use the same values as Method 1

## Step 5: Configure n8n Workflow

After deployment:

1. **Access n8n Interface**:
   - Go to your Render service URL
   - Login with admin credentials
   - Username: `admin`
   - Password: (the one you set in environment variables)

2. **Import Workflow**:
   - Go to "Workflows" tab
   - Click "Import from file"
   - Upload `workflows/ushna-workflow.json`

3. **Configure Credentials**:
   - Go to "Credentials" tab
   - Add Google Sheets OAuth2 credentials
   - Add Groq API credentials
   - Test connections

4. **Update Workflow**:
   - Open the imported workflow
   - Update Google Sheets document ID
   - Update any hardcoded URLs
   - Save and activate the workflow

## Step 6: Test Deployment

### Test Basic Functionality
```bash
# Test health endpoint
curl https://your-app-name.onrender.com/healthz

# Test data endpoint
curl https://your-app-name.onrender.com/map/data
```

### Test Webhook Endpoints
```bash
# Test query endpoint
curl -X POST https://your-app-name.onrender.com/map/query \
  -H "Content-Type: application/json" \
  -d '{
    "latitude": 40.7128,
    "longitude": -74.0060,
    "radius": 10
  }'
```

## Step 7: Monitor and Maintain

### Monitoring
- Check Render dashboard for service status
- Monitor logs for errors
- Set up alerts for downtime

### Updates
- Push changes to your GitHub repository
- Render will automatically redeploy
- Test thoroughly after updates

### Scaling
- Upgrade Render plan for more resources
- Consider database for production use
- Implement proper logging and monitoring

## Troubleshooting

### Common Issues

1. **Build Failures**:
   - Check Dockerfile syntax
   - Verify all files are committed
   - Check Render build logs

2. **Authentication Errors**:
   - Verify Google service account setup
   - Check API key permissions
   - Ensure sheet is shared with service account

3. **Webhook Issues**:
   - Verify WEBHOOK_URL is set correctly
   - Check n8n webhook configuration
   - Test webhook endpoints manually

4. **Memory Issues**:
   - Upgrade Render plan
   - Optimize workflow for large datasets
   - Consider database storage

### Getting Help

- Check [n8n Documentation](https://docs.n8n.io)
- Review [Render Documentation](https://render.com/docs)
- Check application logs in Render dashboard
- Test locally with Docker Compose first

## Security Considerations

1. **Change Default Password**: Use a strong, unique password
2. **API Key Security**: Never commit API keys to repository
3. **Access Control**: Limit access to n8n interface
4. **HTTPS**: Render provides HTTPS by default
5. **Regular Updates**: Keep n8n and dependencies updated

## Cost Optimization

1. **Free Tier Limits**: Monitor usage on Render free tier
2. **Auto-sleep**: Free tier services sleep after inactivity
3. **Upgrade When Needed**: Scale up for production use
4. **Database**: Consider external database for persistence

This completes the deployment setup. Your n8n workflow should now be running on Render and accessible via the provided URL.
