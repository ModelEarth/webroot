import dotenv from "dotenv";
import { getAuthorizationUrl, generateState } from "./oauth.js";
import { providers, getClientId, getRedirectUri } from "./oauth-providers.js";

dotenv.config();

/**
 * Debug script to test OAuth configuration
 * Run with: node src/debug.js
 */

console.log("=".repeat(60));
console.log("OAuth Configuration Debug");
console.log("=".repeat(60));

console.log("\n📋 Environment Variables:");
console.log("BASE_URL:", process.env.BASE_URL || "❌ NOT SET");
console.log("FRONTEND_URL:", process.env.FRONTEND_URL || "❌ NOT SET");
console.log("JWT_SECRET:", process.env.JWT_SECRET ? "✅ SET" : "❌ NOT SET");

console.log("\n🔐 OAuth Providers:");

for (const [key, provider] of Object.entries(providers)) {
  console.log(`\n${provider.name}:`);

  const clientId = getClientId(key);
  const enabled = provider.enabled();

  console.log(`  Enabled: ${enabled ? "✅ YES" : "❌ NO"}`);
  console.log(`  Client ID: ${clientId ? "✅ SET" : "❌ NOT SET"}`);

  if (enabled && clientId) {
    console.log(`  Redirect URI: ${getRedirectUri(key)}`);

    try {
      const state = generateState();
      const url = getAuthorizationUrl(key, state);
      console.log(`  Auth URL: ${url.substring(0, 100)}...`);

      // Parse URL to check parameters
      const urlObj = new URL(url);
      console.log(`  Parameters:`);
      console.log(`    - client_id: ${urlObj.searchParams.get('client_id')}`);
      console.log(`    - redirect_uri: ${urlObj.searchParams.get('redirect_uri')}`);
      console.log(`    - scope: ${urlObj.searchParams.get('scope')}`);
      console.log(`    - response_type: ${urlObj.searchParams.get('response_type')}`);
      console.log(`    - state: ${urlObj.searchParams.get('state')}`);
    } catch (error) {
      console.log(`  ❌ Error generating URL: ${error.message}`);
    }
  }
}

console.log("\n" + "=".repeat(60));
console.log("✅ Configuration Check Complete");
console.log("=".repeat(60));

console.log("\n💡 Next Steps:");
console.log("1. Verify redirect URIs match in OAuth provider settings");
console.log("2. Check that Client IDs and Secrets are correct");
console.log("3. Ensure BASE_URL is accessible from the internet (if testing OAuth)");
console.log("4. Start the service with: npm run dev");
