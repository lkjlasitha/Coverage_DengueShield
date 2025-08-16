'use client';

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';

interface User {
  id: string;
  name: string;
  email: string;
  role?: string;
}

interface AuthContextType {
  user: User | null;
  token: string | null;
  isLoading: boolean;
  login: (email: string, password: string) => Promise<{ success: boolean; message: string }>;
  signup: (userData: SignupData) => Promise<{ success: boolean; message: string }>;
  logout: () => void;
  isAuthenticated: boolean;
}

interface SignupData {
  name: string;
  email: string;
  password: string;
  confirmPassword: string;
  role?: string;
}

// Utility function to decode JWT token
const decodeToken = (token: string) => {
  try {
    const base64Url = token.split('.')[1];
    const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
    const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
      return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
    }).join(''));
    
    return JSON.parse(jsonPayload);
  } catch (error) {
    console.error('Error decoding token:', error);
    return null;
  }
};

// Safe localStorage access
const safeLocalStorage = {
  getItem: (key: string) => {
    if (typeof window !== 'undefined') {
      return localStorage.getItem(key);
    }
    return null;
  },
  setItem: (key: string, value: string) => {
    if (typeof window !== 'undefined') {
      localStorage.setItem(key, value);
    }
  },
  removeItem: (key: string) => {
    if (typeof window !== 'undefined') {
      localStorage.removeItem(key);
    }
  }
};

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isClient, setIsClient] = useState(false);

  // Ensure we're on the client side
  useEffect(() => {
    setIsClient(true);
  }, []);

  // Check for existing token on mount
  useEffect(() => {
    if (!isClient) return;
    
    const checkAuth = async () => {
      try {
        const storedToken = safeLocalStorage.getItem('auth_token');
        const storedUser = safeLocalStorage.getItem('auth_user');
        
        if (storedToken) {
          // Decode token to check expiration
          const tokenPayload = decodeToken(storedToken);
          
          if (tokenPayload && tokenPayload.exp && tokenPayload.exp * 1000 > Date.now()) {
            // Token is valid and not expired
            if (storedUser) {
              setToken(storedToken);
              setUser(JSON.parse(storedUser));
            } else {
              // Create user from token if stored user is missing
              const user = {
                id: tokenPayload.email,
                name: tokenPayload.name || '',
                email: tokenPayload.email,
                role: tokenPayload.role
              };
              localStorage.setItem('auth_user', JSON.stringify(user));
              setToken(storedToken);
              setUser(user);
            }
          } else {
            // Token expired or invalid, clear storage
            safeLocalStorage.removeItem('auth_token');
            safeLocalStorage.removeItem('auth_user');
          }
        }
      } catch (error) {
        console.error('Auth check failed:', error);
        safeLocalStorage.removeItem('auth_token');
        safeLocalStorage.removeItem('auth_user');
      } finally {
        setIsLoading(false);
      }
    };

    checkAuth();
  }, [isClient]);

  const validateToken = async (token: string): Promise<boolean> => {
    try {
      // Replace with your actual API endpoint
      const response = await fetch('/api/auth/validate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });
      
      return response.ok;
    } catch (error) {
      console.error('Token validation failed:', error);
      return false;
    }
  };

  const login = async (email: string, password: string): Promise<{ success: boolean; message: string }> => {
    try {
      setIsLoading(true);
      
      // Replace with your actual API endpoint
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email, password }),
      });

      const data = await response.json();

      if (response.ok) {
        const { token, role } = data;
        
        // Decode token to get user information
        const tokenPayload = decodeToken(token);
        
        // Create user object from token data and API response
        const user = {
          id: tokenPayload?.email || email,
          name: tokenPayload?.name || '',
          email: tokenPayload?.email || email,
          role: role || tokenPayload?.role
        };
        
        // Store token in localStorage
        safeLocalStorage.setItem('auth_token', token);
        safeLocalStorage.setItem('auth_user', JSON.stringify(user));
        
        // Update state
        setToken(token);
        setUser(user);
        
        return { success: true, message: 'Login successful' };
      } else {
        return { success: false, message: data.message || 'Login failed' };
      }
    } catch (error) {
      console.error('Login error:', error);
      return { success: false, message: 'Network error. Please try again.' };
    } finally {
      setIsLoading(false);
    }
  };

  const signup = async (userData: SignupData): Promise<{ success: boolean; message: string }> => {
    try {
      setIsLoading(true);

      // Validate government email
      if (!userData.email.includes('.gov.') && !userData.email.includes('government')) {
        return { success: false, message: 'Please use a government email address' };
      }

      // Validate password match
      if (userData.password !== userData.confirmPassword) {
        return { success: false, message: 'Passwords do not match' };
      }

      // Replace with your actual API endpoint
      const response = await fetch('/api/auth/signup', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          name: userData.name,
          email: userData.email,
          password: userData.password,
          role: userData.role || 'admin',
        }),
      });

      const data = await response.json();

      if (response.ok) {
        return { success: true, message: 'Account created successfully. Please login.' };
      } else {
        return { success: false, message: data.message || 'Signup failed' };
      }
    } catch (error) {
      console.error('Signup error:', error);
      return { success: false, message: 'Network error. Please try again.' };
    } finally {
      setIsLoading(false);
    }
  };

  const logout = () => {
    safeLocalStorage.removeItem('auth_token');
    safeLocalStorage.removeItem('auth_user');
    setToken(null);
    setUser(null);
  };

  const value: AuthContextType = {
    user,
    token,
    isLoading,
    login,
    signup,
    logout,
    isAuthenticated: !!token && !!user,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};
