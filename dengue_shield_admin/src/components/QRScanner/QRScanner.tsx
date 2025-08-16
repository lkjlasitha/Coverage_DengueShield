'use client';

import React, { useEffect, useRef, useState } from 'react';
import { BrowserMultiFormatReader, NotFoundException } from '@zxing/library';

interface QRScannerProps {
  isOpen: boolean;
  onClose: () => void;
  onScan: (result: string) => void;
}

const QRScanner: React.FC<QRScannerProps> = ({ isOpen, onClose, onScan }) => {
  const videoRef = useRef<HTMLVideoElement>(null);
  const [codeReader, setCodeReader] = useState<BrowserMultiFormatReader | null>(null);
  const [error, setError] = useState<string>('');
  const [isScanning, setIsScanning] = useState(false);

  useEffect(() => {
    if (isOpen) {
      const reader = new BrowserMultiFormatReader();
      setCodeReader(reader);
      startScanning(reader);
    } else {
      stopScanning();
    }

    return () => {
      stopScanning();
    };
  }, [isOpen]);

  const startScanning = async (reader: BrowserMultiFormatReader) => {
    try {
      setIsScanning(true);
      setError('');

      const videoInputDevices = await reader.listVideoInputDevices();
      if (videoInputDevices.length === 0) {
        setError('No camera found');
        return;
      }

      // Use the first available camera (usually back camera on mobile)
      const firstDeviceId = videoInputDevices[0].deviceId;

      reader.decodeFromVideoDevice(firstDeviceId, videoRef.current!, (result, error) => {
        if (result) {
          onScan(result.getText());
          onClose();
        }
        if (error && !(error instanceof NotFoundException)) {
          console.error('QR Scanner error:', error);
        }
      });
    } catch (err) {
      setError('Failed to start camera');
      console.error('Scanner initialization error:', err);
    }
  };

  const stopScanning = () => {
    if (codeReader) {
      codeReader.reset();
    }
    setIsScanning(false);
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
        <div className="flex justify-between items-center mb-4">
          <h3 className="text-lg font-semibold text-gray-900">Scan QR Code</h3>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600"
          >
            <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>

        <div className="relative">
          <video
            ref={videoRef}
            className="w-full h-64 bg-gray-100 rounded-lg object-cover"
            autoPlay
            playsInline
            muted
          />
          
          {/* Scanning overlay */}
          <div className="absolute inset-0 border-2 border-blue-500 rounded-lg pointer-events-none">
            <div className="absolute top-0 left-0 w-8 h-8 border-t-4 border-l-4 border-blue-500"></div>
            <div className="absolute top-0 right-0 w-8 h-8 border-t-4 border-r-4 border-blue-500"></div>
            <div className="absolute bottom-0 left-0 w-8 h-8 border-b-4 border-l-4 border-blue-500"></div>
            <div className="absolute bottom-0 right-0 w-8 h-8 border-b-4 border-r-4 border-blue-500"></div>
          </div>
        </div>

        {error && (
          <div className="mt-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
            {error}
          </div>
        )}

        <div className="mt-4 text-center">
          <p className="text-sm text-gray-600">
            Position the QR code within the frame to scan
          </p>
        </div>

        <div className="mt-6 flex justify-end space-x-3">
          <button
            onClick={onClose}
            className="px-4 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  );
};

export default QRScanner;
