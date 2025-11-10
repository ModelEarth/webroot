# WebRoot Earth Auth Service

Stateless JWT authentication service with OAuth2 support for Google, GitHub, Microsoft, and Discord.

## Features

- **Stateless JWT Authentication** - No database required
- **OAuth2 Support** - Google, GitHub, Microsoft, Discord
- **Zero Storage** - Fully stateless, no session storage
- **CORS Enabled** - Works with any frontend
- **Easy Integration** - Simple REST API

## Architecture

```
┌─────────────┐      ┌──────────────┐      ┌─────────────────┐
│   Frontend  │ ───> │  Auth Service│ ───> │ OAuth Provider  │
│ (accountPanel)      │  (Node.js)   │      │ (Google, etc)   │
└─────────────┘      └──────────────┘      └─────────────────┘
       │                     │
       │   JWT Token         │
       └─────────────────────┘
```

## Installation

```bash
cd auth-system
npm install
```

## Configuration

1. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

2. Update `.env` with your settings:

```env
# JWT Configuration
JWT_SECRET=your-secret-key-for-jwt-signing-min-32-characters
JWT_EXPIRY=7d

# Server Configuration
PORT=3001
HOST=0.0.0.0
BASE_URL=http://localhost:3001

# Frontend URL (for OAuth redirects)
FRONTEND_URL=http://localhost:8887

# OAuth Providers
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret

GITHUB_CLIENT_ID=your-github-client-id
GITHUB_CLIENT_SECRET=your-github-client-secret

MICROSOFT_CLIENT_ID=your-microsoft-client-id
MICROSOFT_CLIENT_SECRET=your-microsoft-client-secret

DISCORD_CLIENT_ID=your-discord-client-id
DISCORD_CLIENT_SECRET=your-discord-client-secret

# CORS Configuration
ALLOWED_ORIGINS=http://localhost:8887,http://localhost:8888
```

### Getting OAuth Credentials

#### Google OAuth
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a project or select existing
3. Enable Google+ API
4. Create OAuth 2.0 credentials
5. Add authorized redirect URI: `http://localhost:3001/api/auth/google/callback`

#### GitHub OAuth
1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Create new OAuth App
3. Set callback URL: `http://localhost:3001/api/auth/github/callback`

#### Microsoft OAuth
1. Go to [Azure Portal](https://portal.azure.com/)
2. Register an application
3. Add redirect URI: `http://localhost:3001/api/auth/microsoft/callback`

#### Discord OAuth
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Create new application
3. Add redirect URI: `http://localhost:3001/api/auth/discord/callback`

## Running the Service

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

### Health Check
```
GET /health
```

Response:
```json
{
  "status": "ok",
  "service": "webroot-earth-auth",
  "type": "stateless-jwt",
  "timestamp": "2025-10-29T06:00:00.000Z"
}
```

### Get Available Providers
```
GET /api/auth/providers
```

Response:
```json
{
  "providers": [
    { "id": "google", "name": "Google" },
    { "id": "github", "name": "GitHub" }
  ]
}
```

### Initiate OAuth Flow
```
GET /api/auth/:provider/url
```

Example: `GET /api/auth/google/url`

Response:
```json
{
  "url": "https://accounts.google.com/o/oauth2/v2/auth?...",
  "state": "abc123xyz"
}
```

### OAuth Callback (Automatic)
```
GET /api/auth/:provider/callback?code=xxx&state=yyy
```

This endpoint is called automatically by the OAuth provider. It redirects to:
- Success: `FRONTEND_URL/auth/callback?token=JWT_TOKEN`
- Error: `FRONTEND_URL/auth/callback?error=ERROR_MESSAGE`

### Verify Token
```
POST /api/auth/verify
Authorization: Bearer <token>

OR

POST /api/auth/verify
Content-Type: application/json

{
  "token": "your-jwt-token"
}
```

Response:
```json
{
  "valid": true,
  "user": {
    "id": "123456",
    "email": "user@example.com",
    "name": "John Doe",
    "image": "https://...",
    "provider": "google"
  }
}
```

### Get Current User
```
GET /api/auth/me
Authorization: Bearer <token>
```

Response:
```json
{
  "user": {
    "id": "123456",
    "email": "user@example.com",
    "name": "John Doe",
    "image": "https://...",
    "provider": "google"
  }
}
```

## Frontend Integration

Include the auth client in your HTML:

```html
<script src="http://localhost:3001/auth-client.js"></script>
```

Or copy `public/auth-client.js` to your frontend project.

### JavaScript Usage

```javascript
// Initialize client
const auth = new AuthClient('http://localhost:3001');

// Sign in with provider
auth.signIn('google');

// Handle callback (on your callback page)
const result = auth.handleCallback();
if (result.success) {
  console.log('User:', result.user);
}

// Check if authenticated
if (auth.isAuthenticated()) {
  const user = auth.getUser();
  console.log('Logged in as:', user.name);
}

// Get current user from server
const user = await auth.getCurrentUser();

// Sign out
auth.signOut();

// Make authenticated API request
const response = await auth.authenticatedFetch('https://api.example.com/data');
```

## Integration with Rust Backend

The Rust backend can verify JWT tokens:

```rust
use jsonwebtoken::{decode, DecodingKey, Validation, Algorithm};

#[derive(Debug, Serialize, Deserialize)]
struct Claims {
    id: String,
    email: String,
    name: String,
    provider: String,
    exp: usize,
}

fn verify_token(token: &str) -> Result<Claims, Error> {
    let secret = env::var("JWT_SECRET")?;
    let key = DecodingKey::from_secret(secret.as_bytes());

    let mut validation = Validation::new(Algorithm::HS256);
    validation.set_issuer(&["webroot-earth-auth"]);

    let token_data = decode::<Claims>(token, &key, &validation)?;
    Ok(token_data.claims)
}
```

Or call the verify endpoint:

```rust
// Make HTTP request to auth service
let response = client
    .post("http://localhost:3001/api/auth/verify")
    .json(&json!({ "token": token }))
    .send()
    .await?;
```

## JWT Token Structure

Tokens are signed with HS256 and contain:

```json
{
  "id": "user-id-from-provider",
  "email": "user@example.com",
  "name": "John Doe",
  "image": "https://...",
  "provider": "google",
  "iat": 1234567890,
  "exp": 1234567890,
  "iss": "webroot-earth-auth"
}
```

## Security Notes

1. **JWT Secret**: Use a strong, random secret (min 32 characters)
2. **HTTPS**: Always use HTTPS in production
3. **Token Expiry**: Default is 7 days, adjust as needed
4. **CORS**: Configure allowed origins properly
5. **State Parameter**: Automatically handled for CSRF protection

## No Database Required

This service is completely stateless:
- No database connections
- No session storage
- No user storage
- Only temporary state storage for OAuth flow (in-memory, expires in 10 minutes)

User information is encoded in the JWT token itself.

## Troubleshooting

### OAuth redirect not working
- Check `BASE_URL` in `.env` matches your server URL
- Verify callback URL in OAuth provider settings
- Ensure `FRONTEND_URL` is correct

### Token verification fails
- Check `JWT_SECRET` is the same everywhere
- Verify token hasn't expired
- Check issuer is "webroot-earth-auth"

### CORS errors
- Add your frontend URL to `ALLOWED_ORIGINS`
- Ensure protocol (http/https) matches

## License

ISC
