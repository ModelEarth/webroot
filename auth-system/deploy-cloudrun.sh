#!/bin/bash

# Google Cloud Run Deployment Script for Auth Service
# Deploys the Node.js OAuth authentication service to Google Cloud Run

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
PROJECT_ID="${GOOGLE_CLOUD_PROJECT_ID:-webroot-earth}"
SERVICE_NAME="webroot-auth"
REGION="${GOOGLE_CLOUD_REGION:-us-central1}"
IMAGE_NAME="auth-system"

echo -e "${GREEN}Starting deployment for Auth Service${NC}"
echo -e "${YELLOW}Config values:${NC}"
echo "  PROJECT_ID: ${PROJECT_ID}"
echo "  SERVICE_NAME: ${SERVICE_NAME}"
echo "  IMAGE_NAME: ${IMAGE_NAME}"
echo "  REGION: ${REGION}"

# Check if gcloud is installed
if ! command -v gcloud >/dev/null 2>&1; then
    echo -e "${RED}Error: gcloud CLI is not installed${NC}"
    echo "Please install Google Cloud SDK: https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if .env.production exists
if [ ! -f .env.production ]; then
    echo -e "${RED}Error: .env.production file not found${NC}"
    echo "Please create .env.production with your production settings"
    echo "You can copy .env.production.example and fill in your values"
    exit 1
fi

# Load production environment variables
echo -e "${GREEN}Loading production environment variables...${NC}"
export $(grep -v '^#' .env.production | xargs)

# Validate required environment variables
REQUIRED_VARS=("JWT_SECRET" "FRONTEND_URL")
for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo -e "${RED}Error: Required environment variable $var is not set in .env.production${NC}"
        exit 1
    fi
done

# Set the project
echo -e "${GREEN}Setting project to ${PROJECT_ID}${NC}"
gcloud config set project ${PROJECT_ID}

# Enable required APIs
echo -e "${GREEN}Enabling required APIs...${NC}"
gcloud services enable cloudbuild.googleapis.com || true
gcloud services enable run.googleapis.com || true
gcloud services enable secretmanager.googleapis.com || true

# Create secrets for OAuth credentials
echo -e "${GREEN}Creating/updating secrets...${NC}"

# Get project number for service account
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")

# JWT Secret
if [ -n "${JWT_SECRET}" ]; then
    echo -n "${JWT_SECRET}" | gcloud secrets create jwt-secret --data-file=- 2>/dev/null || \
    echo -n "${JWT_SECRET}" | gcloud secrets versions add jwt-secret --data-file=-
    gcloud secrets add-iam-policy-binding jwt-secret \
        --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" 2>/dev/null || true
fi

# Google OAuth
if [ -n "${GOOGLE_CLIENT_ID}" ]; then
    echo -n "${GOOGLE_CLIENT_ID}" | gcloud secrets create google-client-id --data-file=- 2>/dev/null || \
    echo -n "${GOOGLE_CLIENT_ID}" | gcloud secrets versions add google-client-id --data-file=-
    gcloud secrets add-iam-policy-binding google-client-id \
        --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" 2>/dev/null || true
fi
if [ -n "${GOOGLE_CLIENT_SECRET}" ]; then
    echo -n "${GOOGLE_CLIENT_SECRET}" | gcloud secrets create google-client-secret --data-file=- 2>/dev/null || \
    echo -n "${GOOGLE_CLIENT_SECRET}" | gcloud secrets versions add google-client-secret --data-file=-
    gcloud secrets add-iam-policy-binding google-client-secret \
        --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" 2>/dev/null || true
fi

# GitHub OAuth
if [ -n "${GITHUB_CLIENT_ID}" ]; then
    echo -n "${GITHUB_CLIENT_ID}" | gcloud secrets create github-client-id --data-file=- 2>/dev/null || \
    echo -n "${GITHUB_CLIENT_ID}" | gcloud secrets versions add github-client-id --data-file=-
    gcloud secrets add-iam-policy-binding github-client-id \
        --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" 2>/dev/null || true
fi
if [ -n "${GITHUB_CLIENT_SECRET}" ]; then
    echo -n "${GITHUB_CLIENT_SECRET}" | gcloud secrets create github-client-secret --data-file=- 2>/dev/null || \
    echo -n "${GITHUB_CLIENT_SECRET}" | gcloud secrets versions add github-client-secret --data-file=-
    gcloud secrets add-iam-policy-binding github-client-secret \
        --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com" \
        --role="roles/secretmanager.secretAccessor" 2>/dev/null || true
fi

# Build and push container
echo -e "${GREEN}Building and pushing container to Google Container Registry...${NC}"
gcloud builds submit --tag gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest

# Deploy to Cloud Run
echo -e "${GREEN}Deploying to Cloud Run...${NC}"
gcloud run deploy ${SERVICE_NAME} \
  --image gcr.io/${PROJECT_ID}/${IMAGE_NAME}:latest \
  --platform managed \
  --region ${REGION} \
  --allow-unauthenticated \
  --port 3001 \
  --set-env-vars="NODE_ENV=production,PORT=3001,FRONTEND_URL=${FRONTEND_URL},JWT_EXPIRY=${JWT_EXPIRY:-7d},ALLOWED_ORIGINS=${ALLOWED_ORIGINS}" \
  --update-secrets="JWT_SECRET=jwt-secret:latest,GOOGLE_CLIENT_ID=google-client-id:latest,GOOGLE_CLIENT_SECRET=google-client-secret:latest,GITHUB_CLIENT_ID=github-client-id:latest,GITHUB_CLIENT_SECRET=github-client-secret:latest" \
  --memory 512Mi \
  --cpu 1 \
  --timeout 60 \
  --max-instances 10 \
  --min-instances 0

# Get the service URL
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} --region=${REGION} --format='value(status.url)')

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Service URL: ${SERVICE_URL}${NC}"
echo ""
echo -e "${YELLOW}IMPORTANT: Next steps:${NC}"
echo ""
echo "1. Update BASE_URL in your .env.production file:"
echo "   BASE_URL=${SERVICE_URL}"
echo ""
echo "2. Update your OAuth provider callback URLs:"
echo "   - Google Console: ${SERVICE_URL}/api/auth/google/callback"
echo "   - GitHub Settings: ${SERVICE_URL}/api/auth/github/callback"
echo ""
echo "3. Update your frontend to use this auth service URL:"
echo "   const auth = new AuthClient('${SERVICE_URL}');"
echo ""
echo "4. Test the deployment:"
echo "   curl ${SERVICE_URL}/health"
echo ""

echo
