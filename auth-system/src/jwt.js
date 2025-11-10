import jwt from "jsonwebtoken";

const JWT_SECRET = process.env.JWT_SECRET || "default-secret-change-in-production";
const JWT_EXPIRY = process.env.JWT_EXPIRY || "7d";

/**
 * Generate a JWT token for a user
 * @param {Object} user - User object containing id, email, name, etc.
 * @returns {string} JWT token
 */
export function generateToken(user) {
  const payload = {
    id: user.id,
    email: user.email,
    name: user.name,
    image: user.image || user.avatar_url || user.picture,
    provider: user.provider,
  };

  return jwt.sign(payload, JWT_SECRET, {
    expiresIn: JWT_EXPIRY,
    issuer: "webroot-earth-auth",
  });
}

/**
 * Verify and decode a JWT token
 * @param {string} token - JWT token to verify
 * @returns {Object|null} Decoded token payload or null if invalid
 */
export function verifyToken(token) {
  try {
    return jwt.verify(token, JWT_SECRET, {
      issuer: "webroot-earth-auth",
    });
  } catch (error) {
    console.error("JWT verification failed:", error.message);
    return null;
  }
}

/**
 * Decode token without verification (useful for debugging)
 * @param {string} token - JWT token to decode
 * @returns {Object|null} Decoded token or null
 */
export function decodeToken(token) {
  try {
    return jwt.decode(token);
  } catch (error) {
    return null;
  }
}
