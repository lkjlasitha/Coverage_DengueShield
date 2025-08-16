'use client';

import React, { useState } from 'react';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';
import { useAuth } from '@/contexts/AuthContext';

interface FogRequest {
  id: string;
  requesterName: string;
  latitude: number;
  longitude: number;
  address: string;
  city: string;
  divisionalSecretary: string;
  status: 'Pending' | 'Sent';
  requestDate: string;
}

const FogRequestsPage: React.FC = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [loadingStates, setLoadingStates] = useState<Record<string, boolean>>({});
  const { user } = useAuth();

  // Mock fog request data
  const [fogRequests, setFogRequests] = useState<FogRequest[]>([
    {
      id: 'FR001',
      requesterName: 'Thusheera Dimal',
      latitude: 6.9271,
      longitude: 79.8612,
      address: '123 Galle Road, Colombo 03',
      city: 'Colombo',
      divisionalSecretary: 'Colombo Central',
      status: 'Pending',
      requestDate: '2024-01-15'
    },
    {
      id: 'FR002',
      requesterName: 'Lakshitha Perera',
      latitude: 6.9319,
      longitude: 79.8478,
      address: '456 Kandy Road, Kandy',
      city: 'Kandy',
      divisionalSecretary: 'Kandy Municipal',
      status: 'Sent',
      requestDate: '2024-01-14'
    },
    {
      id: 'FR003',
      requesterName: 'Kavindu ',
      latitude: 6.0535,
      longitude: 80.2210,
      address: '789 Beach Road, Galle',
      city: 'Galle',
      divisionalSecretary: 'Galle Four Gravets',
      status: 'Pending',
      requestDate: '2024-01-13'
    },
    {
      id: 'FR004',
      requesterName: 'Brian Silva',
      latitude: 7.2906,
      longitude: 80.6337,
      address: '321 Hill Street, Kurunegala',
      city: 'Kurunegala',
      divisionalSecretary: 'Kurunegala Central',
      status: 'Sent',
      requestDate: '2024-01-12'
    },
    {
      id: 'FR005',
      requesterName: 'Harshana Panagoda',
      latitude: 7.8731,
      longitude: 80.7718,
      address: '654 Main Street, Anuradhapura',
      city: 'Anuradhapura',
      divisionalSecretary: 'Anuradhapura East',
      status: 'Pending',
      requestDate: '2024-01-11'
    }
  ]);

  const handleSendToPHI = async (requestId: string) => {
    setLoadingStates(prev => ({ ...prev, [requestId]: true }));
    
    // Simulate API call delay
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    setFogRequests(prev => 
      prev.map(request => 
        request.id === requestId 
          ? { ...request, status: 'Sent' as const }
          : request
      )
    );
    
    setLoadingStates(prev => ({ ...prev, [requestId]: false }));
  };

  const handleOpenInMap = (latitude: number, longitude: number) => {
    const googleMapsUrl = `https://www.google.com/maps?q=${latitude},${longitude}`;
    window.open(googleMapsUrl, '_blank');
  };

  const filteredRequests = fogRequests.filter(request =>
    request.requesterName.toLowerCase().includes(searchTerm.toLowerCase()) ||
    request.address.toLowerCase().includes(searchTerm.toLowerCase()) ||
    request.city.toLowerCase().includes(searchTerm.toLowerCase()) ||
    request.id.toLowerCase().includes(searchTerm.toLowerCase()) ||
    request.divisionalSecretary.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const pendingCount = filteredRequests.filter(r => r.status === 'Pending').length;
  const sentCount = filteredRequests.filter(r => r.status === 'Sent').length;

  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        <Sidebar />
        <div className="flex-1 ml-64">
          <header className="bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h1 className="text-2xl font-bold text-gray-900">Fog Requests</h1>
            <div className="flex items-center space-x-4">
              <div className="text-sm text-gray-500">
                {new Date().toLocaleDateString('en-US', { 
                  weekday: 'short', 
                  year: 'numeric', 
                  month: 'short', 
                  day: 'numeric' 
                })}
              </div>
              <div className="flex items-center space-x-2">
                <div className="w-8 h-8 bg-[#4F46E5] rounded-full flex items-center justify-center">
                  <span className="text-white text-sm font-medium">
                    {user?.name?.charAt(0) || 'U'}
                  </span>
                </div>
                <span className="text-sm font-medium text-gray-700">{user?.name}</span>
              </div>
            </div>
          </header>
          
          <main className="p-6">
            {/* Search and Filter Bar */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center space-x-4">
                  <div className="relative">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                      </svg>
                    </div>
                    <input
                      type="text"
                      placeholder="Search requests..."
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="block w-80 pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-[#4F46E5] focus:border-[#4F46E5]"
                    />
                  </div>
                  <button className="flex items-center space-x-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white hover:bg-gray-50">
                    <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.414A1 1 0 013 6.707V4z" />
                    </svg>
                    <span>Filter</span>
                  </button>
                </div>
                
                <div className="flex items-center space-x-4">
                  <div className="flex items-center space-x-3">
                    <div className="text-sm text-gray-600">
                      Total: {filteredRequests.length}
                    </div>
                    <div className="text-sm text-orange-600 bg-orange-50 px-3 py-1 rounded-full">
                      Pending: {pendingCount}
                    </div>
                    <div className="text-sm text-green-600 bg-green-50 px-3 py-1 rounded-full">
                      Sent: {sentCount}
                    </div>
                  </div>
                </div>
              </div>

              {/* Table */}
              <div className="overflow-hidden">
                <table className="min-w-full">
                  <thead>
                    <tr className="border-b border-gray-200">
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Request ID</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Requester Name</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Location</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Address</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">City</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Divisional Secretary</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Status</th>
                      <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Action</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-100">
                    {filteredRequests.map((request) => (
                      <tr key={request.id} className="hover:bg-gray-50">
                        <td className="py-4 px-4 text-sm text-gray-900 font-medium">{request.id}</td>
                        <td className="py-4 px-4 text-sm text-gray-900">{request.requesterName}</td>
                        <td className="py-4 px-4">
                          <div className="flex flex-col space-y-1">
                            <div className="text-xs text-gray-500">
                              {request.latitude.toFixed(4)}, {request.longitude.toFixed(4)}
                            </div>
                            <button 
                              onClick={() => handleOpenInMap(request.latitude, request.longitude)}
                              className="bg-green-100 text-green-800 text-xs font-medium px-2 py-1 rounded-full hover:bg-green-200 transition-colors w-fit"
                            >
                              Open in Map
                            </button>
                          </div>
                        </td>
                        <td className="py-4 px-4 text-sm text-gray-900 max-w-xs truncate" title={request.address}>
                          {request.address}
                        </td>
                        <td className="py-4 px-4 text-sm text-gray-900">{request.city}</td>
                        <td className="py-4 px-4 text-sm text-gray-600">{request.divisionalSecretary}</td>
                        <td className="py-4 px-4">
                          <span className={`inline-flex items-center px-3 py-1 rounded-full text-xs font-medium ${
                            request.status === 'Sent' 
                              ? 'bg-green-100 text-green-800' 
                              : 'bg-orange-100 text-orange-800'
                          }`}>
                            {request.status}
                          </span>
                        </td>
                        <td className="py-4 px-4">
                          {request.status === 'Pending' ? (
                            <button
                              onClick={() => handleSendToPHI(request.id)}
                              disabled={loadingStates[request.id]}
                              className="bg-[#4F46E5] hover:bg-[#6862e1] disabled:bg-[#4F46E5] text-white font-medium px-4 py-2 rounded-lg text-sm transition-colors flex items-center space-x-2"
                            >
                              {loadingStates[request.id] ? (
                                <>
                                  <svg className="animate-spin h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                                  </svg>
                                  <span>Sending...</span>
                                </>
                              ) : (
                                <span>Send to PHI</span>
                              )}
                            </button>
                          ) : (
                            <span className="text-sm text-gray-500 italic">Sent to PHI</span>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>

              {/* Empty state */}
              {filteredRequests.length === 0 && (
                <div className="text-center py-12">
                  <svg className="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                  </svg>
                  <h3 className="mt-2 text-sm font-medium text-gray-900">No fog requests found</h3>
                  <p className="mt-1 text-sm text-gray-500">
                    {searchTerm ? 'Try adjusting your search terms.' : 'No fog requests have been submitted yet.'}
                  </p>
                </div>
              )}
            </div>
          </main>
        </div>
      </div>
    </ProtectedRoute>
  );
};

export default FogRequestsPage;
