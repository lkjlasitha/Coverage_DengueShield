'use client';

import React, { useState } from 'react';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';
import { useAuth } from '@/contexts/AuthContext';

const AlertsPage: React.FC = () => {
  const [selectedMethod, setSelectedMethod] = useState('Send Now');
  const { user } = useAuth();

  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        <Sidebar />
        <div className="flex-1 ml-64">
          <header className="bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h1 className="text-2xl font-bold text-gray-900">Alerts & Notices</h1>
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
          <main className="p-6 overflow-y-auto">
            {/* Create New Alert Form */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-6">
              <h2 className="text-lg font-semibold text-gray-900 mb-6">Create New Alert</h2>
              
              <div className="grid grid-cols-2 gap-8">
                {/* Left Column */}
                <div className="space-y-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">District</label>
                    <select className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white text-gray-700 focus:ring-2 focus:ring-[#4F46E5] focus:border-[#4F46E5]">
                      <option>Colombo</option>
                      <option>Kandy</option>
                      <option>Galle</option>
                      <option>Anuradhapura</option>
                    </select>
                    <p className="text-xs text-gray-500 mt-1">Based on your device location.</p>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Message</label>
                    <textarea
                      className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:ring-2 focus:ring-[#4F46E5] focus:border-[#4F46E5]"
                      rows={4}
                      placeholder="Type here"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Posted Method</label>
                    <div className="flex space-x-2 mb-2">
                      <button
                        type="button"
                        onClick={() => setSelectedMethod('Schedule')}
                        className={`px-4 py-2 rounded-lg border font-medium transition-colors ${
                          selectedMethod === 'Schedule'
                            ? 'bg-blue-50 border-blue-300 text-blue-700'
                            : 'bg-gray-50 border-gray-300 text-gray-700 hover:bg-gray-100'
                        }`}
                      >
                        Schedule
                      </button>
                      <button
                        type="button"
                        onClick={() => setSelectedMethod('Send Now')}
                        className={`px-4 py-2 rounded-lg border font-medium transition-colors ${
                          selectedMethod === 'Send Now'
                            ? 'bg-blue-50 border-blue-300 text-blue-700'
                            : 'bg-gray-50 border-gray-300 text-gray-700 hover:bg-gray-100'
                        }`}
                      >
                        Send Now
                      </button>
                    </div>
                    <p className="text-xs text-gray-500">Alert will be sent immediately after submission.</p>
                  </div>
                </div>
                
                {/* Right Column */}
                <div className="space-y-6">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Alert Title</label>
                    <input
                      type="text"
                      className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:ring-2 focus:ring-[#4F46E5] focus:border-[#4F46E5]"
                      placeholder="Enter title"
                    />
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Target Audience</label>
                    <select className="w-full border border-gray-300 rounded-lg px-3 py-2 bg-white text-gray-700 focus:ring-2 focus:ring-[#4F46E5] focus:border-[#4F46E5]">
                      <option>Officers Only</option>
                      <option>Public and Officers</option>
                    </select>
                  </div>
                  
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">Additional Info</label>
                    <input
                      type="text"
                      className="w-full border border-gray-300 rounded-lg px-3 py-2 text-gray-700 focus:ring-2 focus:ring-[#4F46E5] focus:border-[#4F46E5]"
                      placeholder="Type here"
                    />
                  </div>
                </div>
              </div>
              
              {/* Action Buttons */}
              <div className="flex space-x-4 mt-8">
                <button
                  type="submit"
                  className="bg-[#4F46E5] hover:bg-blue-700 text-white font-semibold px-8 py-3 rounded-lg transition-colors"
                >
                  Send Alert
                </button>
                <button
                  type="button"
                  className="border border-[#4F46E5] text-[#4F46E5] font-semibold px-8 py-3 rounded-lg transition-colors hover:bg-blue-50"
                >
                  Preview
                </button>
              </div>
            </div>
            
            {/* Recent Alerts */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
              <div className="mb-6">
                <h3 className="text-lg font-semibold text-gray-900">Recent Alerts</h3>
                <p className="text-sm text-gray-500">Up to 2025.08.10 12:46pm</p>
              </div>
              
              <div className="space-y-4">
                <div className="flex items-center justify-between py-3 border-b border-gray-100">
                  <div className="flex-1">
                    <h4 className="font-medium text-gray-900">Emergency Weather Warning</h4>
                  </div>
                  <div className="flex items-center space-x-8 text-sm text-gray-600">
                    <span>2025.08.08 8:00am</span>
                    <span>Public and Officers</span>
                    <span className="bg-green-100 text-green-800 px-3 py-1 rounded-full text-xs font-medium">
                      Sent
                    </span>
                    <button className="text-gray-400 hover:text-gray-600">
                      <span>⋯</span>
                    </button>
                  </div>
                </div>
                
                <div className="flex items-center justify-between py-3">
                  <div className="flex-1">
                    <h4 className="font-medium text-gray-900">Security Alert Update</h4>
                  </div>
                  <div className="flex items-center space-x-8 text-sm text-gray-600">
                    <span>2025.08.07 4:45pm</span>
                    <span>Officers only</span>
                    <span className="bg-yellow-100 text-yellow-800 px-3 py-1 rounded-full text-xs font-medium">
                      Scheduled
                    </span>
                    <button className="text-gray-400 hover:text-gray-600">
                      <span>⋯</span>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          </main>
        </div>
      </div>
    </ProtectedRoute>
  );
};

export default AlertsPage;
