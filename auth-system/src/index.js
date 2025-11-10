import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { generateToken, verifyToken } from "./jwt.js";
import { getAuthorizationUrl, exchangeCodeForToken, fetchUserInfo, generateState } from "./oauth.js";
import { providers, getEnabledProviders } from "./oauth-providers.js";

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;
const HOST = process.env.HOST || "0.0.0.0";
const FRONTEND_URL = process.env.FRONTEND_URL || "http://localhost:8887";

// Store states temporarily (in production, use Redis or similar)
const stateStore = new Map();

// Parse allowed origins from environment
const allowedOrigins = process.env.ALLOWED_ORIGINS
  ? process.env.ALLOWED_ORIGINS.split(",")
  : ["http://localhost:8887", "http://localhost:8888"];

// CORS configuration
app.use(
  cors({
    origin: (origin, callback) => {
      // Allow requests with no origin (like mobile apps or curl)
      if (!origin) return callback(null, true);

      if (allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(new Error("Not allowed by CORS"));
      }
    },
    credentials: true,
  })
);

// Parse JSON bodies
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Serve static files (auth-client.js)
app.use(express.static("public"));

// Health check endpoint
app.get("/health", (req, res) => {
  const enabledProviders = getEnabledProviders();
  res.json({
    status: "ok",
    service: "webroot-earth-auth",
    type: "stateless-jwt",
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || "development",
    providers: enabledProviders.map(p => providers[p].name),
  });
});

// Get list of enabled providers
app.get("/api/auth/providers", (req, res) => {
  const enabledProviders = getEnabledProviders();
  res.json({
    providers: enabledProviders.map(key => ({
      id: key,
      name: providers[key].name,
    })),
  });
});

// Initiate OAuth flow - Get authorization URL
app.get("/api/auth/:provider/url", (req, res) => {
  const { provider } = req.params;

  try {
    // Generate and store state
    const state = generateState();
    stateStore.set(state, {
      provider,
      createdAt: Date.now(),
    });

    // Clean up old states (older than 10 minutes)
    for (const [key, value] of stateStore.entries()) {
      if (Date.now() - value.createdAt > 10 * 60 * 1000) {
        stateStore.delete(key);
      }
    }

    const authUrl = getAuthorizationUrl(provider, state);

    res.json({
      url: authUrl,
      state: state,
    });
  } catch (error) {
    console.error("Authorization URL error:", error);
    res.status(400).json({ error: error.message });
  }
});

// OAuth callback endpoint
app.get("/api/auth/:provider/callback", async (req, res) => {
  const { provider } = req.params;
  const { code, state } = req.query;

  try {
    // Verify state
    const storedState = stateStore.get(state);
    if (!storedState || storedState.provider !== provider) {
      throw new Error("Invalid state parameter");
    }
    stateStore.delete(state);

    // Exchange code for access token
    const accessToken = await exchangeCodeForToken(provider, code);

    // Fetch user info
    const userInfo = await fetchUserInfo(provider, accessToken);

    // Generate JWT
    const token = generateToken(userInfo);

    // Redirect to frontend with token
    const redirectUrl = `${FRONTEND_URL}/auth/callback.html?token=${token}`;
    res.redirect(redirectUrl);

  } catch (error) {
    console.error("OAuth callback error:", error);
    const errorUrl = `${FRONTEND_URL}/auth/callback.html?error=${encodeURIComponent(error.message)}`;
    res.redirect(errorUrl);
  }
});

// Verify JWT token endpoint
app.post("/api/auth/verify", (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith("Bearer ")
      ? authHeader.substring(7)
      : req.body.token;

    if (!token) {
      return res.status(400).json({ error: "Token is required" });
    }

    const decoded = verifyToken(token);

    if (!decoded) {
      return res.status(401).json({
        valid: false,
        error: "Invalid or expired token"
      });
    }

    res.json({
      valid: true,
      user: {
        id: decoded.id,
        email: decoded.email,
        name: decoded.name,
        image: decoded.image,
        provider: decoded.provider,
      },
    });
  } catch (error) {
    console.error("Token verification error:", error);
    res.status(500).json({ error: "Token verification failed" });
  }
});

// Get current user info from JWT
app.get("/api/auth/me", (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    const token = authHeader && authHeader.startsWith("Bearer ")
      ? authHeader.substring(7)
      : null;

    if (!token) {
      return res.status(401).json({ error: "Not authenticated" });
    }

    const decoded = verifyToken(token);

    if (!decoded) {
      return res.status(401).json({ error: "Invalid or expired token" });
    }

    res.json({
      user: {
        id: decoded.id,
        email: decoded.email,
        name: decoded.name,
        image: decoded.image,
        provider: decoded.provider,
      },
    });
  } catch (error) {
    console.error("Get user error:", error);
    res.status(500).json({ error: "Failed to get user info" });
  }
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error("Error:", err);
  res.status(err.status || 500).json({
    error: err.message || "Internal server error",
  });
});

// Start the server
app.listen(PORT, HOST, () => {
  console.log(`🚀 Stateless JWT Auth Service running on http://${HOST}:${PORT}`);
  console.log(`📍 Auth endpoints: http://${HOST}:${PORT}/api/auth/*`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV || "development"}`);
  console.log(`🏠 Frontend URL: ${FRONTEND_URL}`);
  console.log(`🔐 OAuth providers configured:`);

  const enabledProviders = getEnabledProviders();
  if (enabledProviders.length > 0) {
    enabledProviders.forEach(p => {
      console.log(`   ✓ ${providers[p].name}`);
    });
  } else {
    console.log(`   ⚠ None (configure in .env file)`);
  }

  console.log(`\n💡 No database required - fully stateless JWT authentication`);
});

// Graceful shutdown
process.on("SIGTERM", () => {
  console.log("SIGTERM signal received: closing HTTP server");
  process.exit(0);
});
