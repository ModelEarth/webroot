/**
 * WebRoot Earth Auth Client
 * Stateless JWT authentication client for browser
 *
 * Usage:
 *   <script src="https://your-auth-system.run.app/auth-client.js"></script>
 *   <script>
 *     // For production, use your Cloud Run URL
 *     const auth = new AuthClient('https://webroot-auth-xxxxx-uc.a.run.app');
 *
 *     // For local development
 *     // const auth = new AuthClient('http://localhost:3001');
 *
 *     auth.signIn('google');
 *   </script>
 */

class AuthClient {
  constructor(baseUrl = 'http://localhost:3001') {
    // Default to localhost for development
    // In production, always pass your Cloud Run URL explicitly
    this.baseUrl = baseUrl;
    this.tokenKey = 'auth_token';
    this.userKey = 'auth_user';
  }

  /**
   * Get stored JWT token
   */
  getToken() {
    return localStorage.getItem(this.tokenKey);
  }

  /**
   * Store JWT token
   */
  setToken(token) {
    localStorage.setItem(this.tokenKey, token);
  }

  /**
   * Remove JWT token
   */
  removeToken() {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.userKey);
  }

  /**
   * Get stored user info
   */
  getUser() {
    const userJson = localStorage.getItem(this.userKey);
    return userJson ? JSON.parse(userJson) : null;
  }

  /**
   * Store user info
   */
  setUser(user) {
    localStorage.setItem(this.userKey, JSON.stringify(user));
  }

  /**
   * Check if user is authenticated
   */
  isAuthenticated() {
    return !!this.getToken();
  }

  /**
   * Get available OAuth providers
   */
  async getProviders() {
    try {
      const response = await fetch(`${this.baseUrl}/api/auth/providers`);
      const data = await response.json();
      return data.providers;
    } catch (error) {
      console.error('Failed to get providers:', error);
      return [];
    }
  }

  /**
   * Initiate sign in with OAuth provider
   * @param {string} provider - Provider ID (google, github, microsoft, discord)
   */
  async signIn(provider) {
    try {
      // Get authorization URL
      const response = await fetch(`${this.baseUrl}/api/auth/${provider}/url`);
      const data = await response.json();

      if (data.url) {
        // Redirect to OAuth provider
        window.location.href = data.url;
      } else {
        throw new Error('Failed to get authorization URL');
      }
    } catch (error) {
      console.error('Sign in error:', error);
      throw error;
    }
  }

  /**
   * Handle OAuth callback
   * Call this on your callback page
   */
  handleCallback() {
    const params = new URLSearchParams(window.location.search);
    const token = params.get('token');
    const error = params.get('error');

    if (error) {
      console.error('Auth error:', error);
      return { success: false, error };
    }

    if (token) {
      this.setToken(token);

      // Decode and store user info (JWT payload)
      const user = this.decodeToken(token);
      if (user) {
        this.setUser(user);
      }

      // Clean up URL
      window.history.replaceState({}, document.title, window.location.pathname);

      return { success: true, token, user };
    }

    return { success: false, error: 'No token received' };
  }

  /**
   * Decode JWT token (client-side, no verification)
   */
  decodeToken(token) {
    try {
      const base64Url = token.split('.')[1];
      const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
      const jsonPayload = decodeURIComponent(
        atob(base64)
          .split('')
          .map(c => '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2))
          .join('')
      );
      return JSON.parse(jsonPayload);
    } catch (error) {
      console.error('Failed to decode token:', error);
      return null;
    }
  }

  /**
   * Verify token with server
   */
  async verifyToken(token = null) {
    const tokenToVerify = token || this.getToken();

    if (!tokenToVerify) {
      return { valid: false, error: 'No token' };
    }

    try {
      const response = await fetch(`${this.baseUrl}/api/auth/verify`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ token: tokenToVerify }),
      });

      const data = await response.json();

      if (data.valid) {
        this.setUser(data.user);
      }

      return data;
    } catch (error) {
      console.error('Token verification error:', error);
      return { valid: false, error: error.message };
    }
  }

  /**
   * Get current user from server
   */
  async getCurrentUser() {
    const token = this.getToken();

    if (!token) {
      return null;
    }

    try {
      const response = await fetch(`${this.baseUrl}/api/auth/me`, {
        headers: {
          'Authorization': `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        throw new Error('Failed to get user');
      }

      const data = await response.json();
      this.setUser(data.user);
      return data.user;
    } catch (error) {
      console.error('Get user error:', error);
      return null;
    }
  }

  /**
   * Sign out
   */
  signOut() {
    this.removeToken();
    // Optionally redirect to home page
    // window.location.href = '/';
  }

  /**
   * Make authenticated API request
   * @param {string} url - API endpoint URL
   * @param {Object} options - Fetch options
   */
  async authenticatedFetch(url, options = {}) {
    const token = this.getToken();

    if (!token) {
      throw new Error('Not authenticated');
    }

    const headers = {
      ...options.headers,
      'Authorization': `Bearer ${token}`,
    };

    const response = await fetch(url, { ...options, headers });

    // If unauthorized, token might be expired
    if (response.status === 401) {
      this.removeToken();
      throw new Error('Token expired or invalid');
    }

    return response;
  }
}

// Make available globally
if (typeof window !== 'undefined') {
  window.AuthClient = AuthClient;
}

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
  module.exports = AuthClient;
}
