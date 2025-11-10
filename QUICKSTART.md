# Quick Start Guide - Production Deployment

Follow these steps to deploy your services to production in ~30 minutes.

## 🚀 Quick Steps

### 1. Install Google Cloud SDK (5 min)

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud auth login
```

### 2. Create Project & Enable Billing (5 min)

```bash
# Create project
gcloud projects create webroot-earth --name="Webroot Earth"
gcloud config set project webroot-earth

# Enable billing at: https://console.cloud.google.com/billing
# Link your project to a billing account (Cloud Run has free tier)
```

### 3. Deploy Auth Service (10 min)

```bash
cd auth-system

# Create production environment
cp .env.production.example .env.production

# Generate JWT secret
openssl rand -base64 32
# Copy the output and paste it into .env.production as JWT_SECRET

# Edit .env.production
nano .env.production
# Update: FRONTEND_URL=https://harimayooram.github.io/webroot-earth

# Deploy
chmod +x deploy-cloudrun.sh
./deploy-cloudrun.sh
```

**Save the URL that appears!** Example: `https://webroot-auth-abc123-uc.a.run.app`

### 4. Set Up OAuth (10 min)

#### Google OAuth
1. Go to: https://console.cloud.google.com/apis/credentials
2. Create OAuth Client → Web Application
3. Redirect URI: `https://webroot-auth-abc123-uc.a.run.app/api/auth/google/callback`
4. Copy Client ID & Secret to `.env.production`

#### GitHub OAuth
1. Go to: https://github.com/settings/developers
2. New OAuth App
3. Callback: `https://webroot-auth-abc123-uc.a.run.app/api/auth/github/callback`
4. Copy Client ID & Secret to `.env.production`

### 5. Redeploy with OAuth Credentials

```bash
# Update .env.production with:
# - BASE_URL (your Cloud Run URL from step 3)
# - GOOGLE_CLIENT_ID
# - GOOGLE_CLIENT_SECRET
# - GITHUB_CLIENT_ID
# - GITHUB_CLIENT_SECRET

nano .env.production

# Redeploy
./deploy-cloudrun.sh
```

### 6. Deploy Rust API (15 min - includes build time)

```bash
cd ../team

# Deploy
chmod +x deploy-cloudrun.sh
./deploy-cloudrun.sh
```

**Save the URL!** Example: `https://webroot-rust-api-xyz789-uc.a.run.app`

### 7. Update Your Frontend

Update your HTML/JS to use production URLs:

```javascript
// Auth Service
const auth = new AuthClient('https://webroot-auth-abc123-uc.a.run.app');

// Rust API
const API_URL = 'https://webroot-rust-api-xyz789-uc.a.run.app';
```

### 8. Test Everything

```bash
# Test auth service
curl https://webroot-auth-abc123-uc.a.run.app/health

# Test Rust API
curl https://webroot-rust-api-xyz789-uc.a.run.app/api/health
```

## ✅ Done!

Your services are now live in production with:
- ✅ HTTPS enabled automatically
- ✅ Auto-scaling
- ✅ Free tier (2M requests/month)
- ✅ OAuth authentication
- ✅ Secure secrets management

## 📊 View Your Services

Visit: https://console.cloud.google.com/run?project=webroot-earth

## 📝 Next Steps

- [ ] Push your frontend to GitHub Pages
- [ ] Set up custom domain (optional)
- [ ] Set up GitHub Actions for auto-deploy (optional)

## 🆘 Need Help?

See detailed guide: [PRODUCTION-DEPLOYMENT.md](./PRODUCTION-DEPLOYMENT.md)

## 💰 Costs

With Cloud Run free tier:
- **Estimated cost: $0-10/month** for typical usage
- First 2 million requests are free
- Services auto-sleep when not in use (no charges)

## 🔒 Security Notes

- Never commit `.env.production` to git (already in .gitignore)
- JWT secrets are stored in Google Secret Manager
- All connections use HTTPS
- CORS is properly configured
