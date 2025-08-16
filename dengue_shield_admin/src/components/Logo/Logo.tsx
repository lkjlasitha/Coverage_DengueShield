import React from 'react';
import Image from 'next/image';

interface LogoProps {
    className?: string;
    size?: 'sm' | 'md' | 'lg';
}

const Logo: React.FC<LogoProps> = ({ className = '', size = 'md' }) => {
    const sizeClasses = {
        sm: 'h-12 w-12',
        md: 'h-20 w-20',
        lg: 'h-28 w-28',
    };

    return (
        <div className={`flex items-center justify-center bg-transparent ${className}`}>
            <Image
                src="/denguelogo.svg"
                alt="DengueShield Logo"
                width={size === 'sm' ? 48 : size === 'md' ? 80 : 112}
                height={size === 'sm' ? 48 : size === 'md' ? 80 : 112}
                className="object-contain"
            />
        </div>
    );
};

export default Logo;
