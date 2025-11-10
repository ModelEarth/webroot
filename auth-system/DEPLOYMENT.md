# Production Deployment Guide

## Prerequisites

- Node.js 18+ or Docker
- Domain with SSL certificate (HTTPS required)
- OAuth credentials from providers (Google, GitHub, etc.)
- Environment for secrets management

## Quick Start

### 1. Environment Configuration

Copy the production template:
```bash
cp .env.production.example .env
```

Edit `.env` and set:
- `JWT_SECRET` - Generate with: `openssl rand -base64 32`
- `BASE_URL` - Your auth service URL (e.g., `https://auth.yourdomain.com`)
- `FRONTEND_URL` - Your frontend URL (e.g., `https://yourdomain.com`)
- OAuth credentials for each provider

### 2. OAuth Provider Setup (Production)

#### Google OAuth
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project → APIs & Services → Credentials
3. Update your OAuth 2.0 Client ID:
   - **Authorized redirect URIs**: `https://auth.yourdomain.com/api/auth/google/callback`
   - **Authorized JavaScript origins**: `https://auth.yourdomain.com`
4. Go to OAuth consent screen → Publish App (removes "unverified" warning)
5. Copy Client ID and Secret to `.env`

#### GitHub OAuth
1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Select your OAuth App
3. Update:
   - **Homepage URL**: `https://yourdomain.com`
   - **Authorization callback URL**: `https://auth.yourdomain.com/api/auth/github/callback`
4. Copy Client ID and Secret to `.env`

## Deployment Options

### Option 1: Docker (Recommended)

**Build and run:**
```bash
cd auth-system

# Build image
docker build -t auth-system:latest .

# Run container
docker run -d \
  --name auth-system \
  -p 3001:3001 \
  --env-file .env \
  --restart unless-stopped \
  auth-system:latest

# Check logs
docker logs -f auth-system

# Verify health
curl https://auth.yourdomain.com/health
```

**Using Docker Compose:**
```yaml
# docker-compose.yml
version: '3.8'

services:
  auth-system:
    build: ./auth-system
    ports:
      - "3001:3001"
    env_file:
      - ./auth-system/.env
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3001/health"]
      interval: 30s
      timeout: 3s
      retries: 3
```

### Option 2: Node.js Direct

```bash
cd auth-system

# Install production dependencies
npm ci --only=production

# Start service
NODE_ENV=production npm start
```

### Option 3: PM2 Process Manager

```bash
# Install PM2 globally
npm install -g pm2

# Start service
cd auth-system
pm2 start src/index.js --name auth-system --env production

# Save process list
pm2 save

# Setup startup script (auto-restart on reboot)
pm2 startup

# Monitor
pm2 logs auth-system
pm2 monit
```

### Option 4: systemd Service (Linux)

Create `/etc/systemd/system/auth-system.service`:
```ini
[Unit]
Description=WebRoot Earth Auth Service
After=network.target

[Service]
Type=simple
User=www-data
WorkingDirectory=/var/www/auth-system
EnvironmentFile=/var/www/auth-system/.env
ExecStart=/usr/bin/node src/index.js
Restart=on-failure
RestartSec=10

[Install]
WantedBy=multi-user.target
```

Enable and start:
```bash
sudo systemctl daemon-reload
sudo systemctl enable auth-system
sudo systemctl start auth-system
sudo systemctl status auth-system
```

## Reverse Proxy Configuration

### Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name auth.yourdomain.com;

    ssl_certificate /path/to/ssl/cert.pem;
    ssl_certificate_key /path/to/ssl/key.pem;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

### Caddy

```caddy
auth.yourdomain.com {
    reverse_proxy localhost:3001
}
```

## Environment Variables Reference

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `JWT_SECRET` | Yes | Secret for JWT signing (min 32 chars) | `openssl rand -base64 32` |
| `JWT_EXPIRY` | No | Token expiration time | `7d` (default) |
| `PORT` | No | Server port | `3001` (default) |
| `HOST` | No | Server host | `0.0.0.0` (default) |
| `NODE_ENV` | Yes | Environment mode | `production` |
| `BASE_URL` | Yes | Auth service URL | `https://auth.yourdomain.com` |
| `FRONTEND_URL` | Yes | Frontend URL for redirects | `https://yourdomain.com` |
| `GOOGLE_CLIENT_ID` | Optional | Google OAuth client ID | From Google Cloud Console |
| `GOOGLE_CLIENT_SECRET` | Optional | Google OAuth secret | From Google Cloud Console |
| `GITHUB_CLIENT_ID` | Optional | GitHub OAuth client ID | From GitHub Developer Settings |
| `GITHUB_CLIENT_SECRET` | Optional | GitHub OAuth secret | From GitHub Developer Settings |
| `ALLOWED_ORIGINS` | No | CORS allowed origins (comma-separated) | `https://yourdomain.com` |

## Security Checklist

- [ ] **HTTPS Only**: Never use HTTP in production
- [ ] **Strong JWT Secret**: Minimum 32 random characters
- [ ] **Environment Variables**: Use secrets manager, not `.env` files
- [ ] **NODE_ENV=production**: Set to production mode
- [ ] **CORS Configuration**: Restrict `ALLOWED_ORIGINS` to your domains
- [ ] **OAuth Credentials**: Use separate credentials for production
- [ ] **Rate Limiting**: Consider adding rate limiting middleware
- [ ] **Monitoring**: Set up logging and alerting
- [ ] **Firewall**: Restrict access to necessary ports only
- [ ] **Regular Updates**: Keep dependencies up to date

## Testing Production Deployment

```bash
# Health check
curl https://auth.yourdomain.com/health

# Expected response:
# {
#   "status": "ok",
#   "service": "webroot-earth-auth",
#   "type": "stateless-jwt",
#   "timestamp": "2025-11-05T...",
#   "environment": "production",
#   "providers": ["Google", "GitHub"]
# }

# Get available providers
curl https://auth.yourdomain.com/api/auth/providers

# Test OAuth URL generation
curl https://auth.yourdomain.com/api/auth/google/url
```

## Monitoring and Maintenance

### Logs

**Docker:**
```bash
docker logs -f auth-system
```

**PM2:**
```bash
pm2 logs auth-system
```

**systemd:**
```bash
journalctl -u auth-system -f
```

### Health Monitoring

Set up automated health checks:
```bash
*/5 * * * * curl -f https://auth.yourdomain.com/health || echo "Auth service down"
```

### Updates

```bash
# Pull latest code
git pull origin main

# Rebuild and restart (Docker)
docker build -t auth-system:latest .
docker stop auth-system
docker rm auth-system
docker run -d --name auth-system -p 3001:3001 --env-file .env auth-system:latest

# Or restart (PM2)
pm2 restart auth-system
```

## Troubleshooting

### Service won't start
```bash
# Check port availability
lsof -i :3001

# Validate configuration
npm run debug

# Check environment variables
printenv | grep -E "JWT_|GOOGLE_|GITHUB_|BASE_URL"
```

### OAuth errors
1. Verify redirect URIs match exactly in OAuth provider settings
2. Check `BASE_URL` and `FRONTEND_URL` are correct
3. Ensure using production credentials (not development)
4. Clear browser cache and try in incognito mode

### CORS errors
1. Add frontend URL to `ALLOWED_ORIGINS`
2. Verify protocol matches (https vs http)
3. Check for trailing slashes

### Token verification fails
1. Ensure same `JWT_SECRET` everywhere
2. Check token hasn't expired
3. Verify issuer is "webroot-earth-auth"

## Scaling Considerations

For high-traffic scenarios:

1. **Load Balancing**: Run multiple instances behind a load balancer
2. **State Storage**: Replace in-memory state store with Redis
3. **CDN**: Serve `auth-client.js` via CDN
4. **Caching**: Add response caching for `/health` and `/api/auth/providers`
5. **Rate Limiting**: Implement per-IP rate limits

## Backup and Recovery

**Important files to backup:**
- `.env` (store in secrets manager)
- OAuth application credentials
- SSL certificates

**Recovery process:**
1. Deploy fresh instance
2. Restore environment configuration
3. Verify OAuth provider settings
4. Test authentication flow

## Support

For issues or questions:
- Check logs first
- Run `npm run debug` to validate configuration
- Review [README.md](README.md) for API documentation
- Check GitHub Issues
