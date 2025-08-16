import React from 'react';
import LoadingSpinner from './LoadingSpinner';

const PageLoading: React.FC = () => {
  return (
    <div className="flex flex-col min-h-screen overflow-y-auto">
      <div className="fixed inset-0 -z-10 w-full h-full">
        {/* <BackgroundTransition /> */}
      </div>
      <div className="flex-1 flex items-center justify-center">
        <div className="flex flex-col items-center space-y-4">
          <LoadingSpinner size="large" />
        </div>
      </div>
    </div>
  );
};

export default PageLoading;
