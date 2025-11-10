# Production Deployment Guide - Google Cloud Run

This guide will help you deploy all backend services to Google Cloud Run for production use.

## Overview

Your application consists of:
- **Frontend**: GitHub Pages (`https://harimayooram.github.io/webroot-earth/`)
- **Auth Service** (Node.js): Google Cloud Run
- **Rust API**: Google Cloud Run
- **Python Service**: Already deployed to Google Cloud Run ✅

## Prerequisites

### 1. Install Google Cloud SDK

```bash
# Check if installed
gcloud --version

# If not installed:
# macOS/Linux
curl https://sdk.cloud.google.com | bash
exec -l $SHELL

# Windows
# Download from: https://cloud.google.com/sdk/docs/install
```

### 2. Set Up Google Cloud Project

```bash
# Login to Google Cloud
gcloud auth login

# Create a new project (choose a unique project ID)
gcloud projects create webroot-earth --name="Webroot Earth"

# Set as active project
gcloud config set project webroot-earth

# Enable billing (REQUIRED for Cloud Run)
# Go to: https://console.cloud.google.com/billing
# Click "Link a billing account" and follow the prompts
# Note: Cloud Run has a generous free tier (2 million requests/month)
```

### 3. Set Default Region

```bash
# Set your preferred region
gcloud config set run/region us-central1

# Other regions: europe-west1, asia-east1, etc.
# See: https://cloud.google.com/run/docs/locations
```

---

## Deploy Auth Service (Node.js)

### Step 1: Prepare Environment Variables

```bash
cd auth-system

# Copy the production template
cp .env.production.example .env.production

# Generate a secure JWT secret
openssl rand -base64 32

# Edit .env.production and update:
nano .env.production
```

Update these values in `.env.production`:

```env
# Paste the JWT secret you just generated
JWT_SECRET=<paste-your-generated-secret-here>

# Frontend URL (GitHub Pages)
FRONTEND_URL=https://harimayooram.github.io/webroot-earth

# CORS origins
ALLOWED_ORIGINS=https://harimayooram.github.io,https://model.earth

# Leave BASE_URL as is - it will be updated after deployment
```

### Step 2: Set Up OAuth Providers

#### Google OAuth

1. Go to https://console.cloud.google.com/apis/credentials
2. Select your project: `webroot-earth`
3. Click "Create Credentials" → "OAuth client ID"
4. Application type: "Web application"
5. Name: "Webroot Auth Service"
6. Authorized redirect URIs: `https://webroot-auth-xxxxxx-uc.a.run.app/api/auth/google/callback`
   - Note: You'll update this with the actual URL after first deployment
7. Copy the Client ID and Client Secret
8. Add to `.env.production`:
   ```env
   GOOGLE_CLIENT_ID=your-client-id.apps.googleusercontent.com
   GOOGLE_CLIENT_SECRET=your-client-secret
   ```

#### GitHub OAuth

1. Go to https://github.com/settings/developers
2. Click "New OAuth App"
3. Application name: "Webroot Auth"
4. Homepage URL: `https://harimayooram.github.io/webroot-earth`
5. Authorization callback URL: `https://webroot-auth-xxxxxx-uc.a.run.app/api/auth/github/callback`
   - Note: You'll update this after first deployment
6. Click "Register application"
7. Generate a new client secret
8. Add to `.env.production`:
   ```env
   GITHUB_CLIENT_ID=your-github-client-id
   GITHUB_CLIENT_SECRET=your-github-client-secret
   ```

### Step 3: Deploy to Cloud Run

```bash
# Make sure you're in the auth-system directory
cd auth-system

# Run deployment script
./deploy-cloudrun.sh

# If you get permission denied:
chmod +x deploy-cloudrun.sh
./deploy-cloudrun.sh
```

This will:
1. Enable required Google Cloud APIs
2. Create secrets in Secret Manager
3. Build Docker image
4. Deploy to Cloud Run
5. Output your service URL

### Step 4: Update OAuth Callback URLs

After deployment, you'll get a URL like: `https://webroot-auth-abc123-uc.a.run.app`

Update your OAuth providers:

**Google:**
1. Go back to https://console.cloud.google.com/apis/credentials
2. Edit your OAuth client
3. Update redirect URI to: `https://webroot-auth-abc123-uc.a.run.app/api/auth/google/callback`

**GitHub:**
1. Go back to https://github.com/settings/developers
2. Click on your OAuth app
3. Update callback URL to: `https://webroot-auth-abc123-uc.a.run.app/api/auth/github/callback`

### Step 5: Update BASE_URL and Redeploy

```bash
# Edit .env.production
nano .env.production

# Update BASE_URL with your actual Cloud Run URL
BASE_URL=https://webroot-auth-abc123-uc.a.run.app

# Redeploy
./deploy-cloudrun.sh
```

### Step 6: Test Auth Service

```bash
# Get your service URL
AUTH_URL=$(gcloud run services describe webroot-auth --region=us-central1 --format='value(status.url)')

# Test health endpoint
curl $AUTH_URL/health

# Should return: {"status":"ok","timestamp":"..."}
```

---

## Deploy Rust API

### Step 1: Prepare Environment

```bash
cd team

# Make sure .env exists
if [ ! -f .env ]; then
    cp .env.example .env
fi
```

### Step 2: Deploy to Cloud Run

```bash
# Run deployment script
./deploy-cloudrun.sh

# If you get permission denied:
chmod +x deploy-cloudrun.sh
./deploy-cloudrun.sh
```

**Note:** Rust compilation takes 10-15 minutes on first deployment. Subsequent deployments will be faster with caching.

### Step 3: Test Rust API

```bash
# Get your service URL
RUST_URL=$(gcloud run services describe webroot-rust-api --region=us-central1 --format='value(status.url)')

# Test health endpoint
curl $RUST_URL/api/health
```

---

## Update Frontend to Use Production URLs

After both services are deployed, update your frontend code:

### For Auth Service

```javascript
// In your frontend JavaScript
const auth = new AuthClient('https://webroot-auth-abc123-uc.a.run.app');
```

### For Rust API

```javascript
// In your frontend JavaScript
const API_URL = 'https://webroot-rust-api-xyz789-uc.a.run.app';
```

---

## Environment Variables Reference

### Auth Service (.env.production)

```env
# Required
JWT_SECRET=<your-secure-random-secret>
FRONTEND_URL=https://harimayooram.github.io/webroot-earth
BASE_URL=<your-cloud-run-url>

# OAuth (at least one required)
GOOGLE_CLIENT_ID=<your-google-client-id>
GOOGLE_CLIENT_SECRET=<your-google-client-secret>
GITHUB_CLIENT_ID=<your-github-client-id>
GITHUB_CLIENT_SECRET=<your-github-client-secret>

# Optional
ALLOWED_ORIGINS=https://harimayooram.github.io,https://model.earth
JWT_EXPIRY=7d
```

---

## Cost Estimate

Google Cloud Run Free Tier (per month):
- 2 million requests
- 360,000 GB-seconds of memory
- 180,000 vCPU-seconds of compute

**Your expected usage:**
- Auth Service: ~$0-5/month (within free tier for most use cases)
- Rust API: ~$0-5/month (within free tier for most use cases)
- **Total: ~$0-10/month**

---

## Monitoring and Logs

### View Logs

```bash
# Auth service logs
gcloud run services logs read webroot-auth --limit 50

# Rust API logs
gcloud run services logs read webroot-rust-api --limit 50
```

### Cloud Console

View logs, metrics, and manage services:
https://console.cloud.google.com/run

---

## Troubleshooting

### Build Fails

```bash
# Check Docker is working
docker --version

# Try building locally first
cd auth-system
docker build -t test-auth .

cd ../team
docker build -t test-rust .
```

### Secrets Not Working

```bash
# List secrets
gcloud secrets list

# Check secret access
gcloud secrets versions access latest --secret=jwt-secret
```

### Service Not Responding

```bash
# Check service status
gcloud run services describe webroot-auth --region=us-central1

# View recent logs
gcloud run services logs read webroot-auth --limit 100
```

### Permission Denied

```bash
# Make sure you're authenticated
gcloud auth login

# Make sure project is set
gcloud config set project webroot-earth

# Enable required APIs
gcloud services enable cloudbuild.googleapis.com
gcloud services enable run.googleapis.com
```

---

## Update/Redeploy Services

### Auth Service

```bash
cd auth-system
./deploy-cloudrun.sh
```

### Rust API

```bash
cd team
./deploy-cloudrun.sh
```

---

## Next Steps

1. ✅ Deploy Auth Service
2. ✅ Deploy Rust API
3. ✅ Update OAuth callback URLs
4. ✅ Update frontend to use production URLs
5. 🔄 Set up custom domain (optional)
6. 🔄 Set up CI/CD with GitHub Actions (optional)

---

## Support

- Google Cloud Run Docs: https://cloud.google.com/run/docs
- Pricing: https://cloud.google.com/run/pricing
- Free Tier: https://cloud.google.com/free

---

## Security Checklist

- [x] JWT_SECRET is randomly generated (not the example)
- [x] OAuth credentials are stored in Secret Manager
- [x] CORS origins are properly configured
- [x] Services use HTTPS (automatic with Cloud Run)
- [x] Secrets are not committed to git (.env.production in .gitignore)
