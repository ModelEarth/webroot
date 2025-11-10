/**
 * OAuth 2.0 Provider Configurations
 * Each provider has authorization and token endpoints, plus user info endpoint
 */

export const providers = {
  google: {
    name: "Google",
    authorizationUrl: "https://accounts.google.com/o/oauth2/v2/auth",
    tokenUrl: "https://oauth2.googleapis.com/token",
    userInfoUrl: "https://www.googleapis.com/oauth2/v2/userinfo",
    scope: "openid email profile",
    enabled: () => !!(process.env.GOOGLE_CLIENT_ID && process.env.GOOGLE_CLIENT_SECRET),
  },

  github: {
    name: "GitHub",
    authorizationUrl: "https://github.com/login/oauth/authorize",
    tokenUrl: "https://github.com/login/oauth/access_token",
    userInfoUrl: "https://api.github.com/user",
    scope: "read:user user:email",
    enabled: () => !!(process.env.GITHUB_CLIENT_ID && process.env.GITHUB_CLIENT_SECRET),
  },

  microsoft: {
    name: "Microsoft",
    authorizationUrl: "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
    tokenUrl: "https://login.microsoftonline.com/common/oauth2/v2.0/token",
    userInfoUrl: "https://graph.microsoft.com/v1.0/me",
    scope: "openid email profile",
    enabled: () => !!(process.env.MICROSOFT_CLIENT_ID && process.env.MICROSOFT_CLIENT_SECRET),
  },

  discord: {
    name: "Discord",
    authorizationUrl: "https://discord.com/api/oauth2/authorize",
    tokenUrl: "https://discord.com/api/oauth2/token",
    userInfoUrl: "https://discord.com/api/users/@me",
    scope: "identify email",
    enabled: () => !!(process.env.DISCORD_CLIENT_ID && process.env.DISCORD_CLIENT_SECRET),
  },
};

/**
 * Get client ID for a provider
 */
export function getClientId(provider) {
  const envKey = `${provider.toUpperCase()}_CLIENT_ID`;
  return process.env[envKey];
}

/**
 * Get client secret for a provider
 */
export function getClientSecret(provider) {
  const envKey = `${provider.toUpperCase()}_CLIENT_SECRET`;
  return process.env[envKey];
}

/**
 * Get redirect URI for a provider
 */
export function getRedirectUri(provider) {
  const baseUrl = process.env.BASE_URL || "http://localhost:3001";
  return `${baseUrl}/api/auth/${provider}/callback`;
}

/**
 * Get all enabled providers
 */
export function getEnabledProviders() {
  return Object.keys(providers).filter(key => providers[key].enabled());
}
