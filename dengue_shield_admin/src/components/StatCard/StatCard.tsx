import React from 'react';

interface StatCardProps {
  title: string;
  value: string | number;
  icon: React.ReactNode;
  iconBgColor: string;
  change?: string;
  changeType?: 'positive' | 'negative' | 'neutral';
  subtitle?: string;
}

const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  icon,
  iconBgColor,
  change,
  changeType = 'neutral',
  subtitle,
}) => {
  const getChangeColor = () => {
    switch (changeType) {
      case 'positive':
        return 'text-green-600';
      case 'negative':
        return 'text-red-600';
      default:
        return 'text-gray-600';
    }
  };

  return (
    <div className="bg-white rounded-xl p-6 shadow-sm border border-gray-100">
      <div className="flex items-start justify-between">
        <div className="flex-1">
          <div className="flex items-center space-x-3 mb-2">
            <div className={`w-12 h-12 ${iconBgColor} rounded-xl flex items-center justify-center`}>
              {icon}
            </div>
            {change && (
              <div className={`text-sm font-medium ${getChangeColor()}`}>
                {change}
              </div>
            )}
          </div>
          <h3 className="text-2xl font-bold text-gray-900">{value}</h3>
          <p className="text-sm text-gray-600 mt-1">{title}</p>
          {subtitle && (
            <p className="text-xs text-gray-500 mt-1">{subtitle}</p>
          )}
        </div>
      </div>
    </div>
  );
};

export default StatCard;
