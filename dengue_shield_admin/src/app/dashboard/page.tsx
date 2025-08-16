'use client';

import React from 'react';
import { useAuth } from '@/contexts/AuthContext';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';
import StatCard from '@/components/StatCard';
import SimpleBarChart from '@/components/SimpleBarChart';
import SimpleLineChart from '@/components/SimpleLineChart';

const DashboardPage: React.FC = () => {
  const { user } = useAuth();

  // Mock data for charts
  const userActivityData = [45, 52, 38, 65, 70, 55, 48];
  const casesData = [20, 25, 22, 28, 32, 30, 35];

  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        {/* Sidebar */}
        <Sidebar />

        {/* Main Content */}
        <div className="flex-1 ml-64">
          {/* Header */}
          <header className="bg-white border-b border-gray-200 px-6 py-4">
            <div className="flex items-center justify-between">
              <div>
                <h1 className="text-2xl font-bold text-gray-900">Dashboard</h1>
              </div>
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
            </div>
          </header>

          {/* Dashboard Content */}
          <main className="p-6">
            {/* Stats Grid */}
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
              {/* Active Users */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
                    <svg className="w-6 h-6 text-[#4F46E5]" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
                    </svg>
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-gray-900">1,252</h3>
                <p className="text-sm text-gray-600">Active Users</p>
                <div className="mt-4">
                  <SimpleBarChart data={userActivityData} color="bg-[#4F46E5]" height={40} />
                </div>
              </div>

              {/* New Cases Today */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center space-x-3">
                    <div className="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center">
                      <svg className="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                      </svg>
                    </div>
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-gray-900">4</h3>
                <p className="text-sm text-gray-600">New Cases Today</p>
                <div className="mt-4">
                  <SimpleLineChart data={casesData} color="stroke-green-500" height={40} />
                </div>
              </div>

              {/* Active Hotspot */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center justify-between mb-4">
                  <div className="flex items-center space-x-3">
                    <div className="w-12 h-12 bg-orange-100 rounded-xl flex items-center justify-center">
                      <svg className="w-6 h-6 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                      </svg>
                    </div>
                  </div>
                  <div className="text-sm font-medium text-green-600">12%</div>
                </div>
                <h3 className="text-2xl font-bold text-gray-900">8</h3>
                <p className="text-sm text-gray-600">Active Hotspot</p>
                <div className="mt-2 text-xs text-red-500 font-medium">⚠ 3 critical</div>
              </div>

              {/* Fogging Requests */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center space-x-3 mb-4">
                  <div className="w-12 h-12 bg-yellow-100 rounded-xl flex items-center justify-center">
                    <svg className="w-6 h-6 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                  </div>
                </div>
                <h3 className="text-2xl font-bold text-gray-900">12</h3>
                <p className="text-sm text-gray-600">Fogging requests</p>
                <div className="mt-2 space-y-1">
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">High Priority</span>
                    <span className="font-medium">5</span>
                  </div>
                  <div className="flex justify-between text-sm">
                    <span className="text-gray-600">Normal</span>
                    <span className="font-medium">7</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Bottom Section */}
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
              {/* Reports Summary */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center justify-between mb-6">
                  <h3 className="text-lg font-semibold text-gray-900">Reports Summary</h3>
                </div>
                <p className="text-sm text-gray-600 mb-6">Pending reviews and actions</p>
                
                <div className="space-y-4">
                  <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div>
                      <h4 className="font-medium text-gray-900">Field Reports</h4>
                      <p className="text-sm text-gray-600">12 pending confirmations</p>
                    </div>
                    <button className="text-[#4F46E5] hover:text-blue-700 text-sm font-medium">
                      Review
                    </button>
                  </div>
                  
                  <div className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                    <div>
                      <h4 className="font-medium text-gray-900">Lab Results</h4>
                      <p className="text-sm text-gray-600">5 Awaits confirmations</p>
                    </div>
                    <button className="text-[#4F46E5] hover:text-blue-700 text-sm font-medium">
                      View
                    </button>
                  </div>
                </div>
              </div>

              {/* Ongoing Activity */}
              <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
                <div className="flex items-center justify-between mb-6">
                  <h3 className="text-lg font-semibold text-gray-900">Ongoing Activity</h3>
                </div>
                <p className="text-sm text-gray-600 mb-6">Current operations status</p>
                
                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between items-center mb-2">
                      <span className="text-sm font-medium text-gray-900">Sample Collection</span>
                      <span className="text-sm text-gray-600">45%</span>
                    </div>
                    <div className="w-full bg-gray-200 rounded-full h-2">
                      <div className="bg-[#4F46E5] h-2 rounded-full" style={{ width: '45%' }}></div>
                    </div>
                  </div>
                </div>

                {/* Recent Activity */}
                <div className="mt-8">
                  <h4 className="text-md font-semibold text-gray-900 mb-4">Recent Activity</h4>
                  <p className="text-sm text-gray-600 mb-4">Latest updates and notifications</p>
                  
                  <div className="space-y-3">
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <p className="text-sm font-medium text-gray-900">New hotspot identified</p>
                        <p className="text-xs text-gray-600">High-risk area detected in North Region</p>
                      </div>
                      <span className="text-xs text-gray-500">Today</span>
                    </div>
                    
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <p className="text-sm font-medium text-gray-900">Fogging request completed</p>
                        <p className="text-xs text-gray-600">Operation completed in Colombo District</p>
                      </div>
                      <span className="text-xs text-gray-500">May 16, 2025</span>
                    </div>
                    
                    <div className="flex justify-between items-start">
                      <div className="flex-1">
                        <p className="text-sm font-medium text-gray-900">Report submitted</p>
                        <p className="text-xs text-gray-600">Weekly surveillance report for South Zone</p>
                      </div>
                      <span className="text-xs text-gray-500">Feb 20, 2025</span>
                    </div>
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

export default DashboardPage;
