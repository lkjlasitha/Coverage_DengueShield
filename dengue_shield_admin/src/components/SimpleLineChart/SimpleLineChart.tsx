import React from 'react';

interface SimpleLineChartProps {
  data: number[];
  height?: number;
  color?: string;
  className?: string;
}

const SimpleLineChart: React.FC<SimpleLineChartProps> = ({
  data,
  height = 60,
  color = 'stroke-green-500',
  className = '',
}) => {
  const maxValue = Math.max(...data);
  const minValue = Math.min(...data);
  const range = maxValue - minValue || 1;
  
  const points = data.map((value, index) => {
    const x = (index / (data.length - 1)) * 100;
    const y = 100 - ((value - minValue) / range) * 100;
    return `${x},${y}`;
  }).join(' ');

  return (
    <div className={`${className}`} style={{ height }}>
      <svg
        width="100%"
        height="100%"
        viewBox="0 0 100 100"
        preserveAspectRatio="none"
        className="overflow-visible"
      >
        <polyline
          fill="none"
          stroke="currentColor"
          strokeWidth="2"
          points={points}
          className={color}
        />
        {data.map((value, index) => {
          const x = (index / (data.length - 1)) * 100;
          const y = 100 - ((value - minValue) / range) * 100;
          return (
            <circle
              key={index}
              cx={x}
              cy={y}
              r="2"
              fill="currentColor"
              className={color.replace('stroke-', 'text-')}
            />
          );
        })}
      </svg>
    </div>
  );
};

export default SimpleLineChart;
