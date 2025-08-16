'use client';

import React, { useState, useEffect } from 'react';
import ProtectedRoute from '@/components/ProtectedRoute';
import Sidebar from '@/components/Sidebar';
import QRScanner from '@/components/QRScanner';

interface Appointment {
  PDF: boolean;
  category: string;
  date: string;
  email: string;
  hospitalName: string;
  jwt: string;
  referenceNum: string;
  time: string;
  status?: 'Not Started' | 'Ongoing' | 'Completed';
}

const BookingsPage: React.FC = () => {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const [filteredAppointments, setFilteredAppointments] = useState<Appointment[]>([]);
  const [searchTerm, setSearchTerm] = useState('');
  const [sortBy, setSortBy] = useState('date');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('desc');
  const [statusFilter, setStatusFilter] = useState<string>('all');
  const [isLoading, setIsLoading] = useState(true);
  const [isQrScannerOpen, setIsQrScannerOpen] = useState(false);

  // Fetch appointments from API
  useEffect(() => {
    fetchAppointments();
  }, []);

  const fetchAppointments = async () => {
    try {
      setIsLoading(true);
      const token = localStorage.getItem('auth_token');
      
      const response = await fetch('http://16.171.60.189:5000/appointments', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });

      if (response.ok) {
        const data = await response.json();
        // Add default status if not present
        const appointmentsWithStatus = data.map((apt: Appointment) => ({
          ...apt,
          status: apt.status || 'Not Started'
        }));
        setAppointments(appointmentsWithStatus);
        setFilteredAppointments(appointmentsWithStatus);
      } else {
        console.error('Failed to fetch appointments');
        setAppointments([]);
        setFilteredAppointments([]);
      }
    } catch (error) {
      console.error('Error fetching appointments:', error);
      setAppointments([]);
      setFilteredAppointments([]);
    } finally {
      setIsLoading(false);
    }
  };

  // Filter and sort appointments
  useEffect(() => {
    let filtered = [...appointments];

    // Filter by search term (reference number or email)
    if (searchTerm) {
      filtered = filtered.filter(apt => 
        apt.referenceNum.toLowerCase().includes(searchTerm.toLowerCase()) ||
        apt.email.toLowerCase().includes(searchTerm.toLowerCase())
      );
    }

    // Filter by status
    if (statusFilter !== 'all') {
      filtered = filtered.filter(apt => apt.status === statusFilter);
    }

    // Sort appointments
    filtered.sort((a, b) => {
      let aValue: any, bValue: any;
      
      switch (sortBy) {
        case 'date':
          aValue = new Date(a.date + ' ' + a.time);
          bValue = new Date(b.date + ' ' + b.time);
          break;
        case 'referenceNum':
          aValue = a.referenceNum;
          bValue = b.referenceNum;
          break;
        case 'status':
          aValue = a.status || 'Not Started';
          bValue = b.status || 'Not Started';
          break;
        default:
          aValue = a.date;
          bValue = b.date;
      }

      if (sortOrder === 'asc') {
        return aValue > bValue ? 1 : -1;
      } else {
        return aValue < bValue ? 1 : -1;
      }
    });

    setFilteredAppointments(filtered);
  }, [appointments, searchTerm, sortBy, sortOrder, statusFilter]);

  // Update appointment status
  const updateAppointmentStatus = async (referenceNum: string, newStatus: string) => {
    try {
      const token = localStorage.getItem('auth_token');
      
      const response = await fetch('/api/appointments', {
        method: 'PUT',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          referenceNum,
          status: newStatus
        })
      });

      if (response.ok) {
        // Update local state
        setAppointments(prev => 
          prev.map(apt => 
            apt.referenceNum === referenceNum 
              ? { ...apt, status: newStatus as 'Not Started' | 'Ongoing' | 'Completed' }
              : apt
          )
        );
      } else {
        console.error('Failed to update appointment status');
        // Still update local state for demo purposes
        setAppointments(prev => 
          prev.map(apt => 
            apt.referenceNum === referenceNum 
              ? { ...apt, status: newStatus as 'Not Started' | 'Ongoing' | 'Completed' }
              : apt
          )
        );
      }
    } catch (error) {
      console.error('Error updating appointment status:', error);
      // Update local state anyway for demo
      setAppointments(prev => 
        prev.map(apt => 
          apt.referenceNum === referenceNum 
            ? { ...apt, status: newStatus as 'Not Started' | 'Ongoing' | 'Completed' }
            : apt
        )
      );
    }
  };

  // QR Code scanner function
  const handleQrScan = () => {
    setIsQrScannerOpen(true);
  };

  const handleQrResult = (result: string) => {
    // Extract reference number from QR code result
    // Assuming the QR code contains the reference number directly
    // You might need to parse JSON or extract from a URL depending on QR format
    try {
      // If QR contains JSON
      const parsed = JSON.parse(result);
      if (parsed.referenceNum) {
        setSearchTerm(parsed.referenceNum);
      } else {
        setSearchTerm(result); // Use raw result as reference number
      }
    } catch {
      // If not JSON, use the result directly
      setSearchTerm(result);
    }
  };

  const getStatusBadgeColor = (status: string) => {
    switch (status) {
      case 'Completed':
        return 'bg-green-100 text-green-800';
      case 'Ongoing':
        return 'bg-yellow-100 text-yellow-800';
      case 'Not Started':
        return 'bg-gray-100 text-gray-800';
      default:
        return 'bg-gray-100 text-gray-800';
    }
  };

  return (
    <ProtectedRoute requireAuth={true}>
      <div className="flex h-screen bg-white">
        <Sidebar />
        <div className="flex-1 ml-64">
          <header className="bg-white border-b border-gray-200 px-6 py-4 flex items-center justify-between">
            <h1 className="text-2xl font-bold text-gray-900">Bookings</h1>
            <div className="flex items-center space-x-4">
              <span className="text-sm text-gray-600">10-08-2025</span>
              <div className="w-6 h-6 bg-gray-300 rounded"></div>
              <div className="w-8 h-8 bg-blue-500 rounded-full"></div>
            </div>
          </header>
          
          <main className="p-6">
            {/* Search and Filter Bar */}
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-6 mb-6">
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center space-x-4 flex-1 min-w-0">
                  {/* Search */}
                  <div className="relative flex-1 max-w-sm">
                    <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                      <svg className="h-5 w-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                      </svg>
                    </div>
                    <input
                      type="text"
                      placeholder="Search by reference number or email"
                      value={searchTerm}
                      onChange={(e) => setSearchTerm(e.target.value)}
                      className="block w-full pl-10 pr-3 py-2 border border-gray-300 rounded-lg leading-5 bg-white placeholder-gray-500 focus:outline-none focus:placeholder-gray-400 focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                    />
                  </div>

                  {/* Filter */}
                  <button className="flex items-center space-x-2 px-4 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white hover:bg-gray-50 flex-shrink-0">
                    <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.414A1 1 0 013 6.707V4z" />
                    </svg>
                    <span>Filter</span>
                  </button>

                  {/* QR Scanner */}
                  <button 
                    onClick={handleQrScan}
                    className="flex items-center space-x-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 flex-shrink-0"
                  >
                    <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 16h4m-4 0v1m-2.5-5a2.5 2.5 0 11-5 0 2.5 2.5 0 015 0z" />
                    </svg>
                    <span>Scan QR</span>
                  </button>
                </div>

                {/* Sort and Status Filter */}
                <div className="flex items-center space-x-4 flex-shrink-0">
                  <select
                    value={statusFilter}
                    onChange={(e) => setStatusFilter(e.target.value)}
                    className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  >
                    <option value="all">All Status</option>
                    <option value="Not Started">Not Started</option>
                    <option value="Ongoing">Ongoing</option>
                    <option value="Completed">Completed</option>
                  </select>

                  <select
                    value={sortBy}
                    onChange={(e) => setSortBy(e.target.value)}
                    className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
                  >
                    <option value="date">Sort by Date</option>
                    <option value="referenceNum">Sort by Reference</option>
                    <option value="status">Sort by Status</option>
                  </select>

                  <button
                    onClick={() => setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc')}
                    className="px-3 py-2 border border-gray-300 rounded-lg text-gray-700 bg-white hover:bg-gray-50"
                  >
                    {sortOrder === 'asc' ? '↑' : '↓'}
                  </button>
                </div>
              </div>

              {/* Table */}
              <div className="overflow-hidden">
                {isLoading ? (
                  <div className="flex justify-center py-8">
                    <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-600"></div>
                  </div>
                ) : (
                  <table className="min-w-full">
                    <thead>
                      <tr className="border-b border-gray-200">
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Date</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Time</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Name</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Email</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Test</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Hospital Name</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Documents</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Reference No</th>
                        <th className="text-left py-3 px-4 text-sm font-medium text-gray-700">Status</th>
                      </tr>
                    </thead>
                    <tbody className="divide-y divide-gray-100">
                      {filteredAppointments.map((appointment, index) => (
                        <tr key={index} className="hover:bg-gray-50">
                          <td className="py-4 px-4 text-sm text-gray-900">
                            {new Date(appointment.date).toLocaleDateString('en-GB')}
                          </td>
                          <td className="py-4 px-4 text-sm text-gray-900">{appointment.time}</td>
                          <td className="py-4 px-4 text-sm text-gray-900">Name</td>
                          <td className="py-4 px-4 text-sm text-gray-600">{appointment.email}</td>
                          <td className="py-4 px-4 text-sm text-gray-600">{appointment.category}</td>
                          <td className="py-4 px-4 text-sm text-gray-600">{appointment.hospitalName}</td>
                          <td className="py-4 px-4">
                            <span className={`text-xs font-medium ${appointment.PDF ? 'text-green-600' : 'text-red-600'}`}>
                              {appointment.PDF ? 'Yes' : 'No'}
                            </span>
                          </td>
                          <td className="py-4 px-4 text-sm text-gray-900">{appointment.referenceNum}</td>
                          <td className="py-4 px-4">
                            <select
                              value={appointment.status}
                              onChange={(e) => updateAppointmentStatus(appointment.referenceNum, e.target.value)}
                              className={`text-xs font-medium px-3 py-1 rounded-full border-0 focus:ring-2 focus:ring-blue-500 ${getStatusBadgeColor(appointment.status || 'Not Started')}`}
                            >
                              <option value="Not Started">Not Started</option>
                              <option value="Ongoing">Ongoing</option>
                              <option value="Completed">Completed</option>
                            </select>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                )}

                {!isLoading && filteredAppointments.length === 0 && (
                  <div className="text-center py-8 text-gray-500">
                    No appointments found
                  </div>
                )}
              </div>
            </div>
          </main>
        </div>

        {/* QR Scanner Modal */}
        <QRScanner
          isOpen={isQrScannerOpen}
          onClose={() => setIsQrScannerOpen(false)}
          onScan={handleQrResult}
        />
      </div>
    </ProtectedRoute>
  );
};

export default BookingsPage;