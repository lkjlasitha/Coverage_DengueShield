import React from 'react';

interface SimpleBarChartProps {
  data: number[];
  height?: number;
  color?: string;
  className?: string;
}

const SimpleBarChart: React.FC<SimpleBarChartProps> = ({
  data,
  height = 60,
  color = 'bg-blue-500',
  className = '',
}) => {
  const maxValue = Math.max(...data);

  return (
    <div className={`flex items-end space-x-1 ${className}`} style={{ height }}>
      {data.map((value, index) => {
        const barHeight = (value / maxValue) * height;
        return (
          <div
            key={index}
            className={`${color} rounded-t-sm flex-1 transition-all duration-300 hover:opacity-80`}
            style={{ height: `${barHeight}px` }}
            title={`Value: ${value}`}
          />
        );
      })}
    </div>
  );
};

export default SimpleBarChart;
