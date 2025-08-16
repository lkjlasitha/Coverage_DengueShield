'use client';

import React from 'react';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';

const ReportsPage: React.FC = () => {
  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        <Sidebar />
        <div className="flex-1 ml-64">
          <header className="bg-white border-b border-gray-200 px-6 py-4">
            <h1 className="text-2xl font-bold text-gray-900">Reports</h1>
          </header>
          <main className="p-6">
            <div className="bg-white rounded-xl p-8 shadow-sm border border-gray-100 text-center">
              <h2 className="text-xl font-semibold text-gray-900 mb-4">Reports & Analytics</h2>
              <p className="text-gray-600">Reporting system will be implemented here</p>
            </div>
          </main>
        </div>
      </div>
    </ProtectedRoute>
  );
};

export default ReportsPage;
