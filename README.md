# MapRAG n8n Workflow

This repository contains an n8n workflow for geocoding addresses and managing location data with Google Sheets integration.

## Features

- **Geocoding**: Uses AI (Groq) to convert addresses to latitude/longitude coordinates
- **Google Sheets Integration**: Automatically updates spreadsheets with geocoded data
- **Webhook APIs**: Provides REST endpoints for data retrieval and location-based queries
- **Real-time Processing**: Triggers on Google Sheets changes and processes data automatically

## Workflow Components

### Main Workflow
- **Google Sheets Trigger**: Monitors spreadsheet changes
- **AI Agent**: Uses Groq's Llama model for geocoding addresses
- **Data Processing**: Extracts and normalizes coordinates
- **Sheet Updates**: Updates the original spreadsheet with new coordinates

### API Endpoints
- `GET /map/data`: Retrieve all location data
- `POST /map/query`: Query locations within a radius of a given point

## Deployment Options

### Option 1: Render (Recommended)

1. **Fork this repository** to your GitHub account
2. **Connect to Render**:
   - Go to [Render Dashboard](https://dashboard.render.com)
   - Click "New +" → "Web Service"
   - Connect your GitHub repository
   - Select this repository
3. **Configure Environment Variables**:
   ```
   N8N_BASIC_AUTH_PASSWORD=your-secure-password
   GROQ_API_KEY=your-groq-api-key
   GOOGLE_APPLICATION_CREDENTIALS_JSON=your-google-service-account-json
   ```
4. **Deploy**: Render will automatically build and deploy using the `render.yaml` configuration

### Option 2: Docker

#### Local Development
```bash
# Clone the repository
git clone <your-repo-url>
cd MapRAG

# Copy environment template
cp env.template .env

# Edit .env with your API keys
nano .env

# Start with Docker Compose
docker-compose up -d
```

#### Production Deployment
```bash
# Build the image
docker build -t n8n-workflow .

# Run the container
docker run -d \
  --name n8n-workflow \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_PASSWORD=your-password \
  -e GROQ_API_KEY=your-groq-key \
  -e GOOGLE_APPLICATION_CREDENTIALS_JSON='{"type":"service_account",...}' \
  n8n-workflow
```

## Configuration

### Required Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `N8N_BASIC_AUTH_PASSWORD` | Password for n8n admin access | Yes |
| `GROQ_API_KEY` | API key for Groq AI service | Yes |
| `GOOGLE_APPLICATION_CREDENTIALS_JSON` | Google service account JSON | Yes |
| `WEBHOOK_URL` | Public URL for webhooks (auto-set on Render) | Auto |

### Optional Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `N8N_BASIC_AUTH_USER` | Admin username | `admin` |
| `N8N_PORT` | Port for n8n to run on | `5678` |
| `GENERIC_TIMEZONE` | Timezone for n8n | `UTC` |

## API Usage

### Get All Location Data
```bash
curl https://your-app.onrender.com/map/data
```

### Query Locations by Radius
```bash
curl -X POST https://your-app.onrender.com/map/query \
  -H "Content-Type: application/json" \
  -d '{
    "latitude": 40.7128,
    "longitude": -74.0060,
    "radius": 10
  }'
```

## Google Sheets Setup

1. **Create a Google Sheet** with columns:
   - Serial No.
   - Name
   - Business Name
   - Type
   - Address
   - Email
   - Contact
   - Rates
   - Latitude (will be auto-populated)
   - Longitude (will be auto-populated)

2. **Set up Google Service Account**:
   - Go to [Google Cloud Console](https://console.cloud.google.com)
   - Create a new project or select existing
   - Enable Google Sheets API
   - Create a service account
   - Download the JSON credentials
   - Share your Google Sheet with the service account email

3. **Configure n8n**:
   - Import the workflow from `workflows/ushna-workflow.json`
   - Update the Google Sheets document ID in the workflow
   - Add your Google service account credentials

## Groq API Setup

1. **Get API Key**:
   - Sign up at [Groq Console](https://console.groq.com)
   - Create an API key
   - Add it to your environment variables

## Workflow Details

The workflow includes several key nodes:

1. **Google Sheets Trigger**: Monitors for new rows
2. **AI Agent**: Processes addresses using Groq's Llama model
3. **Data Processing**: Extracts coordinates from AI response
4. **Sheet Updates**: Updates the spreadsheet with new data
5. **API Endpoints**: Provides REST APIs for data access

## Troubleshooting

### Common Issues

1. **Authentication Errors**: Ensure your Google service account has proper permissions
2. **API Rate Limits**: Groq has rate limits; consider upgrading your plan
3. **Webhook Issues**: Verify the `WEBHOOK_URL` is correctly set
4. **Memory Issues**: The workflow may need more memory for large datasets

### Logs

Check the application logs in Render dashboard or Docker logs:
```bash
docker logs n8n-workflow
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues and questions:
- Check the [n8n documentation](https://docs.n8n.io)
- Review the workflow configuration
- Check environment variables and API keys
