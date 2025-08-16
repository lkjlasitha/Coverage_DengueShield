'use client';

import React, { useEffect, useRef, useState } from 'react';
import { useGoogleMaps } from '@/hooks/useGoogleMaps';

interface GoogleMapProps {
  center?: { lat: number; lng: number };
  zoom?: number;
  className?: string;
  onMapLoad?: (map: google.maps.Map) => void;
}

const GoogleMap: React.FC<GoogleMapProps> = ({
  center = { lat: 7.8731, lng: 80.7718 }, // Default to Sri Lanka center
  zoom = 8,
  className = '',
  onMapLoad
}) => {
  const mapRef = useRef<HTMLDivElement>(null);
  const [map, setMap] = useState<google.maps.Map | null>(null);
  const { isLoaded, loadError } = useGoogleMaps();

  useEffect(() => {
    if (!isLoaded || !mapRef.current || map) return;

    try {
      const mapInstance = new google.maps.Map(mapRef.current, {
        center,
        zoom,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        styles: [
          {
            featureType: 'water',
            elementType: 'geometry',
            stylers: [{ color: '#e9e9e9' }, { lightness: 17 }]
          },
          {
            featureType: 'landscape',
            elementType: 'geometry',
            stylers: [{ color: '#f5f5f5' }, { lightness: 20 }]
          },
          {
            featureType: 'road.highway',
            elementType: 'geometry.fill',
            stylers: [{ color: '#ffffff' }, { lightness: 17 }]
          },
          {
            featureType: 'road.highway',
            elementType: 'geometry.stroke',
            stylers: [{ color: '#ffffff' }, { lightness: 29 }, { weight: 0.2 }]
          },
          {
            featureType: 'road.arterial',
            elementType: 'geometry',
            stylers: [{ color: '#ffffff' }, { lightness: 18 }]
          },
          {
            featureType: 'road.local',
            elementType: 'geometry',
            stylers: [{ color: '#ffffff' }, { lightness: 16 }]
          },
          {
            featureType: 'poi',
            elementType: 'geometry',
            stylers: [{ color: '#f5f5f5' }, { lightness: 21 }]
          },
          {
            featureType: 'poi.park',
            elementType: 'geometry',
            stylers: [{ color: '#dedede' }, { lightness: 21 }]
          },
          {
            elementType: 'labels.text.stroke',
            stylers: [{ visibility: 'on' }, { color: '#ffffff' }, { lightness: 16 }]
          },
          {
            elementType: 'labels.text.fill',
            stylers: [{ saturation: 36 }, { color: '#333333' }, { lightness: 40 }]
          },
          {
            elementType: 'labels.icon',
            stylers: [{ visibility: 'off' }]
          },
          {
            featureType: 'transit',
            elementType: 'geometry',
            stylers: [{ color: '#f2f2f2' }, { lightness: 19 }]
          },
          {
            featureType: 'administrative',
            elementType: 'geometry.fill',
            stylers: [{ color: '#fefefe' }, { lightness: 20 }]
          },
          {
            featureType: 'administrative',
            elementType: 'geometry.stroke',
            stylers: [{ color: '#fefefe' }, { lightness: 17 }, { weight: 1.2 }]
          }
        ]
      });

      setMap(mapInstance);
      onMapLoad?.(mapInstance);
    } catch (err) {
      console.error('Error initializing map:', err);
    }
  }, [isLoaded, center, zoom, onMapLoad, map]);

  if (loadError) {
    return (
      <div className={`relative ${className}`}>
        <div className="w-full h-full rounded-lg bg-red-50 border border-red-200 flex items-center justify-center" style={{ minHeight: '400px' }}>
          <div className="text-center">
            <div className="text-red-600 mb-2">
              <svg className="w-12 h-12 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
              </svg>
            </div>
            <h3 className="text-lg font-medium text-red-800 mb-2">Map Error</h3>
            <p className="text-red-600">{loadError}</p>
          </div>
        </div>
      </div>
    );
  }

  return (
    <div className={`relative ${className}`}>
      <div
        ref={mapRef}
        className="w-full h-full rounded-lg"
        style={{ minHeight: '400px' }}
      />
      {!isLoaded && (
        <div className="absolute inset-0 flex items-center justify-center bg-gray-100 rounded-lg">
          <div className="flex flex-col items-center">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-[#4F46E5]"></div>
            <p className="mt-2 text-gray-600">Loading map...</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default GoogleMap;
