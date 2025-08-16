'use client';

import React, { useCallback, useState } from 'react';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';
import GoogleMap from '@/components/GoogleMap';

const MapPage: React.FC = () => {
  const [mapInstance, setMapInstance] = useState<google.maps.Map | null>(null);

  const handleMapLoad = useCallback((map: google.maps.Map) => {
    setMapInstance(map);
    
    // Add some sample markers for demonstration
    const locations = [
      { lat: 6.9271, lng: 79.8612, title: 'Colombo' },
      { lat: 7.2906, lng: 80.6337, title: 'Kandy' },
      { lat: 6.0535, lng: 80.2210, title: 'Galle' },
      { lat: 8.3114, lng: 80.4037, title: 'Anuradhapura' },
    ];

    locations.forEach(location => {
      new google.maps.Marker({
        position: { lat: location.lat, lng: location.lng },
        map: map,
        title: location.title,
        icon: {
          path: google.maps.SymbolPath.CIRCLE,
          scale: 8,
          fillColor: '#ef4444',
          fillOpacity: 0.8,
          strokeColor: '#dc2626',
          strokeWeight: 2,
        }
      });
    });
  }, []);

  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        <Sidebar />
        <div className="flex-1 ml-64">
          <header className="bg-white border-b border-gray-200 px-6 py-4">
            <h1 className="text-2xl font-bold text-gray-900">Dengue Surveillance Map</h1>
            <p className="text-gray-600 mt-1">Real-time dengue outbreak monitoring and reporting</p>
          </header>
          <main className="p-6 h-full">
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 h-full">
              <div className="p-4 border-b border-gray-100">
                <div className="flex items-center justify-between">
                  <div>
                    <h2 className="text-lg font-semibold text-gray-900">Interactive Map</h2>
                    <p className="text-sm text-gray-600">Click on markers to view dengue case details</p>
                  </div>
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center">
                      <div className="w-3 h-3 bg-red-500 rounded-full mr-2"></div>
                      <span className="text-sm text-gray-600">Dengue Cases</span>
                    </div>
                    <div className="flex items-center">
                      <div className="w-3 h-3 bg-yellow-500 rounded-full mr-2"></div>
                      <span className="text-sm text-gray-600">High Risk Areas</span>
                    </div>
                    <div className="flex items-center">
                      <div className="w-3 h-3 bg-green-500 rounded-full mr-2"></div>
                      <span className="text-sm text-gray-600">Medical Centers</span>
                    </div>
                  </div>
                </div>
              </div>
              <div className="p-4" style={{ height: 'calc(100% - 120px)' }}>
                <GoogleMap
                  center={{ lat: 7.8731, lng: 80.7718 }}
                  zoom={8}
                  className="w-full h-full"
                  onMapLoad={handleMapLoad}
                />
              </div>
            </div>
          </main>
        </div>
      </div>
    </ProtectedRoute>
  );
};

export default MapPage;
