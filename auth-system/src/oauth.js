import axios from "axios";
import { providers, getClientId, getClientSecret, getRedirectUri } from "./oauth-providers.js";

/**
 * Generate authorization URL for OAuth provider
 */
export function getAuthorizationUrl(providerName, state) {
  const provider = providers[providerName];
  if (!provider || !provider.enabled()) {
    throw new Error(`Provider ${providerName} not found or not enabled`);
  }

  const params = new URLSearchParams({
    client_id: getClientId(providerName),
    redirect_uri: getRedirectUri(providerName),
    scope: provider.scope,
    response_type: "code",
    state: state,
  });

  return `${provider.authorizationUrl}?${params.toString()}`;
}

/**
 * Exchange authorization code for access token
 */
export async function exchangeCodeForToken(providerName, code) {
  const provider = providers[providerName];
  if (!provider) {
    throw new Error(`Provider ${providerName} not found`);
  }

  const params = new URLSearchParams({
    client_id: getClientId(providerName),
    client_secret: getClientSecret(providerName),
    code: code,
    redirect_uri: getRedirectUri(providerName),
    grant_type: "authorization_code",
  });

  try {
    const response = await axios.post(provider.tokenUrl, params, {
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Accept: "application/json",
      },
    });

    return response.data.access_token;
  } catch (error) {
    console.error("Token exchange error:", error.response?.data || error.message);
    throw new Error("Failed to exchange code for token");
  }
}

/**
 * Fetch user info from OAuth provider
 */
export async function fetchUserInfo(providerName, accessToken) {
  const provider = providers[providerName];
  if (!provider) {
    throw new Error(`Provider ${providerName} not found`);
  }

  try {
    const response = await axios.get(provider.userInfoUrl, {
      headers: {
        Authorization: `Bearer ${accessToken}`,
        Accept: "application/json",
      },
    });

    // Normalize user data across providers
    return normalizeUserData(providerName, response.data);
  } catch (error) {
    console.error("Fetch user info error:", error.response?.data || error.message);
    throw new Error("Failed to fetch user info");
  }
}

/**
 * Normalize user data from different providers
 */
function normalizeUserData(providerName, rawData) {
  const user = {
    provider: providerName,
    id: null,
    email: null,
    name: null,
    image: null,
  };

  switch (providerName) {
    case "google":
      user.id = rawData.id;
      user.email = rawData.email;
      user.name = rawData.name;
      user.image = rawData.picture;
      break;

    case "github":
      user.id = rawData.id.toString();
      user.email = rawData.email;
      user.name = rawData.name || rawData.login;
      user.image = rawData.avatar_url;
      break;

    case "microsoft":
      user.id = rawData.id;
      user.email = rawData.mail || rawData.userPrincipalName;
      user.name = rawData.displayName;
      user.image = null; // Microsoft Graph doesn't return photo in basic profile
      break;

    case "discord":
      user.id = rawData.id;
      user.email = rawData.email;
      user.name = rawData.username;
      user.image = rawData.avatar
        ? `https://cdn.discordapp.com/avatars/${rawData.id}/${rawData.avatar}.png`
        : null;
      break;
  }

  return user;
}

/**
 * Generate a random state parameter for OAuth flow
 */
export function generateState() {
  return Math.random().toString(36).substring(2, 15) +
         Math.random().toString(36).substring(2, 15);
}
