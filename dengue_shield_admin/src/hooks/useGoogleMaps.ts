'use client';

import { useState, useEffect } from 'react';

interface UseGoogleMapsReturn {
  isLoaded: boolean;
  loadError: string | null;
}

// Global state for Google Maps loading
let globalLoadState = {
  isLoaded: false,
  isLoading: false,
  loadError: null as string | null,
  loadPromise: null as Promise<void> | null,
  listeners: new Set<() => void>()
};

const loadGoogleMapsScript = (): Promise<void> => {
  // If already loaded, return resolved promise
  if (globalLoadState.isLoaded) {
    return Promise.resolve();
  }

  // If already loading, return the existing promise
  if (globalLoadState.isLoading && globalLoadState.loadPromise) {
    return globalLoadState.loadPromise;
  }

  // Check if Google Maps is already available
  if (window.google && window.google.maps) {
    globalLoadState.isLoaded = true;
    return Promise.resolve();
  }

  // Check if script already exists in DOM
  const existingScript = document.querySelector('script[src*="maps.googleapis.com"]');
  if (existingScript) {
    globalLoadState.isLoading = true;
    globalLoadState.loadPromise = new Promise((resolve) => {
      const checkLoaded = () => {
        if (window.google && window.google.maps) {
          globalLoadState.isLoaded = true;
          globalLoadState.isLoading = false;
          globalLoadState.loadError = null;
          notifyListeners();
          resolve();
        } else {
          setTimeout(checkLoaded, 100);
        }
      };
      checkLoaded();
    });
    return globalLoadState.loadPromise;
  }

  const apiKey = process.env.NEXT_PUBLIC_GOOGLE_MAPS_API_KEY;
  if (!apiKey) {
    const error = 'Google Maps API key is not defined';
    globalLoadState.loadError = error;
    notifyListeners();
    return Promise.reject(new Error(error));
  }

  globalLoadState.isLoading = true;
  globalLoadState.loadPromise = new Promise((resolve, reject) => {
    const script = document.createElement('script');
    script.src = `https://maps.googleapis.com/maps/api/js?key=${apiKey}&libraries=places`;
    script.async = true;
    script.defer = true;
    
    script.onload = () => {
      globalLoadState.isLoaded = true;
      globalLoadState.isLoading = false;
      globalLoadState.loadError = null;
      notifyListeners();
      resolve();
    };
    
    script.onerror = () => {
      const error = 'Failed to load Google Maps script';
      globalLoadState.isLoading = false;
      globalLoadState.loadError = error;
      globalLoadState.loadPromise = null;
      notifyListeners();
      reject(new Error(error));
    };

    document.head.appendChild(script);
  });

  return globalLoadState.loadPromise;
};

const notifyListeners = () => {
  globalLoadState.listeners.forEach(listener => listener());
};

export const useGoogleMaps = (): UseGoogleMapsReturn => {
  const [state, setState] = useState({
    isLoaded: globalLoadState.isLoaded,
    loadError: globalLoadState.loadError
  });

  useEffect(() => {
    const updateState = () => {
      setState({
        isLoaded: globalLoadState.isLoaded,
        loadError: globalLoadState.loadError
      });
    };

    // Add listener
    globalLoadState.listeners.add(updateState);

    // Start loading if not already loaded or loading
    if (!globalLoadState.isLoaded && !globalLoadState.isLoading) {
      loadGoogleMapsScript().catch(() => {
        // Error is already handled in global state
      });
    }

    // Cleanup listener on unmount
    return () => {
      globalLoadState.listeners.delete(updateState);
    };
  }, []);

  return state;
};
